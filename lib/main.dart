import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runon/providers/appointments.dart';
import 'package:runon/providers/auth.dart';
import 'package:runon/providers/doctors.dart';
import 'package:runon/providers/issue_data.dart';
import 'package:runon/providers/slots.dart';
import 'package:runon/providers/temp_provider.dart';
import 'package:runon/screens/about_us_screen.dart';
import 'package:runon/screens/add_appointment.dart';
import 'package:runon/screens/admin_screen.dart';
import 'package:runon/screens/chats_screen.dart';
import 'package:runon/screens/doctor/manage_slots.dart';
import 'package:runon/screens/doctor/my_appointments.dart';
import 'package:runon/screens/doctor_screen.dart';
import 'package:runon/screens/feedback_screen.dart';
import 'package:runon/screens/knock_knee_screen.dart';
import 'package:runon/screens/login.dart';
import 'package:runon/screens/new_appointment.dart';
import 'package:runon/screens/patient_screen.dart';
import 'package:runon/screens/signup.dart';
import 'package:runon/screens/forgot_password_screen.dart';
import 'package:runon/screens/my_appointments.dart';
import 'package:runon/screens/appointement_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:runon/screens/profile_screen.dart';
import 'package:runon/screens/documents_screen.dart';
import 'package:runon/screens/my_schedule_screen.dart';
import 'package:runon/screens/flat_feet_screen.dart';
import 'package:runon/screens/messages_screen.dart';
import 'package:runon/screens/admin/medical_teams.dart';
import 'package:runon/screens/admin/manage_med_team.dart';
import 'package:runon/video_call/call.dart';

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

var themeBrightness = Brightness.light;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void toggleTheme() async {
    setState(() {
      themeBrightness = themeBrightness == Brightness.dark ? Brightness.light : Brightness.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (_) => Slots(),
        ),
        ChangeNotifierProvider(
          create: (_) => IssueData(),
        ),
        ChangeNotifierProvider(
          create: (_) => TempProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => Doctors(),
        ),
        ChangeNotifierProvider(
          create: (_) => Appointments(),
        ),
      ],
      child: Consumer<Auth>(builder: (context, auth, ch) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            brightness: themeBrightness,
            useMaterial3: true,
            colorSchemeSeed: const Color(0xFF51B154),
          ),
          home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? LoginScreen()
                    : FutureBuilder(
                        future: auth.tryLogin(),
                        builder: (context, snapshot) {
                          // print(FirebaseAuth.instance.currentUser!.uid);
                          return snapshot.connectionState == ConnectionState.waiting
                              ? const Scaffold(
                                  body: Center(child: CircularProgressIndicator()),
                                )
                              : auth.type == 1
                                  ? DoctorScreen()
                                  : (auth.type == 2 ? AdminScreen() : PatientScreen());
                        });
              }),
          routes: {
            LoginScreen.routeName: (ctx) => LoginScreen(),
            MyAppointmentsScreen.routeName: (ctx) => MyAppointmentsScreen(),
            SignupScreen.routeName: (ctx) => SignupScreen(),
            PatientScreen.routeName: (ctx) => PatientScreen(),
            AddAppointment.routeName: (ctx) => const AddAppointment(),
            NewAppointment.routeName: (ctx) => NewAppointment(),
            AppointmentDetailScreen.routeName: (ctx) => AppointmentDetailScreen(),
            ForgotPasswordScreen.routeName: (ctx) => ForgotPasswordScreen(),
            ProfileScreen.routeName: (ctx) => ProfileScreen(toggleTheme),
            DocumentsScreen.routeName: (ctx) => const DocumentsScreen(),
            MyScheduleScreen.routeName: (ctx) => const MyScheduleScreen(),
            FlatFeetScreen.routeName: (ctx) => const FlatFeetScreen(),
            KnockKneeScreen.routeName: (ctx) => const KnockKneeScreen(),
            ChatsScreen.routeName: (ctx) => const ChatsScreen(),
            FeedbackForm.routeName: (ctx) => const FeedbackForm(),
            AboutUsScreen.routeName: (ctx) => const AboutUsScreen(),
            MessagesScreen.routeName: (ctx) => MessagesScreen(),
            DoctorScreen.routeName: (ctx) => DoctorScreen(),
            MyAppointmentsScreenDoctor.routeName: (ctx) => MyAppointmentsScreenDoctor(),
            ManageSlotsScreen.routeName: (ctx) => const ManageSlotsScreen(),
            CallPage.routeName: (ctx) => const CallPage(),
            AdminScreen.routeName: (ctx) => AdminScreen(),
            ManageMedicalTeam.routeName: (ctx) => ManageMedicalTeam(),
            MedicalTeamsScreen.routeName: (ctx) => MedicalTeamsScreen(),
          },
        );
      }),
    );
  }
}
