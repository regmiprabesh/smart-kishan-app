import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/models/product.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/widgets/input_text_field.dart';

class SellForm extends StatelessWidget {
  const SellForm(
      {super.key,
      required this.quantityController,
      required this.sellPriceController});

  final TextEditingController quantityController;
  final TextEditingController sellPriceController;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          'उत्पादन',
          style: TextStyle(
            fontSize: getProportionateScreenWidth(13),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  value:
                      dailyActivityController.selectedProductId.value.isNotEmpty
                          ? dailyActivityController.selectedProductId.value
                          : null,
                  isExpanded: true,
                  style: const TextStyle(color: Colors.white),
                  items: productController.sellableProducts
                      .map<DropdownMenuItem<String>>((Product product) {
                    return DropdownMenuItem<String>(
                      value: product.id.toString(),
                      child: Row(
                        children: [
                          Text(
                            product.name!,
                            style: const TextStyle(color: kCardTitleColor),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  hint: Text(
                    "उत्पादन चयन गर्नुहोस्",
                    style: TextStyle(
                        fontSize: getProportionateScreenWidth(14),
                        fontWeight: FontWeight.w400),
                  ),
                  onChanged: ((value) {
                    dailyActivityController.selectedProductId(value);
                  }),
                  buttonStyleData: ButtonStyleData(
                    decoration: BoxDecoration(
                        border: Border.all(color: kCardDescColor),
                        borderRadius: BorderRadius.circular(8)),
                    height: 48,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    elevation: 0,
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(CupertinoIcons.chevron_down, size: 20),
                    iconSize: 14,
                    iconEnabledColor: kPrimaryColor,
                    iconDisabledColor: Colors.grey,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 400,
                    width: SizeConfig.screenWidth -
                        getProportionateScreenWidth(30),
                    decoration: const BoxDecoration(
                      color: kCanvasColor,
                    ),
                    offset: const Offset(0, -5),
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(40),
                      thickness: MaterialStateProperty.all<double>(6),
                      thumbVisibility: MaterialStateProperty.all<bool>(true),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                    padding: EdgeInsets.only(left: 14, right: 14),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              productController.sellableProducts.isEmpty
                  ? const Text(
                      'तपाईंको बिक्री गर्न मिल्ने उत्पादन हाल खाली छ ।',
                      style: TextStyle(color: kErrorColor),
                    )
                  : const SizedBox(),
              Text(
                'परिणाम',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(13),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              InputTextField(
                textEditingController: quantityController,
                textInputType: TextInputType.number,
                title: 'मात्रा प्रविष्टि गर्नुहोस्',
                validation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'कृपया मात्रा प्रविष्टि गर्नुहोस्';
                  }
                  // Product selectedProduct = productController.products[
                  //     productController.products.indexWhere((element) =>
                  //         element.id ==
                  //         int.tryParse(dailyActivityController
                  //             .selectedProductId.value))];
                  // if (int.tryParse(value)! >
                  //     int.tryParse(selectedProduct.stock!.toString())!) {
                  //   return "Stock Less Than Selling Quantity";
                  // }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'बिक्री मूल्य',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(13),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              InputTextField(
                textEditingController: sellPriceController,
                textInputType: TextInputType.number,
                title: 'लागत मूल्य प्रविष्टि गर्नुहोस्',
                validation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'कृपया आफ्नो बिक्री मूल्य प्रविष्टि गर्नुहोस्';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
