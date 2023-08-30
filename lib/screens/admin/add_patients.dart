import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AddPatients extends StatelessWidget {
  static const routName="/add-patient";

  final TextEditingController _dobController=TextEditingController();

  final GlobalKey<FormState> _formKey=GlobalKey();

  DateTime _pickedDate = DateTime(1001);

  final TextEditingController _passwordController=TextEditingController();
  bool _isLoading=false;

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

  void _submitForm(BuildContext context, setState) async {
    // print("Entered submit form");
    FocusScope.of(context).unfocus();
    final isValid=_formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (_pickedDate == DateTime(1001)) return;
    _formKey.currentState!.save();
    _formData['dateOfBirth'] = _pickedDate.toIso8601String();

    setState(() {
      _isLoading = true;
    });

    try {
      FirebaseApp tempApp =
          await Firebase.initializeApp(name: 'temporaryregister', options: Firebase.app().options);
      UserCredential authResponse = await FirebaseAuth.instanceFor(app: tempApp)
          .createUserWithEmailAndPassword(
              email: _formData['email'], password: _passwordController.text);

      final userId = authResponse.user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(userId).set(_formData);
      // print(_formData);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Text('Patient Added!'),
        ),
      ));
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text(error.message.toString()),
      )));
      setState(() {
        _isLoading = false;
      });
      rethrow;
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      // print(error.toString());
      return;
    }

    setState(() {
      _isLoading = false;
    });
    // print(_formData);
  }

  AddPatients({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Patient"),centerTitle: true,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
               const SizedBox(height: 30,),
               Text(
                "Patient Login Details",
                style: GoogleFonts.raleway(fontSize: 25, fontWeight: FontWeight.bold),
                ),
               const SizedBox(height: 30,),
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
                          _formData['fName'] = value;
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
                          _formData['lName'] = value;
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
                const SizedBox(height: 10,),
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
                const SizedBox(height: 10,),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: StatefulBuilder(builder: (context, setState) {
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
                                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1950),
                                    lastDate: DateTime(2050));

                                if (temp == null) return;
                                _pickedDate = temp;
                                setState(() {
                                  _dobController.text = DateFormat('dd/MM/yyyy').format(temp);
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
                            _formData['gender'] = value;
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), label: Text('Gender*')),
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
                const SizedBox(height: 10,),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    return null;
                  },
                  onSaved: (value) {
                    _formData['address'] = value;
                  },
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    label: Text('Address* (City)'),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10,),
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
                const SizedBox(height: 10,),
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
                const SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StatefulBuilder(builder: (context, setState) {
                      return SizedBox(
                        height: 60,
                        width: 270,
                        child: FilledButton(
                            onPressed: () {
                              _submitForm(context, setState);
                            },
                            child: _isLoading
                                ? Center(
                                    child: FittedBox(
                                      child: CircularProgressIndicator(
                                        color: Theme.of(context).colorScheme.primaryContainer,
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Add Patient  ',
                                          style: GoogleFonts.roboto(
                                              fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                        const Icon(Icons.double_arrow_outlined),
                                      ],
                                    ),
                                  )),
                      );
                    }),
                  ],
                ),
                const SizedBox(
                  height: 100,
                )
              ]),
              
            ),
        ),
        ),
    );
  }
}