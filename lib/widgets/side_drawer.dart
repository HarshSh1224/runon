import 'package:runon/providers/auth.dart';
import 'package:runon/screens/about_us_screen.dart';
import 'package:runon/screens/patient/add_appointment.dart';
import 'package:runon/screens/chats_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runon/screens/doctor/doctor_screen.dart';
import 'package:runon/screens/patient/patient_screen.dart';
import 'package:runon/screens/profile_screen.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  Widget _listTileBuilder(BuildContext context, String title, Icon icon, Function() onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.white.withOpacity(0.2),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 40),
          title: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          leading: icon,
          // trailing: Icon(
          //   Icons.arrow_forward,
          //   color: Colors.white,
          // ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    // return Container(
    return
        // Container(
        //   height: double.infinity,
        //   color: Color(0XFF031929),
        //   alignment: Alignment(-0.8, -1),
        //   child:
        Scaffold(
      backgroundColor: const Color(0XFF031929).withOpacity(0.0),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 0.2),
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                // Container(
                //   height: double.infinity,
                //   width: double.infinity,
                //   margin: const EdgeInsets.only(top: 240),
                //   child: Image.asset(
                //     'assets/images/nacho.png',
                //     fit: BoxFit.fitWidth,
                //     alignment: Alignment.topCenter,
                //   ),
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 320,
                    ),
                    _listTileBuilder(
                        context,
                        'Home',
                        const Icon(
                          Icons.home,
                          color: Colors.white,
                          size: 25,
                        ), () {
                      // Navigator.popUntil(context, ModalRoute.withName('/tabs-screen'));
                      Navigator.of(context).popUntil((route) => route != ModalRoute.withName('/'));
                      if (auth.type == 0) {
                        Navigator.of(context).pushReplacementNamed(PatientScreen.routeName);
                      }
                      if (auth.type == 1) {
                        Navigator.of(context).pushReplacementNamed(DoctorScreen.routeName);
                      }
                    }),
                    _listTileBuilder(
                        context,
                        'Chats',
                        const Icon(
                          Icons.chat,
                          color: Colors.white,
                          size: 25,
                        ), () {
                      Navigator.of(context).pushNamed(ChatsScreen.routeName);
                    }),
                    _listTileBuilder(
                        context,
                        'New Appointment',
                        const Icon(
                          Icons.person_add_alt_1,
                          color: Colors.white,
                          size: 25,
                        ), () {
                      Navigator.of(context).pushNamed(AddAppointment.routeName);
                    }),
                    _listTileBuilder(
                        context,
                        'Settings',
                        const Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 25,
                        ), () {
                      Navigator.of(context).pushNamed(ProfileScreen.routeName);
                    }),
                    const Spacer(),
                    _listTileBuilder(
                        context,
                        'About Us',
                        const Icon(
                          Icons.info,
                          color: Colors.white,
                          size: 25,
                        ), () async {
                      var page = await Future.microtask(() {
                        return const AboutUsScreen();
                      });
                      var route = MaterialPageRoute(builder: (_) => page);
                      Navigator.push(context, route);
                    }),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
                // Positioned(
                //   top: 20,
                //   child: Material(
                //     color: Colors.transparent,
                //     child: InkWell(
                //       onTap: () {
                //         print('HOME TAP');
                //       },
                //       splashColor: Colors.white.withOpacity(0.2),
                //       child: ListTile(
                //         contentPadding: EdgeInsets.symmetric(horizontal: 40),
                //         title: Text(
                //           'Settings',
                //           style: TextStyle(color: Colors.white, fontSize: 16),
                //         ),
                //         leading: Icon(
                //           Icons.settings,
                //           color: Colors.white,
                //           size: 25,
                //         ),
                //         // trailing: Icon(
                //         //   Icons.arrow_forward,
                //         //   color: Colors.white,
                //         // ),
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
          ClipPath(
            clipper: CustomClipPath(),
            // borderRadius:
            //     BorderRadius.only(bottomRight: Radius.elliptical(400, 100)),
            child: Container(
              margin: EdgeInsets.zero,
              width: double.infinity,
              height: 300,
              color: Theme.of(context).colorScheme.secondary,
              // decoration: BoxDecoration(
              //   borderRadius:
              //       // BorderRadius.horizontal(right: Radius.elliptical(300, 100)),
              // ),
              alignment: const Alignment(0, -0.3),
              child: Column(
                children: [
                  const SizedBox(
                    height: 70,
                  ),
                  CircleAvatar(
                    backgroundColor: const Color(0XFFDADCE0),
                    backgroundImage: auth.isAuth ? Image.network(auth.imageUrl!).image : null,
                    radius: 56,
                    child: auth.isAuth
                        ? null
                        : const Icon(
                            Icons.person,
                            size: 60,
                            color: Color(0XFF9AA0A6),
                          ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    auth.isAuth ? auth.fName! : 'No User',
                    style: const TextStyle(fontSize: 19, color: Colors.white),
                  ),
                  if (auth.isAuth)
                    Text(
                      auth.email!,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    // color: Color(0XFF031929),
    // child: Text('data'),
    // );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path0 = Path();
    path0.moveTo(0, 0);
    path0.lineTo(0, size.height - 30);
    path0.quadraticBezierTo(size.width * 0.6, size.height - 10, size.width, size.height - 65);
    // path0.lineTo(size.width, size.height);
    path0.lineTo(size.width, 0);
    path0.close();
    return path0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
