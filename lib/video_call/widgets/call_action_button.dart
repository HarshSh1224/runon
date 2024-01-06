import 'package:flutter/material.dart';

class CallActionButton extends StatelessWidget {
  const CallActionButton({
    Key? key,
    required this.onTap,
    this.isVideoCall = false,
    this.size = 80,
  }) : super(key: key);

  final Function() onTap;
  final double size;
  final bool isVideoCall;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size,
        width: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
        ),
        child: Center(
            child: Icon(
          Icons.call_end,
          color: Colors.white,
          size: size / 2,
        )),
      ),
    );
  }
}
