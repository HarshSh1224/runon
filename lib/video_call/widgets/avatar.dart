import 'package:flutter/material.dart';
import 'package:runon/misc/constants/app_constants.dart';

enum VideoCallAvatarSize { small, normal, large }

class VideoCallAvatar extends StatelessWidget {
  VideoCallAvatar({
    Key? key,
    required this.networkImage,
    required this.widgetSize,
  }) : super(key: key);

  String networkImage;
  VideoCallAvatarSize widgetSize;

  @override
  Widget build(BuildContext context) {
    final double height = (widgetSize == VideoCallAvatarSize.small
        ? 20
        : (widgetSize == VideoCallAvatarSize.normal ? 30 : 40));
    final double rounding = (widgetSize == VideoCallAvatarSize.small ? 10 * 3 : 10 * 5);

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
