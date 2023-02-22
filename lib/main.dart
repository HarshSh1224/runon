import 'package:flutter/material.dart';
import 'package:runon/screens/add_appointment.dart';
import 'package:runon/screens/login.dart';
import 'package:runon/screens/patient_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // brightness: Brightness.dark,
        useMaterial3: true,
        colorSchemeSeed: const Color(0xff60B765),
      ),
      home: const LoginScreen(),
      routes: {
        LoginScreen.routeName: (ctx) => const LoginScreen(),
        PatientScreen.routeName: (ctx) => PatientScreen(),
        AddAppointment.routeName: (ctx) => const AddAppointment(),
      },
    );
  }
}
