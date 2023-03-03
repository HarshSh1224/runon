import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Appointment {
  String appointmentId;
  String patientId;
  String doctorId;
  String issueId;
  String slotId;
  String? prescriptionId;
  List<String>? reportUrl;

  Appointment(
      {required this.appointmentId,
      required this.patientId,
      required this.doctorId,
      required this.issueId,
      required this.slotId,
      this.prescriptionId,
      this.reportUrl});
}

class Appointments with ChangeNotifier {
  List<Appointment> _appointments = [];

  List<Appointment> get appointments {
    return [..._appointments];
  }

  Future<void> fetchAndSetAppointments() async {
    try {
      final response =
          await FirebaseFirestore.instance.collection('appointments').get();
      // print(response.docs[0].data()['reportUrl']);
      List<Appointment> temp = [];
      for (int i = 0; i < response.docs.length; i++) {
        List<String> tempList = [];
        response.docs[i].data()['reportUrl'].map((el) {
          // print(el);
          tempList.add('$el');
        }).toList();
        temp.add(
          Appointment(
            appointmentId: response.docs[i].id,
            patientId: response.docs[i].data()['patientId'],
            doctorId: response.docs[i].data()['doctorId'],
            issueId: response.docs[i].data()['issueId'],
            slotId: response.docs[i].data()['slotId'],
            reportUrl: tempList,
          ),
        );
      }
      _appointments = temp;
      // print('TEMP IS $temp');
    } catch (error) {
      rethrow;
    }
  }

  List<Appointment> getAppointmentsById(String id) {
    return _appointments.where((element) => element.patientId == id).toList();
  }
}
