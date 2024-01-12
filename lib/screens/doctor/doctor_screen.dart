import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:runon/misc/constants/app_constants.dart';
import 'package:runon/providers/auth.dart';
import 'package:runon/screens/about_us_screen.dart';
import 'package:runon/screens/patient/my_schedule_screen.dart';
import '../../widgets/category_item.dart';
import '../../widgets/clip_paths.dart';
import 'my_appointments.dart';
import 'manage_slots.dart';
import '../profile_screen.dart';
import '../flat_feet_screen.dart';
import '../knock_knee_screen.dart';
import 'package:runon/widgets/side_drawer.dart';

class DoctorScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static const routeName = '/doctor-screen';
  DoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context);
    return Scaffold(
      drawer: const Drawer(
        backgroundColor: Colors.transparent,
        child: SideDrawer(),
      ),
      key: _scaffoldKey,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundImage: Image.network(user.imageUrl ?? AppConstants.blankProfileImage).image,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(ProfileScreen.routeName);
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
            child: Container(color: Theme.of(context).colorScheme.primary),
          ),
          ClipPath(
            clipper: LowerEllipse(),
            child: Container(color: Theme.of(context).colorScheme.secondaryContainer),
          ),
          FutureBuilder(
            future: user.tryLogin(),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Hi Dr. ${user.fName}!',
                                  style: GoogleFonts.raleway(),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                // spacing: 20,
                                children: [
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushNamed(MyAppointmentsScreenDoctor.routeName);
                                      },
                                      child: const CategoryItem('assets/images/checklist.png',
                                          'Current Appointments', Color(0xFFAC4211)),
                                    ),
                                  ),
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushNamed(ManageSlotsScreen.routeName);
                                      },
                                      child: const CategoryItem(
                                        'assets/images/calender.jpg',
                                        'Manage Slots',
                                        Color(0xFF7660AB),
                                      ),
                                    ),
                                  ),
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(MyScheduleScreen.routeName);
                                      },
                                      child: const CategoryItem('assets/images/stetho.jpg',
                                          'Manage Medical Team', Color(0xFF028E81)),
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
                                  color: Theme.of(context).colorScheme.outline),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                // spacing: 20,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(FlatFeetScreen.routeName);
                                    },
                                    child: const CategoryItem(
                                      'assets/images/feet.png',
                                      'Flat Feet',
                                      Color(0xFFFF9800),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(KnockKneeScreen.routeName);
                                    },
                                    child: const CategoryItem(
                                        'assets/images/knee.jpg', 'Knock Knee', Color(0xFF3F51B5)),
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
                                  margin: const EdgeInsets.symmetric(vertical: 5),
                                  constraints: const BoxConstraints(maxWidth: 300),
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(ProfileScreen.routeName);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15.0, horizontal: 30),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
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
                                  constraints: const BoxConstraints(maxWidth: 300),
                                  margin: const EdgeInsets.symmetric(vertical: 5),
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      Navigator.of(context).pushNamed(AboutUsScreen.routeName);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15.0, horizontal: 30),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
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
            },
          ),
        ],
      ),
    );
  }
}
