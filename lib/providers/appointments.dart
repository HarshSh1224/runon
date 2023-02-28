import 'package:flutter/material.dart';

class Appointment {
  String appointmentId;
  String patientId;
  String doctorId;
  String problemId;
  String slotId;
  String? prescriptionId;
  String? reportUrl;

  Appointment(
      {required this.appointmentId,
      required this.patientId,
      required this.doctorId,
      required this.problemId,
      required this.slotId,
      this.prescriptionId,
      this.reportUrl});
}

class Appointments with ChangeNotifier {
  List<Appointment> _appointments = [];

  List<Appointment> get appointments {
    return [..._appointments];
  }
}
