import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runon/providers/auth.dart';
import 'package:runon/payment_gateway/razorpay_options.dart' as rp;
import 'package:runon/providers/doctors.dart';
import 'package:runon/utils/save_appointment_to_server.dart';
import '../widgets/method_slot_formatter.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ConfirmAppointmentDialog extends StatefulWidget {
  const ConfirmAppointmentDialog(
    this._doctorId,
    this._slot,
    this._issue,
    this._formData,
    this._files, {
    required this.isOffline,
    this.isFollowUp = false,
    this.appointmentId,
    this.patient,
    super.key,
  });

  final bool isOffline;
  final bool isFollowUp;
  final String? appointmentId;
  final String _doctorId;
  final String _slot;
  final String _issue;
  final Auth? patient;
  final Map<String, dynamic> _formData;
  final List _files;

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
    sendAppointmentDataToServer(
        context: context,
        doctorId: widget._doctorId,
        formData: widget._formData,
        files: widget._files,
        isFollowUp: widget.isFollowUp,
        appointmentID: widget.appointmentId,
        paymentId: response.paymentId!,
        offline: widget.isOffline);
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

  @override
  Widget build(BuildContext context) {
    final doctor = Provider.of<Doctors>(context, listen: false).doctorFromId(widget._doctorId);
    final Auth auth = widget.patient ?? Provider.of<Auth>(context, listen: false);

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
          if (!widget.isOffline)
            RichText(
              text: TextSpan(
                  style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                  children: [
                    const TextSpan(text: 'Doctor : '),
                    TextSpan(
                        text: doctor!.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ]),
            ),
          RichText(
            text: TextSpan(
                style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                children: [
                  const TextSpan(text: 'Chosen Slot : '),
                  TextSpan(
                      text: expandSlot(widget._slot, widget.isOffline),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ]),
          ),
          RichText(
            text: TextSpan(
                style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                children: [
                  const TextSpan(text: 'Amount Payable : '),
                  TextSpan(
                      text: doctor!.fees.toString(),
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
            onPressed: () => _razorpay.open(options), child: const Text('Proceed to payment')),
      ],
    );
  }
}
