import 'package:flutter/material.dart';

class FurnitureEditButton extends StatelessWidget {
  Icon icon;
  VoidCallback pressed;
  Color? foregroundColor;
  FurnitureEditButton(
      {required this.icon, required this.pressed, this.foregroundColor});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
        child: ElevatedButton(
      onPressed: () => pressed(),
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor:
              foregroundColor == null ? Colors.blue : foregroundColor!,
          fixedSize: const Size(75, 75),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      child: icon, // AspectRatio(aspectRatio: 1, child: icon),
    ));
  }
}
