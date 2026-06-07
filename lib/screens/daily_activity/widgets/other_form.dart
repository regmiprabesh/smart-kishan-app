import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/models/product.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/widgets/input_text_field.dart';

class OtherForm extends StatelessWidget {
  const OtherForm(
      {super.key,
      required this.sellingPriceController,
      required this.costPriceController});

  final TextEditingController sellingPriceController;
  final TextEditingController costPriceController;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          'खर्च',
          style: TextStyle(
            fontSize: getProportionateScreenWidth(13),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        InputTextField(
          textEditingController: costPriceController,
          textInputType: TextInputType.number,
          title: 'खर्च (छ भने)',
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'आम्दानी',
          style: TextStyle(
            fontSize: getProportionateScreenWidth(13),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        InputTextField(
          textEditingController: sellingPriceController,
          textInputType: TextInputType.number,
          title: 'आम्दानी (छ भने)',
        ),
      ],
    );
  }
}
