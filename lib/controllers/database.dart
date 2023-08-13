import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  static Future<Map<String, dynamic>> downloadDoc(
      {required String collection, required String docId}) async {
    final doc = await FirebaseFirestore.instance.collection(collection).doc(docId).get();
    return doc.data() as Map<String, dynamic>;
  }
}
