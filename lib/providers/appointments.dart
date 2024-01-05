import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:runon/controllers/database.dart';
import 'package:runon/misc/constants/app_constants.dart';
import 'package:runon/providers/slot_timings.dart';
import 'package:runon/utils/app_methods.dart';
import 'package:runon/widgets/method_slotId_to_DateTime.dart';

enum TimelineType { appointment, consultation, cancelled }

class Timeline {
  TimelineType type;
  DateTime createdOn;
  String? paymentId;
  double? paymentAmount;
  List<String> prescriptionList;
  String slotId;
  bool? isMissed;
  bool byDoctor;
  String? refundId;

  Timeline({
    required this.type,
    required this.createdOn,
    this.byDoctor = false,
    this.paymentAmount,
    this.paymentId,
    required this.prescriptionList,
    required this.slotId,
    this.isMissed = false,
    this.refundId,
  });

  // define tomap and from map

  Map<String, dynamic> toMap() {
    final json = {
      AppConstants.createdOn: createdOn.toIso8601String(),
      AppConstants.paymentId: paymentId,
      AppConstants.paymentAmount: paymentAmount,
      AppConstants.prescriptionList: prescriptionList,
      AppConstants.slotId: slotId,
      AppConstants.isMissed: isMissed,
      AppConstants.byDoctor: byDoctor,
      AppConstants.refundId: refundId,
    };

    if (type == TimelineType.cancelled) {
      json[AppConstants.isCancelled] = true;
    } else if (type == TimelineType.consultation) {
      json[AppConstants.byDoctor] = true;
    }

    return json;
  }

  factory Timeline.fromMap(Map<String, dynamic> json) {
    return Timeline(
      type: json.containsKey(AppConstants.isCancelled)
          ? TimelineType.cancelled
          : json.containsKey(AppConstants.byDoctor)
              ? TimelineType.consultation
              : TimelineType.appointment,
      createdOn: DateTime.parse(json[AppConstants.createdOn]),
      paymentId: json[AppConstants.paymentId],
      paymentAmount: json[AppConstants.paymentAmount],
      prescriptionList: json.containsKey(AppConstants.prescriptionList)
          ? json[AppConstants.prescriptionList].map<String>((e) => '$e').toList()
          : [],
      slotId: json[AppConstants.slotId],
      isMissed: json[AppConstants.isMissed],
      byDoctor: json[AppConstants.byDoctor] ?? false,
      refundId: json[AppConstants.refundId],
    );
  }
}

class Appointment {
  String appointmentId;
  String patientId;
  String doctorId;
  String issueId;
  String slotId;
  List<Timeline> timelines;
  List<String>? reports;

  Appointment({
    required this.appointmentId,
    required this.patientId,
    required this.doctorId,
    required this.issueId,
    required this.slotId,
    required this.timelines,
    this.reports,
  });

