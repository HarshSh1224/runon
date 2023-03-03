import 'package:flutter/material.dart';

class AppointmentDetailScreen extends StatelessWidget {
  static const routeName = '/appointment-detail-screen';
  const AppointmentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Appointment Details')),
    );
  }
}
