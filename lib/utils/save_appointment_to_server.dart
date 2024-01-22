import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runon/providers/auth.dart';
import 'package:runon/providers/doctors.dart';
import 'package:runon/providers/slots.dart';
import 'package:runon/screens/payment_success.dart';

void sendAppointmentDataToServer({
  required context,
  required bool isFollowUp,
  required String doctorId,
  required Map<String, dynamic> formData,
  required String paymentId,
  String? appointmentID,
  files,
}) async {
  final firebaseDatabase = FirebaseFirestore.instance.collection('appointments');
  _pleaseWaitDialog(context);

  bool success = false;
  final String slot = formData['slotId'];

  try {
    if (!isFollowUp) {
      // Add new appointment doc to appointments collection
      final response = await firebaseDatabase.add(formData);
      appointmentID = response.id;
    }

    await _uploadTimeline(files, appointmentID!, paymentId, slot, context, doctorId);

    Provider.of<Slots>(context, listen: false)
        .removeSlot(slot.substring(0, 8), slot.substring(8, 10), formData['doctorId']);

    success = true;
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Text('Error'),
        ),
      ),
    );
  }

  Navigator.of(context).pop();
  Navigator.of(context).pop();
  Navigator.of(context).pop();
  Navigator.of(context).pop();

  final auth = Provider.of<Auth>(context, listen: false);

  if (success) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: ((context) => PaymentSuccess(
              amount: Provider.of<Doctors>(context, listen: false).doctorFromId(doctorId)!.fees,
              date: DateTime.now(),
              fee: 0,
              name: '${auth.fName!} ${auth.lName!}',
              paymentId: paymentId,
              appointmentId: appointmentID!,
            )),
      ),
    );
  }
}

Future<void> _uploadTimeline(List files, String appointmentId, String paymentId, String slot,
    context, String doctorId) async {
  Map<String, dynamic> timelineData = const {};

  for (int i = 0; i < files.length; i++) {
    final ref = FirebaseStorage.instance.ref().child('previousReports').child('$appointmentId$i');
    await ref.putFile(File(files[i].path));
    final url = await ref.getDownloadURL();
    (timelineData['prescriptionList']! as List).add(url);
  }

  timelineData['createdOn'] = DateTime.now().toIso8601String();
  timelineData['slotId'] = slot;
  timelineData['paymentId'] = paymentId;
  timelineData['paymentAmount'] =
      Provider.of<Doctors>(context, listen: false).doctorFromId(doctorId)!.fees;

  await FirebaseFirestore.instance
      .collection('appointments/$appointmentId/timeline')
      .add(timelineData);
}

Future<dynamic> _pleaseWaitDialog(context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: SizedBox(
          height: 100,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text('Please wait')
              ],
            ),
          ),
        ),
      );
    },
  );
}
