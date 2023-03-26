import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:runon/providers/auth.dart';
import 'package:runon/screens/add_appointment.dart';
import 'package:runon/screens/login.dart';
import 'package:runon/screens/my_schedule_screen.dart';
import '../widgets/category_item.dart';
import '../widgets/clip_paths.dart';
import '../screens/my_appointments.dart';
import '../screens/profile_screen.dart';
import '../screens/flat_feet_screen.dart';
import '../screens/knock_knee_screen.dart';

class PatientScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static const routeName = '/patient-screen';
  PatientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context);
    var pageController = PageController(initialPage: 0, viewportFraction: 0.8);
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? LoginScreen()
              : Scaffold(
                  key: _scaffoldKey,
                  drawer: Drawer(
                    child: Container(),
                  ),
                  appBar: AppBar(
                    actions: [
                      IconButton(
                        icon: CircleAvatar(
                          backgroundImage:
                              Image.network(user.imageUrl ?? '').image,
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(ProfileScreen.routeName);
                        },
                      )
                    ],
                    leading: IconButton(
                      icon: const Icon(Icons.menu, size: 30),
                      onPressed: () {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                    ),
                    centerTitle: true,
                    title: const Text('Home'),
                  ),
                  body: Stack(
                    children: [
                      ClipPath(
                        clipper: UpperEllipse(),
                        child: Container(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      ClipPath(
                        clipper: LowerEllipse(),
                        child: Container(
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer),
                      ),
                      FutureBuilder(
                          future: user.tryLogin(),
                          builder: (context, snapshot) {
                            return snapshot.connectionState ==
                                    ConnectionState.waiting
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 30),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Hi ${user.fName}!',
                                                style: GoogleFonts.raleway(),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Center(
                                            child: Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              // spacing: 20,
                                              children: [
                                                MouseRegion(
                                                  cursor:
                                                      SystemMouseCursors.click,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                              AddAppointment
                                                                  .routeName);
                                                    },
                                                    child: const CategoryItem(
                                                        'assets/images/book_appoint.png',
                                                        'Book An Appointment',
                                                        Color(0xFF028E81)),
                                                  ),
                                                ),
                                                MouseRegion(
                                                  cursor:
                                                      SystemMouseCursors.click,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                              MyAppointmentsScreen
                                                                  .routeName);
                                                    },
                                                    child: const CategoryItem(
                                                        'assets/images/checklist.png',
                                                        'My Appointments',
                                                        Color(0xFFAC4211)),
                                                  ),
                                                ),
                                                MouseRegion(
                                                  cursor:
                                                      SystemMouseCursors.click,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                              MyScheduleScreen
                                                                  .routeName);
                                                    },
                                                    child: const CategoryItem(
                                                        'assets/images/calender.jpg',
                                                        'My Schedule',
                                                        Color(0xFF7660AB)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            'EXPLORE',
                                            style: TextStyle(
                                                fontFamily: 'MoonBold',
                                                letterSpacing: 3.0,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outline),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Center(
                                            child: Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              // spacing: 20,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                            FlatFeetScreen
                                                                .routeName);
                                                  },
                                                  child: const CategoryItem(
                                                      'assets/images/feet.png',
                                                      'Flat Feet',
                                                      Color(0xFFFF9800)),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                            KnockKneeScreen
                                                                .routeName);
                                                  },
                                                  child: const CategoryItem(
                                                      'assets/images/knee.jpg',
                                                      'Knock Knee',
                                                      Color(0xFF3F51B5)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Wrap(
                                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            spacing: 10,
                                            children: [
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5),
                                                constraints:
                                                    const BoxConstraints(
                                                        maxWidth: 300),
                                                width: double.infinity,
                                                child: OutlinedButton(
                                                  onPressed: () {},
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 15.0,
                                                        horizontal: 30),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: const [
                                                        Icon(Icons.settings),
                                                        SizedBox(
                                                          width: 7,
                                                        ),
                                                        Text('Settings'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Container(
                                                width: double.infinity,
                                                constraints:
                                                    const BoxConstraints(
                                                        maxWidth: 300),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5),
                                                child: OutlinedButton(
                                                  onPressed: () {},
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 15.0,
                                                        horizontal: 30),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: const [
                                                        Icon(Icons.info),
                                                        SizedBox(
                                                          width: 7,
                                                        ),
                                                        Text('About Us'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                          }),
                    ],
                  ),
                );
        });
  }
}
