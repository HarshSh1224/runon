import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runon/providers/auth.dart';
import 'package:runon/providers/doctors.dart';
import '../widgets/method_slot_formatter.dart';

class ConfirmAppointmentDialog extends StatelessWidget {
  const ConfirmAppointmentDialog(
      this._doctorId, this._slot, this._issue, this._formData, this._files,
      {super.key});

  final String _doctorId;
  final String _slot;
  final String _issue;
  final _formData;
  final _files;

  void _sendDataToServer(context) async {
    final firebaseDatabase =
        FirebaseFirestore.instance.collection('appointments');
    showDialog(
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
                  ))));
        });
    try {
      final response = await firebaseDatabase.add(_formData);
      for (int i = 0; i < _files.length; i++) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('previousReports')
            .child('${response.id}$i');
        await ref.putFile(File(_files[i].path));
        final url = await ref.getDownloadURL();
        _formData['reportUrl'].add(url);
      }

      await firebaseDatabase.doc(response.id).set(_formData);
    } catch (error) {}

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Text('Success'),
      ),
    ));

    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final doctor =
        Provider.of<Doctors>(context, listen: false).doctorFromId(_doctorId);
    final auth = Provider.of<Auth>(context, listen: false);

    return AlertDialog(
      title: const Text(
        'Confirm appointment',
        style: TextStyle(fontSize: 22),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
                children: [
                  const TextSpan(text: 'Patient Name : '),
                  TextSpan(
                      text: '${auth.fName!} ${auth.lName!}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ]),
          ),
          RichText(
            text: TextSpan(
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
                children: [
                  TextSpan(text: 'Issue : '),
                  TextSpan(
                      text: _issue,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ]),
          ),
          RichText(
            text: TextSpan(
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
                children: [
                  const TextSpan(text: 'Doctor : '),
                  TextSpan(
                      text: doctor!.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ]),
          ),
          RichText(
            text: TextSpan(
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
                children: [
                  const TextSpan(text: 'Chosen Slot : '),
                  TextSpan(
                      text: expandSlot(_slot),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ]),
          ),
          RichText(
            text: TextSpan(
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
                children: [
                  const TextSpan(text: 'Amount Payable : '),
                  TextSpan(
                      text: doctor.fees.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ]),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: Navigator.of(context).pop, child: const Text('Cancel')),
        TextButton(
            onPressed: () => _sendDataToServer(context),
            child: const Text('Proceed to payment')),
      ],
    );
  }
}
