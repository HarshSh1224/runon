import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:runon/misc/constants/app_constants.dart';

extension UserTypeExtension on String {
  String slotIdDatePart() => substring(0, 8);
  String slotIdTimePart() => substring(8, 10);
}

class Database {
  static const String _slotsCollection = "slots";
  static const String _doctorsCollection = "doctors";
  static const String _youtubeFeed = "youtube_feed";
  static const String _offlineSlotsCollection = "offline_slots";

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

  static Future deleteDocumentListValue({
    required String collection,
    required String docId,
    required String fieldKey,
    required String valueId,
    Function()? onDone,
  }) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference collection0 = firestore.collection(collection);
    DocumentReference document = collection0.doc(docId);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(document);

      if (!snapshot.exists) {
        print("Document doesn't exit");
        return false;
      }

      final currentData = (snapshot.data() ?? {}) as Map<String, dynamic>;
      var currentList = (currentData[fieldKey] ?? []) as List;
      int? index;
      String matchKey = AppConstants.id;

      index = currentList.indexWhere((element) => element == valueId);
      if (index != -1) currentList.removeAt(index);

      transaction.update(document, {fieldKey: currentList});
    }).then((value) {
      print("List successfully updated");
      if (onDone != null) onDone();
    }).catchError((error) => print("Failed to update list"));
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
    if (doctorId == AppConstants.offlineDoctorId) {
      final String date = slotId.slotIdDatePart();
      print(_offlineSlotsCollection);
      print(date);
      deleteDocumentListValue(
          collection: _offlineSlotsCollection,
          docId: date,
          fieldKey: AppConstants.booked,
          valueId: slotId.slotIdTimePart());

      return;
    }
    appendValueToDocumentList(
        collection: '$_doctorsCollection/$doctorId/$_slotsCollection',
        docId: slotId.slotIdDatePart(),
        fieldKey: "slots",
        update: slotId.slotIdTimePart());
  }

  static Future bookOfflineSlot(String slotId) async {
    await appendValueToDocumentList(
        collection: _offlineSlotsCollection,
        docId: slotId.slotIdDatePart(),
        fieldKey: AppConstants.booked,
        update: slotId.slotIdTimePart());
  }

  static Future<void> sendChatMessage(
      {required String appointmentId,
      required String type,
      required String text,
      String? title}) async {
    await FirebaseFirestore.instance.collection('appointments/$appointmentId/messages').add({
      'type': type,
      'text': text,
      'title': title,
      'createdAt': DateTime.now().toIso8601String(),
      'createdBy': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  static Future<List<Map<String, dynamic>>> downloadYoutubeFeed() async {
    List<Map<String, dynamic>> youtubeFeed = [];
    try {
      final response = await FirebaseFirestore.instance.collection(_youtubeFeed).get();
      for (int i = 0; i < response.docs.length; i++) {
        final element = response.docs[i];
        youtubeFeed.add(element.data());
      }
      return youtubeFeed;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<String>> fetchBookedOfflineSlotsList(String date) async {
    try {
      final response =
          await FirebaseFirestore.instance.collection(_offlineSlotsCollection).doc(date).get();
      return (response.data()?[AppConstants.booked].cast<String>() ?? ['']);
    } catch (e) {
      print(e.toString());
    }
    return [];
  }
}
