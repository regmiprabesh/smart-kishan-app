import 'package:flutter/material.dart';
import 'package:smart_kishan/constant.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SafeArea(
            child: Center(
                child: CircularProgressIndicator(
      color: kPrimaryColor,
    ))));
  }
}
