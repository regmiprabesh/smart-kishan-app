import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/models/unit.dart';
import 'package:smart_kishan/models/product.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/widgets/input_text_field.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _productNameController = TextEditingController();
  final _productDescriptionController = TextEditingController();
  final _productStockController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  int _selectedUnit = 0;

  final List<Map<String, dynamic>> buyOptions = [
    {
      'id': '1',
      'name': 'बिक्री',
      'icon': Icons.trending_up,
      'color': Colors.green,
    },
    {
      'id': '2',
      'name': 'खरिद',
      'icon': Icons.shopping_bag,
      'color': Colors.blue,
    },
    {
      'id': '3',
      'name': 'दुबै',
      'icon': Icons.swap_horiz,
      'color': Colors.orange,
    }
  ];

  int _isSellable = 0;

  Product selectedProduct = Product();

  @override
  void initState() {
    if (productController.isEdit.value) {
      setState(() {
        selectedProduct = productController.selectedProduct.value;
      });
      _productNameController.text = selectedProduct.name!;
      _productStockController.text = selectedProduct.stock!.toString();
      _productDescriptionController.text = selectedProduct.description != null
          ? selectedProduct.description!
          : '';
      _isSellable = selectedProduct.isSellable!;
      _selectedUnit =
          selectedProduct.unitId != null ? selectedProduct.unitId! : 0;
    }
    super.initState();
  }

  Widget _buildSectionLabel(String text, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(getProportionateScreenWidth(8)),
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: kPrimaryColor,
            size: getProportionateScreenWidth(18),
          ),
        ),
        SizedBox(width: getProportionateScreenWidth(10)),
        Text(
          text,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(14),
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(getProportionateScreenWidth(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildStyledDropdown({
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required String hint,
    required Function(String?) onChanged,
    IconData? prefixIcon,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          value: value,
          isExpanded: true,
          isDense: true,
          style: const TextStyle(color: Colors.white),
          items: items,
          hint: Row(
            children: [
              if (prefixIcon != null) ...[
                Icon(
                  prefixIcon,
                  size: getProportionateScreenWidth(18),
                  color: Colors.grey.shade500,
                ),
                SizedBox(width: getProportionateScreenWidth(10)),
              ],
              Expanded(
                child: Text(
                  hint,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(14),
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
          onChanged: onChanged,
          buttonStyleData: ButtonStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            height: getProportionateScreenWidth(50),
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(12),
            ),
            elevation: 0,
          ),
          iconStyleData: IconStyleData(
            icon: Icon(
              CupertinoIcons.chevron_down,
              size: getProportionateScreenWidth(18),
            ),
            iconSize: 14,
            iconEnabledColor: kPrimaryColor,
            iconDisabledColor: Colors.grey,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 300,
            width: SizeConfig.screenWidth - getProportionateScreenWidth(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            offset: const Offset(0, -5),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all<double>(6),
              thumbVisibility: MaterialStateProperty.all<bool>(true),
            ),
          ),
          menuItemStyleData: MenuItemStyleData(
            height: getProportionateScreenWidth(44),
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(14),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBuyOptionCard(Map<String, dynamic> option) {
    final isSelected = _isSellable.toString() == option['id'];
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isSellable = int.parse(option['id']);
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            vertical: getProportionateScreenWidth(14),
          ),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      option['color'],
                      option['color'].withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected ? null : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? option['color'] : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: option['color'].withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Icon(
                option['icon'],
                color: isSelected ? Colors.white : Colors.grey.shade600,
                size: getProportionateScreenWidth(26),
              ),
              SizedBox(height: getProportionateScreenWidth(6)),
              Text(
                option['name'],
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(13),
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,
        title: Text(
          productController.isEdit.value
              ? 'जिन्सी समान अपडेट'
              : 'जिन्सी समान थप्नुहोस्',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            // Decorative header curve
            Container(
              height: getProportionateScreenWidth(30),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(getProportionateScreenWidth(30)),
                  bottomRight: Radius.circular(getProportionateScreenWidth(30)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(getProportionateScreenWidth(16)),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Product Name Card
                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionLabel(
                              'जिन्सी समानको नाम', Icons.inventory_2),
                          SizedBox(height: getProportionateScreenWidth(10)),
                          InputTextField(
                            textEditingController: _productNameController,
                            title: 'जिन्सी समानको नाम प्रविष्ट गर्नुहोस्',
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return 'कृपया आफ्नो जिन्सी समानको को नाम प्रविष्ट गर्नुहोस्';
                              }
                              if (value.length < 3) {
                                return 'जिन्सी समानको नाम कम्तिमा पनि ३ अक्षरको हुनुपर्छ ';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: getProportionateScreenWidth(16)),

                    // Stock and Unit Row
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: _buildCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionLabel('स्टक', Icons.pie_chart),
                                SizedBox(
                                    height: getProportionateScreenWidth(10)),
                                InputTextField(
                                  textEditingController:
                                      _productStockController,
                                  textInputType: TextInputType.number,
                                  title: 'स्टक मात्रा',
                                  validation: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'स्टक मात्रा आवश्यक छ';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: getProportionateScreenWidth(12)),
                        Expanded(
                          flex: 3,
                          child: _buildCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionLabel('एकाइ', Icons.straighten),
                                SizedBox(
                                    height: getProportionateScreenWidth(10)),
                                FormField<String>(
                                  validator: (value) {
                                    if (_selectedUnit == 0) {
                                      return 'कृपया एकाइ चयन गर्नुहोस्';
                                    }
                                    return null;
                                  },
                                  builder: (FormFieldState<String> state) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildStyledDropdown(
                                          value: _selectedUnit != 0
                                              ? _selectedUnit.toString()
                                              : null,
                                          items: productController.units
                                              .map<DropdownMenuItem<String>>(
                                                  (Unit unit) {
                                            return DropdownMenuItem<String>(
                                              value: unit.id.toString(),
                                              child: Text(
                                                unit.getName(
                                                    Get.locale?.languageCode ??
                                                        'en'),
                                                style: TextStyle(
                                                  color: kCardTitleColor,
                                                  fontSize:
                                                      getProportionateScreenWidth(
                                                          13),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          hint: "एकाइ",
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedUnit =
                                                  int.tryParse(value!)!;
                                            });
                                            state.validate();
                                          },
                                        ),
                                        if (state.hasError)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: getProportionateScreenWidth(
                                                  6),
                                              left: getProportionateScreenWidth(
                                                  12),
                                            ),
                                            child: Text(
                                              state.errorText!,
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        11),
                                              ),
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: getProportionateScreenWidth(16)),

                    // Description Card
                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionLabel(
                              'जिन्सी समानको विवरण', Icons.description),
                          SizedBox(height: getProportionateScreenWidth(10)),
                          InputTextField(
                            textEditingController:
                                _productDescriptionController,
                            title: 'जिन्सी समानको विवरण प्रविष्टि गर्नुहोस्',
                            maxLines: 4,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: getProportionateScreenWidth(16)),

                    // Buy/Sell Options Card
                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionLabel(
                              'खरिद/बिक्री विकल्प', Icons.sync_alt),
                          SizedBox(height: getProportionateScreenWidth(12)),
                          Row(
                            children: [
                              _buildBuyOptionCard(buyOptions[0]),
                              SizedBox(width: getProportionateScreenWidth(10)),
                              _buildBuyOptionCard(buyOptions[1]),
                              SizedBox(width: getProportionateScreenWidth(10)),
                              _buildBuyOptionCard(buyOptions[2]),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: getProportionateScreenWidth(24)),

                    // Submit Button
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            kPrimaryColor,
                            kPrimaryColor.withOpacity(0.8)
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: kPrimaryColor.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          minimumSize: Size(
                            double.infinity,
                            getProportionateScreenWidth(50),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              productController.isEdit.value
                                  ? Icons.update
                                  : Icons.add_circle_outline,
                              size: getProportionateScreenWidth(20),
                            ),
                            SizedBox(width: getProportionateScreenWidth(8)),
                            Text(
                              productController.isEdit.value
                                  ? 'अपडेट गर्नुहोस्'
                                  : 'थप्नुहोस्',
                              style: TextStyle(
                                fontSize: getProportionateScreenWidth(16),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (productController.isEdit.value) {
                              productController.updateProduct(Product(
                                id: selectedProduct.id!,
                                name: _productNameController.text,
                                description: _productDescriptionController.text,
                                stock:
                                    int.tryParse(_productStockController.text),
                                unitId: _selectedUnit,
                                isSellable: _isSellable,
                              ));
                            } else {
                              productController.addProduct(Product(
                                name: _productNameController.text,
                                description: _productDescriptionController.text,
                                stock:
                                    int.tryParse(_productStockController.text),
                                unitId: _selectedUnit,
                                isSellable: _isSellable,
                                createdDate: DateTime.now().toString(),
                              ));
                            }
                          }
                        },
                      ),
                    ),

                    SizedBox(height: getProportionateScreenWidth(20)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
