import 'package:runon/misc/constants/app_constants.dart';
import 'package:runon/providers/appointments.dart';

class Call {
  String channelId;
  DateTime callCreateTime;
  Appointment appointment;
  String doctorId;
  String patientId;
  String doctorName;
  String patientName;
  String doctorProfilePic;
  String patientProfilePic;

  Call({
    required this.channelId,
    required this.callCreateTime,
    required this.appointment,
    required this.doctorId,
    required this.patientId,
    required this.doctorName,
    required this.patientName,
    required this.doctorProfilePic,
    required this.patientProfilePic,
  });

  Map<String, dynamic> toMap() {
    return {
      AppConstants.channelId: channelId,
      AppConstants.callCreateTime: callCreateTime.toIso8601String(),
      AppConstants.appointment: appointment.toMap(),
      AppConstants.doctorId: doctorId,
      AppConstants.patientId: patientId,
      AppConstants.doctorName: doctorName,
      AppConstants.patientName: patientName,
      AppConstants.doctorProfilePic: doctorProfilePic,
      AppConstants.patientProfilePic: patientProfilePic,
    };
  }

  factory Call.fromMap(Map<String, dynamic> json) {
    return Call(
      channelId: json[AppConstants.channelId],
      callCreateTime: DateTime.parse(json[AppConstants.callCreateTime]),
      appointment: Appointment.fromMap(json[AppConstants.appointment]),
      doctorId: json[AppConstants.doctorId],
      patientId: json[AppConstants.patientId],
      doctorName: json[AppConstants.doctorName],
      patientName: json[AppConstants.patientName],
      doctorProfilePic: json[AppConstants.doctorProfilePic],
      patientProfilePic: json[AppConstants.patientProfilePic],
    );
  }
}
