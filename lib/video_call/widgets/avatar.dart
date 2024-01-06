import 'package:flutter/material.dart';
import 'package:runon/misc/constants/app_constants.dart';

class VideoCallAvatar extends StatelessWidget {
  VideoCallAvatar({
    Key? key,
    required this.networkImage,
  }) : super(key: key);

  String networkImage;

  @override
  Widget build(BuildContext context) {
    const double height = 100;
    const double rounding = 50;

    return Container(
      height: height,
      width: height,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(rounding),
          boxShadow: const [
            BoxShadow(
              color: Colors.black87,
              offset: Offset(-5, 5.5),
              blurRadius: 4,
              spreadRadius: 0.0,
            ),
          ]),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(rounding * 0.87),
          child: networkImage.isEmpty
              ? Image.network(
                  AppConstants.blankProfileImage,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  networkImage,
                  fit: BoxFit.fitHeight,
                )),
    );
  }
}
