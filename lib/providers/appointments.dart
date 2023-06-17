import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Timeline {
  String createdOn;
  String paymentId;
  double paymentAmount;
  List<String> prescriptionList;
  String slotId;
  bool? isMissed;

  Timeline({
    required this.createdOn,
    required this.paymentAmount,
    required this.paymentId,
    required this.prescriptionList,
    required this.slotId,
    this.isMissed,
  });
}

class Appointment {
  String appointmentId;
  String patientId;
  String doctorId;
  String issueId;
  String slotId;
  String? prescriptionId;
  List<Timeline>? timelines;
  List<String>? reports;

  Appointment({
    required this.appointmentId,
    required this.patientId,
    required this.doctorId,
    required this.issueId,
    required this.slotId,
    required this.timelines,
    this.prescriptionId,
    this.reports,
  });
}

class Appointments with ChangeNotifier {
  List<Appointment> _appointments = [];

  List<Appointment> get appointments {
    return [..._appointments];
  }

  Future<List<Timeline>> fetchTimleines(String appointmentId) async {
    List<Timeline> timelinesList = [];

    final response =
        await FirebaseFirestore.instance.collection('appointments/$appointmentId/timeline').get();

    for (int i = 0; i < response.docs.length; i++) {
      final timeline = response.docs[i].data();

      List<String> tempList = [];
      response.docs[i].data()['prescriptionList'].map((el) {
        tempList.add('$el');
      }).toList();

      timelinesList.add(Timeline(
        createdOn: timeline['createdOn'],
        paymentAmount: timeline['paymentAmount'],
        paymentId: timeline['paymentId'],
        prescriptionList: tempList,
        slotId: timeline['slotId'],
      ));
    }

    return timelinesList;
  }

  Future<void> fetchAndSetAppointments() async {
    try {
      final response = await FirebaseFirestore.instance.collection('appointments').get();
      // print(response.docs[0].data()['timelines']);
      List<Appointment> temp = [];
      for (int i = 0; i < response.docs.length; i++) {
        List<String> tempList = [];

        response.docs[i].data()['reportUrl'].map((el) {
          tempList.add('$el');
        }).toList();

        temp.add(
          Appointment(
            appointmentId: response.docs[i].id,
            patientId: response.docs[i].data()['patientId'],
            doctorId: response.docs[i].data()['doctorId'],
            issueId: response.docs[i].data()['issueId'],
            slotId: response.docs[i].data()['slotId'],
            timelines: await fetchTimleines(response.docs[i].id),
            reports: tempList,
          ),
        );
      }
      _appointments = temp;
      // print('TEMP IS $temp');
    } catch (error) {
      rethrow;
    }
  }

  List<Appointment> getAppointmentsByPatientId(String id) {
    return _appointments.where((element) => element.patientId == id).toList();
  }

  List<Appointment> getAppointmentsByDoctorId(String id) {
    return _appointments.where((element) => element.doctorId == id).toList();
  }

  Appointment getByAppointmentId(id) {
    int idx = _appointments.indexWhere((element) => element.appointmentId == id);
    return _appointments[idx];
  }
}
