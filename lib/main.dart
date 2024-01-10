import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runon/providers/appointments.dart';
import 'package:runon/providers/auth.dart';
import 'package:runon/providers/doctors.dart';
import 'package:runon/providers/exercise_docs.dart';
import 'package:runon/providers/issue_data.dart';
import 'package:runon/providers/slots.dart';
import 'package:runon/providers/temp_provider.dart';
import 'package:runon/providers/youtube_feed.dart';
import 'package:runon/screens/about_us_screen.dart';
import 'package:runon/screens/home/home_screen.dart';
import 'package:runon/screens/patient/add_appointment.dart';
import 'package:runon/screens/admin/admin_appointments.dart';
import 'package:runon/screens/admin/user_feedbacks.dart';
import 'package:runon/screens/admin/admin_screen.dart';
import 'package:runon/screens/chats_screen.dart';
import 'package:runon/screens/doctor/manage_slots.dart';
import 'package:runon/screens/doctor/my_appointments.dart';
import 'package:runon/screens/doctor/doctor_screen.dart';
import 'package:runon/screens/feedback_screen.dart';
import 'package:runon/screens/knock_knee_screen.dart';
import 'package:runon/screens/login.dart';
import 'package:runon/screens/patient/new_appointment.dart';
import 'package:runon/screens/patient/offline_appointment.dart';
import 'package:runon/screens/patient/patient_screen.dart';
import 'package:runon/screens/signup.dart';
import 'package:runon/screens/forgot_password_screen.dart';
import 'package:runon/screens/patient/my_appointments.dart';
import 'package:runon/screens/appointment_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:runon/screens/profile_screen.dart';
import 'package:runon/screens/documents_screen.dart';
import 'package:runon/screens/patient/my_schedule_screen.dart';
import 'package:runon/screens/flat_feet_screen.dart';
import 'package:runon/screens/messages_screen.dart';
import 'package:runon/screens/admin/medical_teams.dart';
import 'package:runon/screens/admin/manage_med_team.dart';
import 'package:runon/screens/admin/manage_issues.dart';
import 'package:runon/screens/admin/add_medical_team.dart';
import 'package:runon/screens/youtube_player_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  dotenv.load();
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

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message");
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
  void initState() {
    FirebaseMessaging.onMessage.listen((message) {
      print(message);
      return;
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message);
      return;
    });
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    super.initState();
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
        ChangeNotifierProvider(
          create: (_) => ExerciseDocuments(),
        ),
        ChangeNotifierProvider(
          create: (_) => YoutubeFeed(),
        ),
      ],
      child: Consumer<Auth>(builder: (context, auth, ch) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Healthy Aayu',
          theme: ThemeData(
            brightness: themeBrightness,
            useMaterial3: true,
            colorSchemeSeed: const Color(0xFF51B154),
          ),
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? HomePage(
                      toggleTheme: toggleTheme,
                    )
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
                                : (auth.type == 2
                                    ? AdminScreen()
                                    : HomePage(
                                        toggleTheme: toggleTheme,
                                      ));
                      },
                    );
            },
          ),
          routes: {
            LoginScreen.routeName: (ctx) => const LoginScreen(),
            MyAppointmentsScreen.routeName: (ctx) => MyAppointmentsScreen(),
            SignupScreen.routeName: (ctx) => SignupScreen(),
            PatientScreen.routeName: (ctx) => PatientScreen(),
            AddAppointment.routeName: (ctx) => const AddAppointment(),
            NewAppointment.routeName: (ctx) => NewAppointment(),
            AppointmentDetailScreen.routeName: (ctx) => AppointmentDetailScreen(),
            ForgotPasswordScreen.routeName: (ctx) => ForgotPasswordScreen(),
            ProfileScreen.routeName: (ctx) => ProfileScreen(toggleTheme),
            AllDocumentsScreen.routeName: (ctx) => const AllDocumentsScreen(),
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
            AdminScreen.routeName: (ctx) => AdminScreen(),
            ManageMedicalTeam.routeName: (ctx) => const ManageMedicalTeam(),
            MedicalTeamsScreen.routeName: (ctx) => MedicalTeamsScreen(),
            AdminAppointments.routeName: (ctx) => AdminAppointments(),
            AddMedicalTeam.routeName: (ctx) => AddMedicalTeam(),
            ManageIssues.routeName: (ctx) => const ManageIssues(),
            UserFeedbackScreen.routeName: (ctx) => UserFeedbackScreen(),
            YoutubePlayerScreen.routeName: (ctx) => const YoutubePlayerScreen(),
            OfflineAppointmentScreen.routeName: (ctx) => const OfflineAppointmentScreen(),
          },
        );
      }),
    );
  }
}
