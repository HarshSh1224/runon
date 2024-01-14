import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:runon/providers/auth.dart';
import 'package:runon/screens/patient/patient_screen.dart';
import 'package:runon/widgets/clip_paths.dart';
import '../screens/signup.dart';
import 'package:runon/screens/forgot_password_screen.dart';
import 'package:runon/screens/doctor/doctor_screen.dart';
import 'package:runon/screens/admin/admin_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();

  final Map<String, String> _formData = {'email': '', 'password': ''};

  bool _isLoading = false;

  @override
  dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  bool get kIsWeb {
    return MediaQuery.of(context).size.height <= MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          Container(),
          Opacity(
            opacity: 0.3,
            child: Image.asset(
              'assets/images/3_doctors.jpeg',
              height: kIsWeb ? MediaQuery.of(context).size.height : 300,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          Row(
            children: [
              if (kIsWeb) Expanded(flex: 5, child: Container()),
              Expanded(
                flex: 4,
                child: kIsWeb
                    ? _form(context)
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 250),
                            _clipPath(context),
                            _form(context),
                          ],
                        ),
                      ),
              ),
            ],
          ),
          Positioned(
            left: 15,
            child: SafeArea(
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Theme.of(context).colorScheme.background,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Transform _clipPath(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, 0.1),
      child: ClipPath(
        clipper: Shape2(),
        child: Container(
          height: 50,
          color: Theme.of(context).colorScheme.background,
        ),
      ),
    );
  }

  Widget _form(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: kIsWeb ? 70 : 30.0),
        color: Theme.of(context).colorScheme.background.withOpacity(kIsWeb ? 0.8 : 1),
        child: Column(
          children: [
            if (kIsWeb) Expanded(child: Container()),
            _welcomeBack(context),
            const SizedBox(height: 30),
            _emailField(context),
            const SizedBox(height: 10),
            _passwordField(context),
            _forgotPassword(context),
            if (kIsWeb) Expanded(child: Container()),
            _loginButton(),
            _or(),
            _signupButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Container _welcomeBack(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome\nBack',
            style: GoogleFonts.ubuntu(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground),
          ),
        ],
      ),
    );
  }

  Row _signupButton() {
    return Row(
      children: [
        Expanded(
          child: StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(SignupScreen.routeName);
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).colorScheme.outline,
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: _isLoading
                        ? Center(
                            child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.primaryContainer,
                            ),
                          ))
                        : const Text(
                            'SIGN UP',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 17),
                          ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Row _or() {
    return Row(
      children: const [
        Expanded(child: Divider()),
        Text('   or   '),
        Expanded(child: Divider()),
      ],
    );
  }

  Center _loginButton() {
    return Center(
      child: StatefulBuilder(builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
          child: FilledButton(
            onPressed: () {
              _submit(context, setState);
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: _isLoading
                      ? Center(
                          child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primaryContainer,
                          ),
                        ))
                      : const Text(
                          'LOGIN',
                          style: TextStyle(fontSize: 17),
                          textAlign: TextAlign.center,
                        ),
                )),
          ),
        );
      }),
    );
  }

  Row _forgotPassword(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(ForgotPasswordScreen.routeName);
          },
          child: Text(
            'Forgot Password?',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ],
    );
  }

  TextFormField _passwordField(BuildContext context) {
    return TextFormField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
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
            onPressed: () {
              _passwordController.clear();
              _passwordFocusNode.requestFocus();
            },
          ),
          label: const Text('Password'),
          // border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.key)),
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
    );
  }

  TextFormField _emailField(BuildContext context) {
    return TextFormField(
      controller: _emailController,
      focusNode: _emailFocusNode,
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
            onPressed: () {
              _emailController.clear();
              _emailFocusNode.requestFocus();
            },
          ),
          label: const Text('Email'),
          prefixIcon: const Icon(Icons.person)
          // border: const OutlineInputBorder(),
          ),
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
    );
  }

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
      int type = await Provider.of<Auth>(context, listen: false).authenticate(
          context: context, email: _formData['email']!, password: _formData['password']!);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Text('Welcome'),
        ),
      ));
      // print('TYPE: $type');
      Navigator.of(context).pushReplacementNamed(type == 1
          ? DoctorScreen.routeName
          : (type == 2 ? AdminScreen.routeName : PatientScreen.routeName));
      setState(() {
        _isLoading = false;
      });
      return;
    } catch (error) {
      // Below Snackbar is producing bugs on login

      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Padding(
      //   padding: EdgeInsets.symmetric(vertical: 10.0),
      //   child: Text('Internal Error'),
      // )));
      debugPrint('ERROR: $error');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // setState(() {
    //   _isLoading = false;
    // });
  }
}
