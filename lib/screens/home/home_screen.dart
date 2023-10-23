import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runon/misc/constants/app_constants.dart';
import 'package:runon/providers/auth.dart';
import 'package:runon/screens/admin/admin_screen.dart';
import 'package:runon/screens/doctor/doctor_screen.dart';
import 'package:runon/screens/home/main_view_content.dart/main_view_content.dart';
import 'package:runon/screens/login.dart';
import 'package:runon/screens/patient/patient_screen.dart';
import 'package:runon/widgets/clip_paths.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
    final auth = Provider.of<Auth>(
      context,
    );
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
                  child: const MainViewContent(),
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
                child: GestureDetector(
                  onTap: () {
                    if (auth.isAuth) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return auth.type == 2
                            ? AdminScreen()
                            : (auth.type == 1 ? DoctorScreen() : PatientScreen());
                      }));
                    } else {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const LoginScreen()));
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// StreamBuilder<User?>(
//             stream: FirebaseAuth.instance.authStateChanges(),
//             builder: (context, snapshot) {
//               return !snapshot.hasData
//                   ? const LoginScreen()
//                   : FutureBuilder(
//                       future: auth.tryLogin(),
//                       builder: (context, snapshot) {
//                         // print(FirebaseAuth.instance.currentUser!.uid);
//                         return snapshot.connectionState == ConnectionState.waiting
//                             ? const Scaffold(
//                                 body: Center(child: CircularProgressIndicator()),
//                               )
//                             : auth.type == 1
//                                 ? DoctorScreen()
//                                 : (auth.type == 2 ? AdminScreen() : PatientScreen());
//                       },
//                     );
//             },
//           ),

