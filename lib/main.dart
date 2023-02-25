import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runon/providers/auth.dart';
import 'package:runon/screens/add_appointment.dart';
import 'package:runon/screens/login.dart';
import 'package:runon/screens/new_appointment.dart';
import 'package:runon/screens/patient_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // brightness: Brightness.dark,
          useMaterial3: true,
          colorSchemeSeed: Color.fromARGB(255, 71, 145, 231),
        ),
        home: const LoginScreen(),
        routes: {
          LoginScreen.routeName: (ctx) => const LoginScreen(),
          PatientScreen.routeName: (ctx) => PatientScreen(),
          AddAppointment.routeName: (ctx) => const AddAppointment(),
          NewAppointment.routeName: (ctx) => NewAppointment(),
        },
      ),
    );
  }
}
