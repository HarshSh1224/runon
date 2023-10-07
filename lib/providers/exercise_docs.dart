import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:runon/controllers/database.dart';

class ExerciseDocument {
  String id;
  String title;
  String url;

  // Temp Storage only
  bool? isSent;

  ExerciseDocument({
    required this.id,
    required this.title,
    required this.url,
  });

  factory ExerciseDocument.fromJson(Map<String, dynamic> json) {
    return ExerciseDocument(
      id: json['id'],
      title: json['title'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'url': url,
    };
  }
}

class ExerciseDocuments with ChangeNotifier {
  List<ExerciseDocument> _exerciseDocuments = [];

  List<ExerciseDocument> get exerciseDocuments {
    return [..._exerciseDocuments];
  }

  Future<void> fetchAndSetExerciseDocuments() async {
    try {
      final response = await FirebaseFirestore.instance.collection('exercise_docs').get();
      List<ExerciseDocument> temp = [];
      for (int i = 0; i < response.docs.length; i++) {
        temp.add(
          ExerciseDocument(
            id: response.docs[i].id,
            title: response.docs[i].data()['title'],
            url: response.docs[i].data()['url'],
          ),
        );
      }
      _exerciseDocuments = temp;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> sendExerciseDocument(String id, String appointmentId) async {
    int index = _exerciseDocuments.indexWhere((element) => element.id == id);
    if (index != -1) {
      if (_exerciseDocuments[index].isSent != null && _exerciseDocuments[index].isSent!) return;
      _exerciseDocuments[index].isSent = true;
      await Database.sendChatMessage(
          appointmentId: appointmentId,
          type: 'file',
          text: _exerciseDocuments[index].url,
          title: _exerciseDocuments[index].title);
      notifyListeners();
    }
  }
}
