import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runon/misc/constants/app_constants.dart';
import 'package:runon/providers/auth.dart';
import 'package:runon/screens/admin/admin_screen.dart';
import 'package:runon/screens/doctor/doctor_screen.dart';
import 'package:runon/screens/home/main_view_content/main_view_content.dart';
import 'package:runon/screens/login.dart';
import 'package:runon/screens/patient/patient_screen.dart';
import 'package:runon/widgets/clip_paths.dart';

class HomePage extends StatefulWidget {
  final Function() toggleTheme;
  const HomePage({required this.toggleTheme, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  double _opacity = 1.0;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.offset > 200) {
        setState(() {
          _opacity = 0.0;
        });
      } else {
        setState(() {
          _opacity = (200 - _scrollController.offset) / 200;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      body: Stack(
        children: [
          Opacity(opacity: _opacity, child: Image.asset('assets/images/home_banner.jpg')),
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.26,
                ),
                ClipPath(
                  clipper: Shape2(),
                  child: Container(height: 100, color: Theme.of(context).colorScheme.background),
                ),
                Transform.translate(
                  offset: const Offset(0, -10),
                  child: MainViewContent(scrollController: _scrollController),
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: SafeArea(
              child: Opacity(
                opacity: 1,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (auth.isAuth) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return auth.type == 2
                                ? AdminScreen()
                                : (auth.type == 1 ? DoctorScreen() : PatientScreen());
                          }));
                        } else {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()));
                        }
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        backgroundImage: Image.network(
                          auth.imageUrl ?? AppConstants.blankProfileImage,
                          fit: BoxFit.cover,
                        ).image,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 15,
            left: 13,
            // child: SafeArea(
            child: IconButton(
                onPressed: widget.toggleTheme,
                icon: const Icon(
                  Icons.brightness_6,
                  size: 20,
                  color: Color.fromARGB(255, 159, 159, 159),
                )),
            // ),
          ),
        ],
      ),
    );
  }
}
