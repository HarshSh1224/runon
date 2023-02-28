import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runon/providers/auth.dart';
import 'package:runon/providers/doctors.dart';
import 'package:runon/providers/issue_data.dart';
import 'package:runon/screens/add_appointment.dart';
import 'package:runon/screens/login.dart';
import 'package:runon/screens/new_appointment.dart';
import 'package:runon/screens/patient_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: 'AIzaSyBOMVPfUAF8auGAYtZsVN_oJ5r4kW8aGjk',
            appId: '1:781909751151:web:2c22c7a3adf4eb89dda49a',
            messagingSenderId: '781909751151',
            projectId: 'runon-c2c2e'));
  } else {
    await Firebase.initializeApp();
  }

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
        ChangeNotifierProvider(
          create: (_) => IssueData(),
        ),
        ChangeNotifierProvider(
          create: (_) => Doctors(),
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
