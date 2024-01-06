import 'package:flutter/material.dart';

class ToolbarButton extends StatelessWidget {
  const ToolbarButton(
      {required this.icon,
      required this.toggleWith,
      required this.onPressed,
      required this.isDisabled,
      this.largeButton = false,
      Key? key})
      : super(key: key);

  final IconData icon;
  final bool toggleWith;
  final Function() onPressed;
  final bool isDisabled;
  final bool largeButton;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: isDisabled ? null : onPressed,
      shape: const CircleBorder(),
      elevation: 0.0,
      fillColor: !isDisabled
          ? toggleWith
              ? Colors.green.withOpacity(0.4)
              : Colors.white.withOpacity(0.2)
          : Colors.grey.withOpacity(0.5),
      padding: const EdgeInsets.all(15),
      child: Icon(
        icon,
        color: !isDisabled ? (toggleWith ? Colors.white : Colors.green) : Colors.grey,
        size: largeButton ? 40.0 : 25.0,
      ),
    );
  }
}
