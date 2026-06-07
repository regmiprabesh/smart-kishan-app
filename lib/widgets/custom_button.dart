import 'package:flutter/material.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/size_config.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key, required this.onPressed, required this.isLoading});
  final Function onPressed;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed(),
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          minimumSize: Size(getProportionateScreenWidth(200),
              getProportionateScreenWidth(50)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  color: Colors.black,
                  strokeWidth: 2,
                ),
              )
            : const Text('Request OTP'));
  }
}
