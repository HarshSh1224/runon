import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runon/screens/otp_screen.dart';

class Auth with ChangeNotifier {
  String? userId;
  String? fName;
  String? lName;
  String? phone;
  int? type;
  DateTime? dateOfBirth;
  String? gender;
  String? address;
  String? email;

  bool get isAuth {
    return userId == null;
  }

  Future<void> signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await FirebaseAuth.instance
                .signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            throw Exception(error);
          },
          codeSent: ((verificationId, forceResendingToken) {
            Navigator.push(context,
                MaterialPageRoute(builder: ((context) => OTPScreen())));
          }),
          codeAutoRetrievalTimeout: (verificationId) {});
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message.toString())));
    }
  }
}