  Map<String, dynamic> toMap() {
    return {
      AppConstants.appointmentId: appointmentId,
      AppConstants.patientId: patientId,
      AppConstants.doctorId: doctorId,
      AppConstants.issueId: issueId,
      AppConstants.slotId: slotId,
      AppConstants.reportUrl: reports,
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> json) {
    return Appointment(
      appointmentId: json[AppConstants.appointmentId],
      patientId: json[AppConstants.patientId],
      doctorId: json[AppConstants.doctorId],
      issueId: json[AppConstants.issueId],
      slotId: json[AppConstants.slotId],
      timelines: [],
      reports: json.containsKey(AppConstants.reportUrl)
          ? json[AppConstants.reportUrl].map<String>((e) => '$e').toList()
          : [],
    );
  }

  bool get isCancellable {
    return isActive;
  }

  bool get hasPassed {
    if (isCancelled) return true;
    DateTime slot = slotIdTodDateTime(slotId);
    String time = slotTimings[int.parse(slotId.substring(8, 10)).toString()]!;
    slot = slot.add(Duration(hours: int.parse(time.substring(0, 2))));
    slot = slot.add(Duration(minutes: int.parse(time.substring(3, 5))));
    if (time[6] == 'P') slot = slot.add(const Duration(hours: 12));

    DateTime nowTime = DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30));
    if (nowTime.isAfter(slot.add(const Duration(minutes: 30)))) {
      return true;
    }
    return false;
  }

  bool get hasPassed48Hours {
    DateTime slot = slotIdTodDateTime(slotId);
    String time = slotTimings[int.parse(slotId.substring(8, 10)).toString()]!;
    slot = slot.add(Duration(hours: int.parse(time.substring(0, 2))));
    slot = slot.add(Duration(minutes: int.parse(time.substring(3, 5))));
    if (time[6] == 'P') slot = slot.add(const Duration(hours: 12));

    DateTime nowTime = DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30));
    if (nowTime.difference(slot).compareTo(const Duration(hours: 48)) >= 0) {
      return true;
    }
    return false;
  }

  bool get isAfter48Hours {
    DateTime slot = slotIdTodDateTime(slotId);
    String time = slotTimings[int.parse(slotId.substring(8, 10)).toString()]!;
    slot = slot.add(Duration(hours: int.parse(time.substring(0, 2))));
    slot = slot.add(Duration(minutes: int.parse(time.substring(3, 5))));
    if (time[6] == 'P') slot = slot.add(const Duration(hours: 12));

    DateTime nowTime = DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30));
    if (slot.difference(nowTime).compareTo(const Duration(hours: 48)) >= 0) {
      return true;
    }
    return false;
  }

  bool get isActive {
    return timelines.last.type == TimelineType.appointment;
  }

  bool get isCancelled {
    return timelines.last.type == TimelineType.cancelled;
  }

  bool get isFlatfeetOrKnocknee {
    return issueId == 'I8' || issueId == 'I9';
  }

  String? get mostRecentPaymentId {
    return timelines.last.paymentId;
  }

  Future delete() async {
    await FirebaseFirestore.instance.collection('appointments').doc(appointmentId).update({
      AppConstants.archived: true,
    });
  }

  Future<bool> cancel({required bool refundPayment}) async {
    try {
      String? refundId;
      if (refundPayment && mostRecentPaymentId != null) {
        final response = await AppMethods.requestRazorpayRefund(paymentId: mostRecentPaymentId!);
        if (response[AppConstants.status]) {
          refundId = response[AppConstants.remarks];
        } else {
          print('Refund error: ' + response[AppConstants.remarks]);
          return false;
        }
      }
      await FirebaseFirestore.instance.collection('appointments/$appointmentId/timeline').add({
        AppConstants.isCancelled: true,
        AppConstants.createdOn: DateTime.now().toIso8601String(),
        AppConstants.slotId: slotId,
        AppConstants.refundId: refundId,
      });
      await Database.addSlotToDoctor(slotId: slotId, doctorId: doctorId);
      return true;
    } catch (error) {
      print('Cancelling appntm failed');
      debugPrint(error.toString());
      return false;
    }
  }
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
      final json = response.docs[i].data();
      timelinesList.add(Timeline.fromMap(json));
    }

    timelinesList.sort((Timeline a, Timeline b) => a.createdOn.compareTo(b.createdOn));
    return timelinesList;
  }

  Future<void> fetchAndSetAppointments() async {
    try {
      final response = await FirebaseFirestore.instance.collection('appointments').get();
      List<Appointment> temp = [];
      for (int i = 0; i < response.docs.length; i++) {
        final json = response.docs[i].data();
        if (json.containsKey(AppConstants.archived) && json[AppConstants.archived] == true) {
          continue;
        }

        final timelines = await fetchTimleines(response.docs[i].id);
        json[AppConstants.appointmentId] = response.docs[i].id;
        final app = Appointment.fromMap(json);
        app.timelines = timelines;
        temp.add(app);
      }
      _appointments = temp;
      _appointments.sort((a, b) => slotIdTodDateTime(b.slotId, withTime: true)
          .compareTo(slotIdTodDateTime(a.slotId, withTime: true)));
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  List<Appointment> getAppointmentsByPatientId({required String id, bool onlyPassed = false}) {
    return _appointments
        .where((element) => (element.patientId == id && (onlyPassed ? element.hasPassed : true)))
        .toList();
  }

  List<Appointment> getAppointmentsByDoctorId(String id) {
    return _appointments.where((element) => element.doctorId == id).toList();
  }

  Appointment getByAppointmentId(id) {
    int idx = _appointments.indexWhere((element) => element.appointmentId == id);
    return _appointments[idx];
  }
}
