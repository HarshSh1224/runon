import 'package:flutter/material.dart';
import '../screens/patient_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/clip_paths.dart';

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
          SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
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
                      keyboardType: TextInputType.phone,
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
                      child: Transform.scale(
                        scale: 1.2,
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
