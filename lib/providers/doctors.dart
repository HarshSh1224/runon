import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Doctor {
  String id;
  String name;
  double fees;
  String qualifications;

  Doctor({
    required this.id,
    required this.name,
    required this.fees,
    required this.qualifications,
  });
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
      final fetchedData =
          await FirebaseFirestore.instance.collection('doctors').get();
      final fetchedDoctors = fetchedData.docs;

      List<Doctor> temp = [];

      for (int i = 0; i < fetchedDoctors.length; i++) {
        // print('object');
        temp.add(
          Doctor(
            id: fetchedDoctors[i].id,
            name: fetchedDoctors[i]['name'],
            fees: double.tryParse('${fetchedDoctors[i]['fees']}') == null
                ? -1
                : double.parse('${fetchedDoctors[i]['fees']}'),
            qualifications: fetchedDoctors[i]['qualification'],
          ),
        );
      }
      _doctors = temp;
    } catch (error) {
      print(error);
    }
  }
}
