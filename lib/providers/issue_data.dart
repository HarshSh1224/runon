import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Issue {
  String id;
  String title;

  Issue(this.id, this.title);
}

class IssueData with ChangeNotifier {
  List<Issue> _issueData = [];

  List<Issue> get issueData {
    return [..._issueData];
  }

  void notifyyListeners() {
    notifyListeners();
  }

  Future<void> addIssue(String title) async {
    String newId = 'I${issueData.length + 1}';
    try {
      await FirebaseFirestore.instance.collection('issues').doc(newId).set({'title': title});
    } catch (error) {
      debugPrint(error.toString());
    }
    issueData.add(Issue(newId, title));
    notifyListeners();
  }

  Future<void> fetchAndSetIssues() async {
    try {
      final fetchedData = await FirebaseFirestore.instance.collection('issues').get();

      final fetchedDocsList = fetchedData.docs;

      List<Issue> temp = [];

      for (int i = 0; i < fetchedDocsList.length; i++) {
        temp.add(Issue(fetchedDocsList[i].id, fetchedDocsList[i]['title']));
      }
      _issueData = temp;
    } catch (err) {
      print(err);
    }
  }

  String issueFromId(String id) {
    int i = _issueData.indexWhere((element) => element.id == id);
    return _issueData[i].title;
  }
}
