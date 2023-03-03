import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth with ChangeNotifier {
  String? userId;
  String? fName;
  String? lName;
  int? type;
  DateTime? dateOfBirth;
  String? gender;
  String? address;
  String? email;

  bool get isAuth {
    return userId == null;
  }

  Future<void> authenticate(
      {required BuildContext context,
      required String email,
      required String password,
      bool isSignUp = false,
      Map<String, dynamic>? userData}) async {
    final auth = FirebaseAuth.instance;
    try {
      if (isSignUp) {
        print('Signing up');
        final authResponse = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        userId = authResponse.user!.uid;

        print('Adding User');

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .set(userData!);
        fName = userData['fName'];
        lName = userData['lName'];
        type = int.parse('${userData['type']}');
        dateOfBirth = DateTime.parse('${userData['dateOfBirth']}');
        address = userData['address'];
        gender = userData['gender'];
        email = userData['email'];
      } else {
        final authResponse = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        userId = authResponse.user!.uid;

        final fetchedUserData = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        final userDataLogin = fetchedUserData.data();
        fName = userDataLogin!['fName'];
        lName = userDataLogin['lName'];
        type = int.parse('${userDataLogin['type']}');
        dateOfBirth = DateTime.parse(userDataLogin['dateOfBirth']);
        address = userDataLogin['address'];
        gender = userDataLogin['gender'];
        email = userDataLogin['email'];

        print('Login Success ');
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text(error.message.toString()),
      )));
      rethrow;
    }
  }
}
