import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Auth with ChangeNotifier {
  String? imageUrl;
  String? userId;
  String? fName;
  String? lName;
  int? type;
  DateTime? dateOfBirth;
  String? gender;
  String? address;
  String? email;

  Auth({
    this.imageUrl,
    this.userId,
    this.fName,
    this.lName,
    this.type,
    this.address,
    this.dateOfBirth,
    this.email,
    this.gender,
  });

  bool get isAuth {
    return userId != null;
  }

  String get age {
    return (DateTime.now().year - dateOfBirth!.year).toString();
  }

  Future<int> authenticate(
      {required BuildContext context,
      required String email,
      required String password,
      bool isSignUp = false,
      Map<String, dynamic>? userData}) async {
    final auth = FirebaseAuth.instance;
    try {
      if (isSignUp) {
        final authResponse =
            await auth.createUserWithEmailAndPassword(email: email, password: password);
        userId = authResponse.user!.uid;

        await FirebaseFirestore.instance.collection('users').doc(userId).set(userData!);
        fName = userData['fName'];
        lName = userData['lName'];
        type = int.parse('${userData['type']}');
        dateOfBirth = DateTime.parse('${userData['dateOfBirth']}');
        address = userData['address'];
        gender = userData['gender'];
        email = userData['email'];
        imageUrl = userData['imageUrl'];
      } else {
        final authResponse =
            await auth.signInWithEmailAndPassword(email: email, password: password);
        userId = authResponse.user!.uid;

        final fetchedUserData =
            await FirebaseFirestore.instance.collection('users').doc(userId).get();
        final userDataLogin = fetchedUserData.data();
        fName = userDataLogin!['fName'];
        lName = userDataLogin['lName'];
        type = int.parse('${userDataLogin['type']}');
        dateOfBirth = DateTime.parse(userDataLogin['dateOfBirth']);
        address = userDataLogin['address'];
        gender = userDataLogin['gender'];
        email = userDataLogin['email'];
        imageUrl = userDataLogin['imageUrl'];
      }
      return type!;
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text(error.message.toString()),
      )));
      rethrow;
    }
  }

  Future<void> tryLogin() async {
    final currUser = FirebaseAuth.instance.currentUser;
    if (currUser != null) {
      final DocumentSnapshot<Map<String, dynamic>> userData;
      try {
        userData = await FirebaseFirestore.instance.collection('users').doc(currUser.uid).get();

        userId = currUser.uid;
        final userDataLogin = userData.data();
        fName = userDataLogin!['fName'];
        lName = userDataLogin['lName'];
        type = int.parse('${userDataLogin['type']}');
        dateOfBirth = DateTime.parse(userDataLogin['dateOfBirth']);
        address = userDataLogin['address'];
        gender = userDataLogin['gender'];
        email = userDataLogin['email'];
        imageUrl = userDataLogin['imageUrl'];

        // print('FETCHED IMAGE URL $imageUrl');
      } catch (error) {
        rethrow;
      }
    }
  }

  void logout() {
    FirebaseAuth.instance.signOut();
    userId = null;
    fName = null;
    lName = null;
    type = null;
    dateOfBirth = null;
    address = null;
    gender = null;
    email = null;
    imageUrl = null;
  }

  Future<void> updateUserData(fname, lname, DateTime dob, addresss) async {
    final formData = {
      'fName': fname,
      'lName': lname,
      'type': type,
      'dateOfBirth': dob.toIso8601String(),
      'gender': gender,
      'email': email,
      'address': addresss,
      'imageUrl': imageUrl,
    };

    try {
      FirebaseFirestore.instance.collection('users').doc(userId).set(formData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProfileImage(File image) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('profilePics').child(userId!);
      await ref.putFile(image);
      final url = await ref.getDownloadURL();

      final formData = {
        'fName': fName,
        'lName': lName,
        'type': type,
        'dateOfBirth': dateOfBirth!.toIso8601String(),
        'gender': gender,
        'email': email,
        'address': address,
        'imageUrl': url,
      };

      await FirebaseFirestore.instance.collection('users').doc(userId).set(formData);
    } catch (error) {
      rethrow;
    }
  }

  factory Auth.fromMap(Map<String, dynamic> json, String userId) {
    return Auth(
      userId: userId,
      fName: json['fName'],
      lName: json['lName'],
      imageUrl: json['imageUrl'],
      address: json['address'],
      email: json['email'],
      gender: json['gender'],
      type: int.parse('${json['type']}'),
      dateOfBirth: DateTime.parse('${json['dateOfBirth']}'),
    );
  }
}
