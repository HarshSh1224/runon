import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runon/providers/auth.dart';

class FeedbackForm extends StatefulWidget {
  static const routeName = '/feedback-form';
  const FeedbackForm({super.key});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isLoading = false;

  Map<String, String>? formData;

  @override
  initState() {
    formData = {
      'subject': '',
      'body': '',
      'uid': Provider.of<Auth>(context, listen: false).userId!,
      'date': '',
    };
    super.initState();
  }

  void _sendEmail() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    String responseString = '';
    formData!['date'] = DateTime.now().toIso8601String();

    try {
      await FirebaseFirestore.instance
          .collection('user_messages')
          .add(formData!);
      responseString = 'Success. Thanks for feedback!';
    } catch (error) {
      responseString = 'An Error Occurred';
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(responseString),
    )));
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  // String _whichImageToUse() {
  //   if (widget._brandColor == Color(0xFFE91E63))
  //     return 'assets/images/feedback/7.png';
  //   if (widget._brandColor == Color(0xFF2196F3))
  //     return 'assets/images/feedback/1.png';
  //   if (widget._brandColor == Color(0xFF009688))
  //     return 'assets/images/feedback/3.png';
  //   if (widget._brandColor == Color(0xFF4CAF50))
  //     return 'assets/images/feedback/4.png';
  //   if (widget._brandColor == Color(0xFFFFEB3B))
  //     return 'assets/images/feedback/5.png';
  //   if (widget._brandColor == Color(0xFFFF9800))
  //     return 'assets/images/feedback/6.png';
  //   else
  //     return 'assets/images/feedback/2.png';
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              // color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          // backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          // foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
          title: const Text(
            'Feedback / Report a bug',
            style: TextStyle(
                fontSize: 18,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w700),
          )),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        // color: Color(0xffFFFBFF),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Help Us\nImprove',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w800,
                              fontSize: 25),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 300,
                          child: Text(
                            'Send messages directly to the Run On team',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        )
                      ],
                    ),
                    // Image.asset(
                    //   _whichImageToUse(),
                    //   height: 200,
                    // ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Card(
                  // color: Color(0xffEEE8F4).withOpacity(1),
                  elevation: 6,
                  child: TextFormField(
                    // autofillHints: ['Found a bug', 'Improve the profile page'],
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: InputDecoration(
                        label: const Text('Subject'),
                        labelStyle: const TextStyle(
                          fontFamily: 'MoonBold',
                        ),
                        // floatingLabelStyle: const TextStyle(
                        //     height: 4, color: Color.fromARGB(255, 160, 26, 179)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon: const Icon(
                          Icons.subject_rounded,
                          // color: ,
                        )),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Subject is required';
                      } else if (value.length > 100) {
                        return 'Subject can be maximum 100 characters long';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      formData?['subject'] = value!;
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Card(
                  // color: Color(0xffEEE8F4).withOpacity(1),
                  elevation: 6,
                  child: TextFormField(
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Body is required';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      formData?['body'] = value!;
                    },
                    maxLines: 5,
                    decoration: InputDecoration(
                        alignLabelWithHint: true,
                        label: const Text('Write here'),
                        labelStyle: const TextStyle(
                          fontFamily: 'MoonBold',
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(bottom: 110.0),
                          child: Icon(
                            Icons.edit,
                          ),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Card(
                  // color: Color(0xffEEE8F4).withOpacity(1),
                  elevation: 6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _sendEmail(),
                        child: SizedBox(
                          height: 60,
                          width: 120,
                          child: Center(
                            child: _isLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : Text(
                                    'Submit',
                                    style: TextStyle(
                                      fontFamily: 'MoonBold',
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
