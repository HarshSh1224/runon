import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Doctor {
  String id;
  String name;
  double fees;
  String qualifications;
  String? email;

  Doctor({
    required this.id,
    required this.name,
    required this.fees,
    required this.qualifications,
    this.email,
  });

  factory Doctor.fromMap(Map<String, dynamic> json, id) {
    return Doctor(
      id: id,
      name: json['name'],
      fees: json['fees'],
      qualifications: json['qualification'],
      email: json['email'],
    );
  }

  Future<bool> isFree() async {
    final response = await FirebaseFirestore.instance.collection('appointments').get();
    for (int i = 0; i < response.docs.length; i++) {
      if (response.docs[i].data().containsKey('archived') &&
          response.docs[i].data()['archived'] == true) continue;
      if (response.docs[i].data()['doctorId'] == id) return false;
    }
    return true;
  }
}

class Doctors with ChangeNotifier {
  List<Doctor> _doctors = [];

  List<Doctor> get doctors {
    return [..._doctors];
  }

  Doctor? doctorFromId(String doctorId) {
    for (int i = 0; i < _doctors.length; i++) {
      if (_doctors[i].id == doctorId) return _doctors[i];
    }
    return null;
  }

  Future<void> fetchAndSetDoctors() async {
    try {
      final fetchedData = await FirebaseFirestore.instance.collection('doctors').get();
      final fetchedDoctors = fetchedData.docs;

      List<Doctor> temp = [];

      for (int i = 0; i < fetchedDoctors.length; i++) {
        // print('object');
        if (fetchedDoctors[i].data().containsKey('archived') &&
            fetchedDoctors[i]['archived'] == true) continue;
        temp.add(
          Doctor(
            id: fetchedDoctors[i].id,
            name: fetchedDoctors[i]['name'],
            fees: double.tryParse('${fetchedDoctors[i]['fees']}') == null
                ? -1
                : double.parse('${fetchedDoctors[i]['fees']}'),
            qualifications: fetchedDoctors[i]['qualification'],
            email:
                (fetchedDoctors[i].data()).containsKey('email') ? fetchedDoctors[i]['email'] : null,
          ),
        );
      }
      _doctors = temp;
    } catch (error) {
      print(error);
    }
  }

  updateDoctor(Doctor doctor) {
    for (int i = 0; i < _doctors.length; i++) {
      if (_doctors[i].id == doctor.id) {
        _doctors[i] = doctor;
        notifyListeners();
        return;
      }
    }
  }
}
