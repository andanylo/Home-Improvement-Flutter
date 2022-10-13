import 'package:flutter/material.dart';

class FurnitureEditButton extends StatelessWidget {
  Icon icon;
  VoidCallback pressed;
  Color? foregroundColor;
  bool? isDisabled = false;
  FurnitureEditButton(
      {required this.icon,
      required this.pressed,
      this.foregroundColor,
      this.isDisabled});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
        child: ElevatedButton(
      onPressed: isDisabled == true ? null : () => pressed(),
      style: ElevatedButton.styleFrom(
          backgroundColor:
              isDisabled == true ? Colors.grey.shade800 : Colors.white,
          foregroundColor: isDisabled == true
              ? Colors.grey.shade600
              : (foregroundColor == null ? Colors.blue : foregroundColor!),
          fixedSize: const Size(75, 75),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      child: icon, // AspectRatio(aspectRatio: 1, child: icon),
    ));
  }
}
