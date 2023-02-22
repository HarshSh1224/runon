import 'package:flutter/material.dart';
import '../screens/patient_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ClipPath(
            clipper: UpperEllipse(),
            child: Container(color: Theme.of(context).colorScheme.primary),
          ),
          ClipPath(
            clipper: LowerEllipse(),
            child: Container(
                color: Theme.of(context).colorScheme.primaryContainer),
          ),
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Center(
                      child: Text(
                        'RUN ON\nLOGO',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.bebasNeue(
                          fontSize: 40,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text('Login to your account'),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {},
                        ),
                        label: const Text('Mobile Number'),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {},
                        ),
                        label: const Text('Password'),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot Password?',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(PatientScreen.routeName);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 38.0, vertical: 10),
                          child: Text('LOGIN'),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Text('Dont have an account?'),
                    const SizedBox(
                      height: 70,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UpperEllipse extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path0 = Path();
    path0.moveTo(size.width, 0);
    path0.moveTo(size.width * 0.3, 0);
    path0.lineTo(size.width * 0.3, 0);
    path0.quadraticBezierTo(
        size.width * 0.6, size.height * 0.15, size.width, size.height * 0.13);
    path0.lineTo(size.width, 0);
    path0.moveTo(size.width, 0);
    path0.close();
    return path0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class LowerEllipse extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path0 = Path();
    path0.moveTo(0, size.height);
    path0.moveTo(size.width * 0.3, size.height);
    path0.lineTo(size.width * 0.3, size.height);
    path0.quadraticBezierTo(
        size.width * 0.28, size.height * 0.7, 0, size.height * 0.5);
    path0.lineTo(0, size.height);
    path0.moveTo(0, size.height);
    path0.close();
    return path0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
