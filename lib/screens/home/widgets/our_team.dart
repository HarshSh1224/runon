import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runon/screens/home/about_doctor_screen.dart';
import 'package:runon/screens/home/data/team_data.dart';

class OurTeam extends StatefulWidget {
  const OurTeam({super.key});

  @override
  State<OurTeam> createState() => _OurTeamState();
}

class _OurTeamState extends State<OurTeam> {
  int _currentPage = 0;

  late Timer _timer;
  final PageController _pageController = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < teamsData.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      alignment: Alignment.center,
      child: PageView.builder(
        controller: _pageController,
        itemCount: teamsData.length,
        itemBuilder: (conotext, index) {
          return _doctorCard(index);
        },
      ),
    );
  }

  Widget _doctorCard(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AboutDoctor(
                  name: teamsData[index]['name'],
                  image: teamsData[index]['image'],
                  description: teamsData[index]['description'],
                )));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 30,
                      color: Theme.of(context).colorScheme.shadow.withOpacity(0.4),
                      spreadRadius: 1),
                ],
              ),
              child: CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage(teamsData[index]['image']),
              )),
          const SizedBox(height: 15),
          Text(teamsData[index]['name'],
              style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(teamsData[index]['designation'])
        ],
      ),
    );
  }
}
