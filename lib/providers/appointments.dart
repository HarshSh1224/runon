import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:runon/controllers/database.dart';
import 'package:runon/providers/slot_timings.dart';
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
}

class Appointment {
  String appointmentId;
  String patientId;
  String doctorId;
  String issueId;
  String slotId;
  String? prescriptionId;
  List<Timeline> timelines;
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

  bool get isCancellable {
    return timelines.last.type == TimelineType.appointment && isAfter48Hours;
  }

  bool get hasPassed {
    return false;
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

  Future delete() async {
    await FirebaseFirestore.instance.collection('appointments').doc(appointmentId).update({
      'archived': true,
    });
  }

  cancel({String? refundId}) async {
    try {
      await FirebaseFirestore.instance.collection('appointments/$appointmentId/timeline').add({
        'is_cancelled': true,
        'createdOn': DateTime.now().toIso8601String(),
        'slotId': slotId,
        'refund_id': refundId,
      });
      Database.addSlotToDoctor(slotId: slotId, doctorId: doctorId);
    } catch (error) {
      print('Cancelling appntm failed');
      debugPrint(error.toString());
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

    // try {
    final response =
        await FirebaseFirestore.instance.collection('appointments/$appointmentId/timeline').get();

    for (int i = 0; i < response.docs.length; i++) {
      final timeline = response.docs[i].data();

      List<String> tempList = [];
      if (response.docs[i].data().containsKey('prescriptionList')) {
        response.docs[i].data()['prescriptionList'].map((el) {
          tempList.add('$el');
        }).toList();
      }

      if (timeline.containsKey('byDoctor')) {
        timelinesList.add(Timeline(
            type: TimelineType.consultation,
            createdOn: DateTime.parse(timeline['createdOn']),
            prescriptionList: tempList,
            byDoctor: true,
            slotId: timeline['slotId']));
      } else if (timeline.containsKey('is_cancelled')) {
        timelinesList.add(Timeline(
          type: TimelineType.cancelled,
          createdOn: DateTime.parse(timeline['createdOn']),
          prescriptionList: tempList,
          slotId: timeline['slotId'],
          refundId: timeline['refund_id'],
        ));
      } else {
        timelinesList.add(Timeline(
          type: TimelineType.appointment,
          createdOn: DateTime.parse(timeline['createdOn']),
          paymentAmount: timeline['paymentAmount'],
          paymentId: timeline['paymentId'],
          prescriptionList: tempList,
          slotId: timeline['slotId'],
        ));
      }
    }
    // } catch (error) {
    //   print(error);
    //   rethrow;
    // }

    timelinesList.sort((Timeline a, Timeline b) => a.createdOn.compareTo(b.createdOn));

    return timelinesList;
  }

  Future<void> fetchAndSetAppointments() async {
    try {
      final response = await FirebaseFirestore.instance.collection('appointments').get();
      // print(response.docs[0].data()['timelines']);
      List<Appointment> temp = [];
      for (int i = 0; i < response.docs.length; i++) {
        if (response.docs[i].data().containsKey('archived') &&
            response.docs[i].data()['archived'] == true) continue;
        List<String> tempList = [];

        if (response.docs[i].data().containsKey('reportUrl')) {
          response.docs[i].data()['reportUrl'].map((el) {
            tempList.add('$el');
          }).toList();
        }

        final timelines = await fetchTimleines(response.docs[i].id);

        temp.add(
          Appointment(
            appointmentId: response.docs[i].id,
            patientId: response.docs[i].data()['patientId'],
            doctorId: response.docs[i].data()['doctorId'],
            issueId: response.docs[i].data()['issueId'],
            timelines: timelines,
            slotId: timelines[timelines.length - 1].slotId,
            reports: tempList,
          ),
        );
      }
      _appointments = temp;
      _appointments.sort((a, b) => slotIdTodDateTime(b.slotId, withTime: true)
          .compareTo(slotIdTodDateTime(a.slotId, withTime: true)));
      // print('TEMP IS $temp');
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
