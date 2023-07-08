import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runon/providers/auth.dart';
import 'package:runon/payment_gateway/razorpay_options.dart' as rp;
import 'package:runon/providers/doctors.dart';
import 'package:runon/providers/slots.dart';
import '../widgets/method_slot_formatter.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ConfirmAppointmentDialog extends StatefulWidget {
  ConfirmAppointmentDialog(
    this._doctorId,
    this._slot,
    this._issue,
    this._formData,
    this._files, {
    super.key,
  });

  final String _doctorId;
  final String _slot;
  final String _issue;
  final _formData;
  final _files;
  final timelineData = {
    'createdOn': '',
    'paymentId': '',
    'paymentAmount': '',
    'prescriptionList': [],
    'slotId': '',
  };

  @override
  State<ConfirmAppointmentDialog> createState() => _ConfirmAppointmentDialogState();
}

class _ConfirmAppointmentDialogState extends State<ConfirmAppointmentDialog> {
  final _razorpay = Razorpay();
  Map<String, dynamic> options = {};

  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    options = {
      'key': rp.key,
      'amount':
          Provider.of<Doctors>(context, listen: false).doctorFromId(widget._doctorId)!.fees * 100,
      'name': rp.name,
      'description': rp.description,
      'prefill': rp.prefill
    };
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Text(
              '${response.paymentId!} ${response.signature ?? 'no sign'} ${response.orderId ?? 'no orderid'}'),
          actions: [TextButton(onPressed: Navigator.of(context).pop, child: const Text('Close'))],
        );
      },
    );
    widget.timelineData['paymentId'] = response.paymentId as String;
    _sendDataToServer(context);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Text('${response.code!} ${response.message!}'),
          actions: [TextButton(onPressed: Navigator.of(context).pop, child: const Text('Close'))],
        );
      },
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Text(response.walletName!),
          actions: [TextButton(onPressed: Navigator.of(context).pop, child: const Text('Close'))],
        );
      },
    );
  }

  void _sendDataToServer(context) async {
    final firebaseDatabase = FirebaseFirestore.instance.collection('appointments');
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
      final response = await firebaseDatabase.add(widget._formData);
      for (int i = 0; i < widget._files.length; i++) {
        final ref =
            FirebaseStorage.instance.ref().child('previousReports').child('${response.id}$i');
        await ref.putFile(File(widget._files[i].path));
        final url = await ref.getDownloadURL();
        widget._formData['reportUrl'].add(url);
      }

      final String slot = widget._formData['slotId'];

      widget.timelineData['createdOn'] = DateTime.now().toIso8601String();
      widget.timelineData['slotId'] = slot;
      widget.timelineData['paymentAmount'] =
          Provider.of<Doctors>(context, listen: false).doctorFromId(widget._doctorId)!.fees;

      await FirebaseFirestore.instance
          .collection('appointments/${response.id}/timeline')
          .add(widget.timelineData);

      await firebaseDatabase.doc(response.id).set(widget._formData);

      Provider.of<Slots>(context, listen: false)
          .removeSlot(slot.substring(0, 8), slot.substring(8, 10), widget._formData['doctorId']);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Text('Success'),
        ),
      ));
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
  }

  @override
  Widget build(BuildContext context) {
    final doctor = Provider.of<Doctors>(context, listen: false).doctorFromId(widget._doctorId);
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
                style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                children: [
                  const TextSpan(text: 'Patient Name : '),
                  TextSpan(
                      text: '${auth.fName!} ${auth.lName!}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ]),
          ),
          RichText(
            text: TextSpan(
                style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                children: [
                  const TextSpan(text: 'Age : '),
                  TextSpan(text: auth.age, style: const TextStyle(fontWeight: FontWeight.bold)),
                ]),
          ),
          RichText(
            text: TextSpan(
                style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                children: [
                  const TextSpan(text: 'Gender : '),
                  TextSpan(text: auth.gender, style: const TextStyle(fontWeight: FontWeight.bold)),
                ]),
          ),
          if (widget._formData['height'] != '')
            RichText(
              text: TextSpan(
                  style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                  children: [
                    const TextSpan(text: 'Height : '),
                    TextSpan(
                        text: widget._formData['height'],
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ]),
            ),
          if (widget._formData['weight'] != '')
            RichText(
              text: TextSpan(
                  style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                  children: [
                    const TextSpan(text: 'Weight : '),
                    TextSpan(
                        text: widget._formData['weight'],
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ]),
            ),
          RichText(
            text: TextSpan(
                style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                children: [
                  const TextSpan(text: 'Issue : '),
                  TextSpan(
                      text: widget._issue, style: const TextStyle(fontWeight: FontWeight.bold)),
                ]),
          ),
          RichText(
            text: TextSpan(
                style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                children: [
                  const TextSpan(text: 'Doctor : '),
                  TextSpan(text: doctor!.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                ]),
          ),
          RichText(
            text: TextSpan(
                style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                children: [
                  const TextSpan(text: 'Chosen Slot : '),
                  TextSpan(
                      text: expandSlot(widget._slot),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ]),
          ),
          RichText(
            text: TextSpan(
                style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
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
          onPressed: Navigator.of(context).pop,
          child: const Text('Cancel'),
        ),
        TextButton(
            // onPressed: () => _sendDataToServer(context),
            onPressed: () => _razorpay.open(options),
            child: const Text('Proceed to payment')),
      ],
    );
  }
}
