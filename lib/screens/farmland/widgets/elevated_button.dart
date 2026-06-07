import 'package:flutter/material.dart';
import 'package:smart_kishan/constant.dart';

class ElevatedBtn extends StatelessWidget {
  const ElevatedBtn({super.key, required this.title, required this.onTap});
  final String title;
  final GestureTapCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: kCanvasColor,
        textStyle: const TextStyle(color: kPrimaryColor),
        shadowColor: kPrimaryColor,
        side: const BorderSide(width: 1, color: kPrimaryColor), // foreground
      ),
      child: Text(
        title,
        style: const TextStyle(color: kPrimaryColor),
      ),
    );
  }
}
