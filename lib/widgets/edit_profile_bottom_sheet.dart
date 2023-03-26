import 'dart:ui';
import 'package:runon/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EditBottomSheet extends StatefulWidget {
  const EditBottomSheet({super.key});

  @override
  State<EditBottomSheet> createState() => _EditBottomSheetState();
}

class _EditBottomSheetState extends State<EditBottomSheet> {
  Auth? auth;
  @override
  void initState() {
    auth = Provider.of<Auth>(context, listen: false);
    _pickedDate = auth!.dateOfBirth!;
    super.initState();
  }

  bool _isLoading = false;

  DateTime _pickedDate = DateTime(1001);

  final TextEditingController _dobController = TextEditingController();

  final Map<String, String?> _formData = {
    'fName': null,
    'lName': null,
    'address': null,
  };
  final GlobalKey<FormState> _formKey = GlobalKey();

  void _submit() async {
    // print('SUBMITTING');
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    print(_formData.toString());
    print(_pickedDate);

    setState(() {
      _isLoading = true;
    });
    try {
      //   if (auth!.isAuth == false) {
      //     throw const HttpException('Error');
      //   }

      await auth!.updateUserData(_formData['fName'], _formData['lName'],
          _pickedDate, _formData['address']);
      await auth!.tryLogin();
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Padding(padding: EdgeInsets.all(10.0), child: Text('Success'))));
      Navigator.of(context).pop();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(error.toString()))));
      Navigator.of(context).pop();
      // }
      // // print(formData);
      setState(() {
        _isLoading = false;
      });
    }

    // Future<void> _updateDataToServer() async {
    // if (_formData['name'] == auth!.name && _pickedImage == null) {
    //   print('NO CHANGE');
    //   return;
    // }
    // var imageUrl = null;
    // try {
    //   if (_pickedImage != null) {
    //     print('Changing image');
    //     final imgRef = await FirebaseStorage.instance
    //         .ref()
    //         .child('productImages')
    //         .child(auth!.userId!);
    //     await imgRef.putFile(_pickedImage!);
    //     print('Image changed');
    //     imageUrl = await imgRef.getDownloadURL();
    //     // print()
    //   }
    //   _formData['email'] = auth!.email;
    //   _formData['imageUrl'] = auth!.imageUrl;
    //   if (imageUrl != null) _formData['imageUrl'] = imageUrl;

    //   await FirebaseFirestore.instance
    //       .collection('users')
    //       .doc(auth!.userId)
    //       .set(_formData);

    //   print('Set Success' + _formData.toString());
    //   auth!.name = _formData['name'];
    //   auth!.imageUrl = _formData['imageUrl'];
    // } catch (error) {
    //   print('Error');
    //   throw error;
    // }
  }

  @override
  Widget build(BuildContext context) {
    _dobController.text = DateFormat('dd/MM/yyyy').format(auth!.dateOfBirth!);
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: Container(
        padding: MediaQuery.of(context).viewInsets,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: Theme.of(context).colorScheme.surfaceVariant,
          // color: Colors.transparent,
        ),
        // height: 220,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 30.0,
            right: 30.0,
            bottom: 30,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 7,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    width: 33,
                    height: 4,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Edit your profile',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                    _isLoading == true
                        ? const Center(
                            child: SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : IconButton(
                            onPressed: _submit,
                            icon: Icon(
                              Icons.done,
                              size: 30,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(8),
                          ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'First Name',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            // width: double.infinity,
                            // width: 200,
                            child: Card(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              margin: EdgeInsets.zero,
                              // color: Color(0xffEEE8F4).withOpacity(1),
                              // elevation: 6,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3)),
                              child: TextFormField(
                                initialValue: auth?.fName,
                                // autofillHints: ['Found a bug', 'Improve the profile page'],
                                style: const TextStyle(
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w700,
                                ),
                                decoration: InputDecoration(
                                  label: const Text(
                                    '',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  labelStyle: TextStyle(
                                      fontFamily: 'MoonBold',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer),
                                  contentPadding:
                                      const EdgeInsets.only(left: 12),
                                  // floatingLabelStyle: const TextStyle(
                                  //     height: 4, color: Color.fromARGB(255, 160, 26, 179)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10)),
                                  // prefixIcon: Icon(
                                  //   Icons.subject_rounded,
                                  //   // color: ,
                                  // ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'First Name can\'t be empty';
                                  } else if (value.length > 50) {
                                    return 'Maximum 15 characters allowed';
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (value) {
                                  _formData['fName'] = value!;
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Last Name',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            // width: double.infinity,
                            // width: 200,
                            child: Card(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              margin: EdgeInsets.zero,
                              // color: Color(0xffEEE8F4).withOpacity(1),
                              // elevation: 6,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3)),
                              child: TextFormField(
                                initialValue: auth?.lName,
                                // autofillHints: ['Found a bug', 'Improve the profile page'],
                                style: const TextStyle(
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w700,
                                ),
                                decoration: InputDecoration(
                                  label: const Text(
                                    '',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  labelStyle: TextStyle(
                                      fontFamily: 'MoonBold',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer),
                                  contentPadding:
                                      const EdgeInsets.only(left: 12),
                                  // floatingLabelStyle: const TextStyle(
                                  //     height: 4, color: Color.fromARGB(255, 160, 26, 179)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10)),
                                  // prefixIcon: Icon(
                                  //   Icons.subject_rounded,
                                  //   // color: ,
                                  // ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Last Name can\'t be empty';
                                  } else if (value.length > 50) {
                                    return 'Maximum 15 characters allowed';
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (value) {
                                  _formData['lName'] = value!;
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Date Of Birth',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    StatefulBuilder(builder: (context, setState) {
                      return Stack(
                        children: [
                          Card(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            margin: EdgeInsets.zero,
                            // color: Color(0xffEEE8F4).withOpacity(1),
                            // elevation: 6,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3)),
                            child: TextFormField(
                              controller: _dobController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                              readOnly: true,
                              style: const TextStyle(
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w700,
                              ),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                label: const Text(
                                  '',
                                  style: TextStyle(fontSize: 14),
                                ),
                                labelStyle: TextStyle(
                                    fontFamily: 'MoonBold',
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer),
                                contentPadding: const EdgeInsets.only(left: 12),
                                // floatingLabelStyle: const TextStyle(
                                //     height: 4, color: Color.fromARGB(255, 160, 26, 179)),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10)),
                                // prefixIcon: Icon(
                                //   Icons.subject_rounded,
                                //   // color: ,
                                // ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                              child: GestureDetector(
                            onTap: () async {
                              final temp = await showDatePicker(
                                  context: context,
                                  initialDate: auth!.dateOfBirth!,
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2050));

                              if (temp == null) return;
                              _pickedDate = temp;
                              // print(DateFormat('dd/MM/yyyy').format(temp));
                              setState(() {
                                _dobController.text =
                                    DateFormat('dd/MM/yyyy').format(temp);
                              });
                            },
                            child: Container(
                              color: Colors.transparent,
                            ),
                          )),
                        ],
                      );
                    }),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'City',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      // width: double.infinity,
                      // width: 200,
                      child: Card(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        margin: EdgeInsets.zero,
                        // color: Color(0xffEEE8F4).withOpacity(1),
                        // elevation: 6,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3)),
                        child: TextFormField(
                          initialValue: auth?.address,
                          // autofillHints: ['Found a bug', 'Improve the profile page'],
                          style: const TextStyle(
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w700,
                          ),
                          decoration: InputDecoration(
                            label: const Text(
                              '',
                              style: TextStyle(fontSize: 14),
                            ),
                            labelStyle: TextStyle(
                                fontFamily: 'MoonBold',
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer),
                            contentPadding: const EdgeInsets.only(left: 12),
                            // floatingLabelStyle: const TextStyle(
                            //     height: 4, color: Color.fromARGB(255, 160, 26, 179)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            // prefixIcon: Icon(
                            //   Icons.subject_rounded,
                            //   // color: ,
                            // ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _formData['address'] = value!;
                          },
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
