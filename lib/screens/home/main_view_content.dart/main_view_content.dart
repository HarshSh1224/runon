import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:runon/providers/auth.dart';
import 'package:runon/screens/home/data/consult_options.dart';
import 'package:runon/screens/home/widgets/explore_section.dart';
import 'package:runon/screens/home/widgets/our_team.dart';
import 'package:runon/screens/login.dart';
import 'package:runon/screens/patient/add_appointment.dart';

class MainViewContent extends StatefulWidget {
  const MainViewContent({super.key});

  @override
  State<MainViewContent> createState() => _MainViewContentState();
}

class _MainViewContentState extends State<MainViewContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      width: double.infinity,
      child: Column(
        children: [
          _subHeading('Consult'),
          _consultRow(),
          const ExploreSection(),
          const SizedBox(
            height: 20,
          ),
          _schoolBanner(),
          const OurTeam(),
          _footer()
        ],
      ),
    );
  }

  SingleChildScrollView _consultRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 10),
          ...consultOptions.map((e) => GestureDetector(
                onTap: () {
                  if (Provider.of<Auth>(context, listen: false).isAuth) {
                    Navigator.pushNamed(context, AddAppointment.routeName);
                  } else {
                    Navigator.pushNamed(context, LoginScreen.routeName);
                  }
                },
                child: _card(
                    height: 120,
                    width: 180,
                    child: _consultCard(context: context, title: e['title'], image: e['image'])),
              )),
        ],
      ),
    );
  }

  Widget _schoolBanner() {
    return Container(
      color: Colors.black,
      height: 300,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: Image.network('https://thesportsrehab.com/img/school_3_lg9.jpg',
                  fit: BoxFit.cover),
            ),
          ),
          Positioned.fill(
            child: Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'School / Group Plans',
                      style: GoogleFonts.ubuntu(
                          color: Colors.white, fontSize: 30, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Browse our curated plans for schools or organisations for onsite camps/mass consultation',
                      style: GoogleFonts.sen(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    FilledButton(
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Text(
                            'Get Started',
                            style: GoogleFonts.sen(
                              fontSize: 20,
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Row _subHeading(title) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            title,
            style: GoogleFonts.raleway(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

  Container _card({double? height, double? width, required Widget child, bool border = false}) {
    return Container(
        height: height,
        width: width,
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 30),
        decoration: BoxDecoration(
          border: Border.all(
            color: border
                ? Theme.of(context).colorScheme.outline
                : Theme.of(context).colorScheme.surface,
            width: 2,
          ),
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.brightness == Brightness.dark
                  ? Colors.black
                  : Colors.grey,
              spreadRadius: 1,
              blurRadius: 20,
              offset: const Offset(0, 10), // changes position of shadow
            ),
          ],
        ),
        child: child);
  }

  Widget _consultCard(
          {required BuildContext context, required String title, required String image}) =>
      Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
            child: Text(
              title,
              style: GoogleFonts.sen(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 20,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  invertColors: Theme.of(context).colorScheme.brightness == Brightness.dark),
              child: Image.asset(
                image,
                height: 60,
              ),
            ),
          )
        ],
      );

  Widget _footer() {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'About Us',
                  style: TextStyle(
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
                Text(
                  ' | ',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Contact Us',
                  style: TextStyle(
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
                Text(
                  ' | ',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Terms and Conditions',
                  style: TextStyle(
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            '© 2021 HealthyAayu. All rights reserved.',
            style: GoogleFonts.sen(
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 15,
          ),
          Image.asset(
            'assets/images/logo.png',
            height: 30,
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
