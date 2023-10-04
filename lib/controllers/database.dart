import 'package:cloud_firestore/cloud_firestore.dart';

extension UserTypeExtension on String {
  String slotIdDatePart() => substring(0, 8);
  String slotIdTimePart() => substring(8, 10);
}

class Database {
  static const String _slotsCollection = "slots";
  static const String _doctorsCollection = "doctors";

  static Future<Map<String, dynamic>> downloadDoc(
      {required String collection, required String docId}) async {
    final doc = await FirebaseFirestore.instance.collection(collection).doc(docId).get();
    return doc.data() as Map<String, dynamic>;
  }

  static uploadDocument(
      {required String collection,
      required String docId,
      required Map<String, dynamic> content}) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference collection0 = firestore.collection(collection);
    DocumentReference document = collection0.doc(docId);

    await document
        .set(content)
        .whenComplete(() => print("successfully uploaded"))
        .catchError((e) => print(e));
  }

  static Future appendValueToDocumentList({
    required String collection,
    required String docId,
    required String fieldKey,
    required dynamic update,
    Function()? onDone,
    bool createIfNone = true,
    bool ignoreDupes = false,
  }) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference collection0 = firestore.collection(collection);
    DocumentReference document = collection0.doc(docId);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(document);

      if (!snapshot.exists) {
        print("Document doesn't exist");
        if (createIfNone) {
          await uploadDocument(collection: collection, docId: docId, content: {fieldKey: []});
          print("Created new doc with field key $fieldKey in $collection");
          return true;
        } else {
          return false;
        }
      }
      final currentData = (snapshot.data() ?? {}) as Map<String, dynamic>;
      final currentList = (currentData[fieldKey] ?? []) as List;
      if (ignoreDupes) {
        if (currentList.where((e) => e == update).isNotEmpty) {
          print("Item already exists in list, so it was not added.");
          return false;
        }
      }
      currentList.add(update);
      transaction.update(document, {fieldKey: currentList});

      return true;
    }).then((value) {
      print("List successfully updated");
      if (onDone != null) onDone();
    }).catchError((error) {
      print("Failed to update list");
      print(error);
    });
  }

  static Future addSlotToDoctor({required String slotId, required String doctorId}) async {
    appendValueToDocumentList(
        collection: '$_doctorsCollection/$doctorId/$_slotsCollection',
        docId: slotId.slotIdDatePart(),
        fieldKey: "slots",
        update: slotId.slotIdTimePart());
  }
}
