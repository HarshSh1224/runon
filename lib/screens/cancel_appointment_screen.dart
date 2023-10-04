import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:runon/payment_gateway/payment_model.dart';
import 'package:runon/providers/appointments.dart';
import 'package:http/http.dart' as http;
import 'package:runon/payment_gateway/razorpay_options.dart' as rp;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CancelAppointmentScreen extends StatelessWidget {
  final Appointment appointment;
  final String paymentId;
  CancelAppointmentScreen({required this.appointment, required this.paymentId, super.key});

  Payment? payment;
  late final theme;

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancel Appointment'),
      ),
      body: FutureBuilder(
          future: _fetchPaymentDetails(),
          builder: (context, snapshot) {
            if (snapshot.hasData && !snapshot.data!) return _errorFetchingPayment;
            return snapshot.connectionState == ConnectionState.waiting || payment == null
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _warning(context,
                                  'You are${appointment.isCancellable ? ' ' : ' not '}eligible for a full refund',
                                  isError: !appointment.isCancellable),
                              const SizedBox(
                                height: 20,
                              ),
                              _heading,
                              const SizedBox(
                                height: 10,
                              ),
                              _paymentId,
                              _date,
                              _time,
                              _paymentMethod,
                              _amount,
                              // _paymentMethodDetails,
                              const SizedBox(
                                height: 30,
                              ),
                              _amountRefundable,
                            ],
                          ),
                        ),
                      ),
                      _warning(context, 'Refunds are processed within 5-7 days', isWarning: true),
                      const SizedBox(
                        height: 10,
                      ),
                      _footer(context),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  );
          }),
    );
  }

  Widget _footer(context) {
    return GestureDetector(
      onTap: () => _ontapCancelAppointment(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: theme.primary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cancel,
              color: theme.primaryContainer,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Cancel Appointment',
              style: GoogleFonts.ubuntu(fontSize: 18, color: theme.primaryContainer),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _errorFetchingPayment {
    return const Center(
      child: Text('Error fetching payment details'),
    );
  }

  Widget _warning(context, String text, {bool isWarning = false, bool isError = false}) {
    Color primary = theme.primary;
    Color border = theme.primaryContainer;
    if (isWarning) {
      primary = ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 252, 223, 0),
              brightness: Theme.of(context).brightness)
          .primary;
      border = ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 252, 223, 0),
              brightness: Theme.of(context).brightness)
          .primaryContainer;
    } else if (isError) {
      primary = theme.error;
      border = theme.errorContainer;
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: border, width: 2),
        color: border.withOpacity(0.2),
      ),
      child: Row(
        children: [
          Icon(
            isWarning ? Icons.warning : (isError ? Icons.cancel : Icons.done),
            color: primary,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: TextStyle(color: primary),
          ),
        ],
      ),
    );
  }

  Widget get _paymentId {
    return _detailsDisplay('Payment Id', payment!.id);
  }

  Widget get _date {
    return _detailsDisplay('Payment Date', DateFormat('dd MMM yyy').format(payment!.createdOn));
  }

  Widget get _time {
    return _detailsDisplay('Payment Time', DateFormat('hh:mm a').format(payment!.createdOn));
  }

  Widget get _amount {
    return _detailsDisplay('Payment amount', payment!.amount.toString());
  }

  Widget get _paymentMethod {
    return _detailsDisplay('Payment Method', payment!.humanReadablePaymentMethod);
    // return Text('Payment Method: ${payment!.humanReadablePaymentMethod}');
  }

  Widget get _amountRefundable {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: Row(
        children: [
          Expanded(
              flex: 6,
              child: Text(
                'Amount Refundable :',
                style: GoogleFonts.ubuntu(fontSize: 18, color: theme.outline),
              )),
          Expanded(
              flex: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Rs. ${appointment.isCancellable ? payment!.amount.toString() : '0'}',
                    style: GoogleFonts.ubuntu(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget get _heading {
    return Row(
      children: [
        const SizedBox(
          width: 20,
        ),
        Text(
          'Payment Details',
          style: GoogleFonts.raleway(fontSize: 25, fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  Widget _detailsDisplay(String left, String right) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: Row(
        children: [
          Expanded(
              flex: 4,
              child: Text(
                left,
                style: GoogleFonts.ubuntu(fontSize: 18, color: theme.outline),
              )),
          Expanded(
              flex: 5,
              child: Text(
                ':  $right',
                style: GoogleFonts.ubuntu(fontSize: 18),
              )),
        ],
      ),
    );
  }

  Future<bool> _fetchPaymentDetails() async {
    // fetch payment details from razorpay
    print('Requesting payment details');
    String username = rp.key;
    String password = 'Or8LpoIlfKQzxln15AUb2Chq';
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    final response = await http.get(
      Uri.parse('https://api.razorpay.com/v1/payments/$paymentId'),
      // Send authorization headers to the backend.
      headers: {HttpHeaders.authorizationHeader: basicAuth},
    );
    final responseJson = jsonDecode(response.body);
    print('Requesting payment details complete');
    print(responseJson);

    if (responseJson.containsKey('error')) {
      return false;
    }
    payment = Payment.fromMap(responseJson);
    return true;
  }

  _ontapCancelAppointment(context) async {
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: const Text('Are you sure you want to cancel this appointment?'),
              actions: [
                TextButton(onPressed: Navigator.of(context).pop, child: const Text('No')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _cancelAppointment(context);
                    },
                    child: const Text('Yes')),
              ],
            ));
  }

  _cancelAppointment(context) async {
    showDialog(
        context: context,
        builder: (_) => const Center(
              child: CircularProgressIndicator(),
            ));
    final response = appointment.isCancellable
        ? await _requestRazorpayRefund()
        : {'status': true, 'remarks': null};
    Navigator.of(context).pop();
    if (response['status']) {
      appointment.cancel(refundId: response['remarks']);
      Navigator.of(context).pop();
    } else {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: Text(response['remarks']),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Ok')),
                ],
              ));
    }
  }

  Future<Map<String, dynamic>> _requestRazorpayRefund() async {
    // request razorpay to refund the amount
    print('Requesting refund');
    String username = rp.key;
    String password = dotenv.env['razorpay_key_secret']!;
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    final response = await http.post(
      Uri.parse('https://api.razorpay.com/v1/payments/$paymentId/refund'),
      headers: {HttpHeaders.authorizationHeader: basicAuth},
    );
    final responseJson = jsonDecode(response.body);
    if (responseJson.containsKey('error')) {
      print('Requesting refund Failed');
      return {'status': false, 'remarks': responseJson['error']['description']};
    } else {
      print('Requesting refund Success');
      return {'status': true, 'remarks': responseJson['id']};
    }
    // print(responseJson);
  }
}
