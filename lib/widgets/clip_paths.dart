import 'package:flutter/material.dart';

class UpperEllipse extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path0 = Path();
    path0.moveTo(size.width, 0);
    path0.moveTo(size.width * 0.3, 0);
    path0.lineTo(size.width * 0.3, 0);
    path0.quadraticBezierTo(
        size.width * 0.6, size.height * 0.15, size.width, size.height * 0.13);
    path0.lineTo(size.width, 0);
    path0.moveTo(size.width, 0);
    path0.close();
    return path0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class LowerEllipse extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path0 = Path();
    path0.moveTo(0, size.height);
    path0.moveTo(size.width * 0.3, size.height);
    path0.lineTo(size.width * 0.3, size.height);
    path0.quadraticBezierTo(
        size.width * 0.28, size.height * 0.7, 0, size.height * 0.5);
    path0.lineTo(0, size.height);
    path0.moveTo(0, size.height);
    path0.close();
    return path0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class OneThirdScreenCoverEllipse extends CustomClipper<Path> {
  final double amount;
  OneThirdScreenCoverEllipse(this.amount);
  @override
  Path getClip(Size size) {
    Path path0 = Path();
    path0.moveTo(0, size.height);
    path0.lineTo(size.width, size.height);
    path0.lineTo(size.width, size.height * 0.3);
    path0.quadraticBezierTo(
        size.width * 0.5, size.height * amount, 0, size.height * 0.3);
    path0.close();
    return path0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class OnlyBottomEllipse extends CustomClipper<Path> {
  final double amount;
  OnlyBottomEllipse(this.amount);
  @override
  Path getClip(Size size) {
    Path path0 = Path();
    path0.moveTo(0, size.height);
    path0.lineTo(size.width, size.height);
    // path0.lineTo(size.width, size.height * 0.3);
    path0.quadraticBezierTo(
        size.width * 0.5, size.height * amount, 0, size.height);
    path0.close();
    return path0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
