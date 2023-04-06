import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:runon/providers/auth.dart';
import '../screens/patient_screen.dart';
import '../screens/signup.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/clip_paths.dart';
import 'package:runon/screens/forgot_password_screen.dart';
import 'package:runon/screens/doctor_screen.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';
  LoginScreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey();

  final Map<String, String> _formData = {'email': '', 'password': ''};
  bool _isLoading = false;

  void _submit(context, setState) async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Auth>(context, listen: false).authenticate(
          context: context,
          email: _formData['email']!,
          password: _formData['password']!);
      Navigator.of(context).pushReplacementNamed(
          Provider.of<Auth>(context, listen: false).type == 1
              ? DoctorScreen.routeName
              : PatientScreen.routeName);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Text('Internal Error'),
      )));
      setState(() {
        _isLoading = false;
      });
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Text('Welcome'),
      ),
    ));

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
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
                child: Form(
                  key: _formKey,
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _formData['email'] = value!;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {},
                          ),
                          label: const Text('Email'),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 8) {
                            return 'Password has to be min 8 characters long';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _formData['password'] = value!;
                        },
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
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(ForgotPasswordScreen.routeName);
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Transform.scale(
                          scale: 1.2,
                          child: StatefulBuilder(builder: (context, setState) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 35.0, vertical: 10),
                              child: FilledButton(
                                onPressed: () {
                                  _submit(context, setState);
                                },
                                child: SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      child: _isLoading
                                          ? Center(
                                              child: SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primaryContainer,
                                              ),
                                            ))
                                          : const Text(
                                              'LOGIN',
                                              textAlign: TextAlign.center,
                                            ),
                                    )),
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                                children: [
                              const TextSpan(text: 'Dont have an account? '),
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context)
                                          .pushNamed(SignupScreen.routeName);
                                    },
                                  text: 'Sign Up',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary))
                            ])),
                      ),
                      const SizedBox(
                        height: 70,
                      )
                    ],
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
