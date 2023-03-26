import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runon/providers/auth.dart';
import '../screens/patient_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/clip_paths.dart';
import 'package:intl/intl.dart';

class SignupScreen extends StatelessWidget {
  static const routeName = '/signup';
  SignupScreen({super.key});

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  DateTime _pickedDate = DateTime(1001);
  bool _isLoading = false;

  final Map<String, dynamic> _formData = {
    'fName': '',
    'lName': '',
    'type': 0,
    'dateOfBirth': '',
    'gender': '',
    'email': '',
    'address': '',
    'imageUrl':
        'https://firebasestorage.googleapis.com/v0/b/runon-c2c2e.appspot.com/o/profilePics%2Fdefault.jpg?alt=media&token=dbbd8628-1910-40dd-a2cc-fdf9ba86278e'
  };

  void _submit(BuildContext context, setState) async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_pickedDate == DateTime(1001)) return;
    _formKey.currentState!.save();
    _formData['dateOfBirth'] = _pickedDate.toIso8601String();

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Auth>(context, listen: false).authenticate(
        context: context,
        email: _formData['email']!,
        password: _passwordController.text,
        isSignUp: true,
        userData: _formData,
      );
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print(error.toString());
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Text('Success'),
      ),
    ));

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pushReplacementNamed(PatientScreen.routeName);
    // print(_formData);
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
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          child: const Icon(
                            Icons.person,
                            size: 35,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          'Sign up',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.bebasNeue(
                            fontSize: 30,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Text('Create a new account'),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null) return 'Required';
                                if (value.length < 3) {
                                  return 'Min 3 characters allowed';
                                }
                                if (value.length > 15) {
                                  return 'Max 15 characters allowed';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _formData['fName'] = value!;
                              },
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                label: FittedBox(child: Text('First Name*')),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            flex: 1,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null) return 'Required';
                                if (value.length < 3) {
                                  return 'Min 3 characters allowed';
                                }
                                if (value.length > 15) {
                                  return 'Max 15 characters allowed';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _formData['lName'] = value!;
                              },
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                label: FittedBox(child: Text('Last Name*')),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null) return 'Required';
                          if (value.length < 3 || !value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _formData['email'] = value!;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          label: Text('Email*'),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child:
                                StatefulBuilder(builder: (context, setState) {
                              return Stack(
                                children: [
                                  TextFormField(
                                    controller: _dobController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      }
                                      return null;
                                    },
                                    readOnly: true,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      label: FittedBox(child: Text('DOB*')),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  Positioned.fill(
                                      child: GestureDetector(
                                    onTap: () async {
                                      final temp = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1950),
                                          lastDate: DateTime(2050));

                                      if (temp == null) return;
                                      _pickedDate = temp;
                                      setState(() {
                                        _dobController.text =
                                            DateFormat('dd/MM/yyyy')
                                                .format(temp);
                                      });
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                    ),
                                  )),
                                ],
                              );
                            }),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                              flex: 1,
                              child: DropdownButtonFormField(
                                validator: (value) {
                                  if (value == null) return 'Required';
                                  return null;
                                },
                                onSaved: (value) {
                                  _formData['gender'] = value!;
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    label: Text('Gender*')),
                                onChanged: (value) {},
                                items: const [
                                  DropdownMenuItem(
                                    value: 'M',
                                    child: Text('Male'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'F',
                                    child: Text('Female'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'O',
                                    child: Text('Other'),
                                  ),
                                ],
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Required';
                          return null;
                        },
                        onSaved: (value) {
                          _formData['address'] = value!;
                        },
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          label: Text('Address* (City)'),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null) return 'Required';
                          if (value.length < 8) {
                            return 'Password should be minimum 8 characters long';
                          }
                          return null;
                        },
                        controller: _passwordController,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                          label: Text('Password*'),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords don\'t match';
                          }
                          return null;
                        },
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                          label: Text('Confirm Password*'),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      RichText(
                        text: TextSpan(
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                            children: [
                              const TextSpan(
                                  text: 'By continuing, you agree to the  '),
                              TextSpan(
                                  text: 'Terms of Service ',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                              const TextSpan(text: 'and '),
                              TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                            ]),
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
                                  // auth.signInWithPhone(context, '+919711978966');
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
                                              'Signup',
                                              textAlign: TextAlign.center,
                                            ),
                                    )),
                              ),
                            );
                          }),
                        ),
                      ),
                      Center(
                        child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/');
                            },
                            child: Text(
                              'Login Instead',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                            )),
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
