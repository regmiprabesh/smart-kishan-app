import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/models/unit.dart';
import 'package:smart_kishan/screens/marketplace/widgets/multiple_image_picker.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/widgets/input_text_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class AddSellProductScreen extends StatefulWidget {
  const AddSellProductScreen({super.key});

  @override
  State<AddSellProductScreen> createState() => _AddSellProductScreenState();
}

class _AddSellProductScreenState extends State<AddSellProductScreen> {
  final _productNameController = TextEditingController();
  final _productDescriptionController = TextEditingController();
  final _productStockController = TextEditingController();
  final _productPriceController = TextEditingController();
  int _selectedUnit = 0;
  int _selectedProductType = 0;
  int _selectedBuyersType = 0;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text('बजारको लागि उत्पादन थप्नुहोस्',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'उत्पादनको नाम',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(13),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                InputTextField(
                  textEditingController: _productNameController,
                  title: 'उत्पादनको को नाम प्रविष्ट गर्नुहोस्',
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return 'कृपया आफ्नो उत्पादनको को नाम प्रविष्ट गर्नुहोस्';
                    }
                    if (value.length < 3) {
                      return 'उत्पादनको नाम कम्तिमा पनि ३ अक्षरको हुनुपर्छ ';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'उत्पादनको प्रकार',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(13),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Obx(
                  () => DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      value: _selectedProductType != 0
                          ? _selectedProductType.toString()
                          : null,
                      // value: productController.selectedUnitId.value.isNotEmpty
                      //     ? productController.selectedUnitId.value
                      //     : null,
                      isExpanded: true,
                      style: const TextStyle(color: Colors.white),
                      items: productController.units
                          .map<DropdownMenuItem<String>>((Unit unit) {
                        return DropdownMenuItem<String>(
                          value: unit.id.toString(),
                          child: Row(
                            children: [
                              Text(
                                unit.name!,
                                style: const TextStyle(color: kCardTitleColor),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      hint: Text(
                        "उत्पादनको प्रकार चयन गर्नुहोस्।",
                        style: TextStyle(
                            fontSize: getProportionateScreenWidth(14),
                            fontWeight: FontWeight.w400),
                      ),
                      onChanged: ((value) {
                        setState(() {
                          _selectedProductType = int.tryParse(value!)!;
                        });
                        // productController.selectedUnitId(value);
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
                          thickness: WidgetStateProperty.all<double>(6),
                          thumbVisibility: WidgetStateProperty.all<bool>(true),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                        padding: EdgeInsets.only(left: 14, right: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'उत्पादनको विवरण',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(13),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                InputTextField(
                  textEditingController: _productDescriptionController,
                  title: 'उत्पादनको विवरण प्रविष्टि गर्नुहोस्',
                  maxLines: 4,
                ),
                const SizedBox(
                  height: 10,
                ),
                // MultipleImagePicker(),
                Text(
                  'स्टक',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(13),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                InputTextField(
                  textEditingController: _productStockController,
                  textInputType: TextInputType.number,
                  title: 'उत्पादनको स्टक मात्रा प्रविष्टि गर्नुहोस्',
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return 'कृपया उत्पादनको स्टक मात्रा प्रविष्टि गर्नुहोस् नभए ० हालिदिनु ';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'एकाइ',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(13),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Obx(
                  () => DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      value:
                          _selectedUnit != 0 ? _selectedUnit.toString() : null,
                      // value: productController.selectedUnitId.value.isNotEmpty
                      //     ? productController.selectedUnitId.value
                      //     : null,
                      isExpanded: true,
                      style: const TextStyle(color: Colors.white),
                      items: productController.units
                          .map<DropdownMenuItem<String>>((Unit unit) {
                        return DropdownMenuItem<String>(
                          value: unit.id.toString(),
                          child: Row(
                            children: [
                              Text(
                                unit.name!,
                                style: const TextStyle(color: kCardTitleColor),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      hint: Text(
                        "एकाइ चयन गर्नुहोस्।",
                        style: TextStyle(
                            fontSize: getProportionateScreenWidth(14),
                            fontWeight: FontWeight.w400),
                      ),
                      onChanged: ((value) {
                        setState(() {
                          _selectedUnit = int.tryParse(value!)!;
                        });
                        // productController.selectedUnitId(value);
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
                          thickness: WidgetStateProperty.all<double>(6),
                          thumbVisibility: WidgetStateProperty.all<bool>(true),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                        padding: EdgeInsets.only(left: 14, right: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'मूल्य',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(13),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                InputTextField(
                  textEditingController: _productPriceController,
                  textInputType: TextInputType.number,
                  title: 'उत्पादनको मूल्य प्रविष्टि गर्नुहोस्',
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return 'कृपया उत्पादनको मूल्य प्रविष्टि गर्नुहोस् ';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'न्यूनतम अर्डर',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(13),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                InputTextField(
                  textEditingController: _productPriceController,
                  textInputType: TextInputType.number,
                  title: 'न्यूनतम अर्डर प्रविष्टि गर्नुहोस्',
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return 'कृपया उत्पादनको न्यूनतम अर्डर प्रविष्टि गर्नुहोस् ';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'कस्टम विक्रेताहरू',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(13),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Obx(
                  () => DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      value: _selectedBuyersType != 0
                          ? _selectedBuyersType.toString()
                          : null,
                      // value: productController.selectedUnitId.value.isNotEmpty
                      //     ? productController.selectedUnitId.value
                      //     : null,
                      isExpanded: true,
                      style: const TextStyle(color: Colors.white),
                      items: productController.units
                          .map<DropdownMenuItem<String>>((Unit unit) {
                        return DropdownMenuItem<String>(
                          value: unit.id.toString(),
                          child: Row(
                            children: [
                              Text(
                                unit.name!,
                                style: const TextStyle(color: kCardTitleColor),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      hint: Text(
                        "कस्टम विक्रेताहरू चयन गर्नुहोस्।",
                        style: TextStyle(
                            fontSize: getProportionateScreenWidth(14),
                            fontWeight: FontWeight.w400),
                      ),
                      onChanged: ((value) {
                        setState(() {
                          _selectedBuyersType = int.tryParse(value!)!;
                        });
                        // productController.selectedUnitId(value);
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
                          thickness: WidgetStateProperty.all<double>(6),
                          thumbVisibility: WidgetStateProperty.all<bool>(true),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                        padding: EdgeInsets.only(left: 14, right: 14),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenWidth(20),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      minimumSize: Size(
                          double.infinity, getProportionateScreenWidth(40))),
                  child: productController.isEdit.value
                      ? const Text('अपडेट गर्नुहोस्')
                      : const Text('थप्नुहोस्'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (productController.isEdit.value) {
                        // productController.updateProduct(Product(
                        //     id: selectedProduct.id!,
                        //     name: _productNameController.text,
                        //     description: _productDescriptionController.text,
                        //     stock: int.tryParse(_productStockController.text),
                        //     unitId: _selectedUnit,
                        //     isSellable: _isSellable));
                      } else {
                        // productController.addProduct(Product(
                        //   name: _productNameController.text,
                        //   description: _productDescriptionController.text,
                        //   stock: int.tryParse(_productStockController.text),
                        //   unitId: _selectedUnit,
                        //   date: DateTime.now().toString(),
                        //   isSellable: _isSellable,
                        // ));
                      }
                    }
                  },
                ),
                SizedBox(
                  height: getProportionateScreenWidth(20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
