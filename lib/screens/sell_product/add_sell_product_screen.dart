import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/models/buyersgroup.dart';
import 'package:smart_kishan/models/deliverylocation.dart';
import 'package:smart_kishan/models/paymentmethod.dart';
import 'package:smart_kishan/models/sellproduct.dart';
import 'package:smart_kishan/models/unit.dart';
import 'package:smart_kishan/screens/marketplace/widgets/multiple_image_picker.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/widgets/custom_dropdown.dart';
import 'package:smart_kishan/widgets/input_text_field.dart';
import 'package:smart_kishan/screens/sell_product/product_success_screen.dart';

class AddSellProductSteps extends StatefulWidget {
  @override
  _AddSellProductStepsState createState() => _AddSellProductStepsState();
}

class _AddSellProductStepsState extends State<AddSellProductSteps> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  int? _selectedCategory;
  String? _selectedUnit;

  final _productNameController = TextEditingController();
  final _productDescriptionController = TextEditingController();
  final _productStockController = TextEditingController();
  final _productPriceController = TextEditingController();
  final _productMinOrderController = TextEditingController();
  final _additionalNotesController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _showUnitError = false;

  List<String> _selectedImages = [];
  List<String> _selectedNetworkImages = [];

  List<BuyersGroup> _selectedBuyersTypes = [];
  List<DeliveryLocation> _selectedDeliveryLocations = [];
  List<PaymentMethod> _selectedPaymentTypes = [];

  bool _showImageError = false;
  bool _showStockError = false;

  SellProduct selectedProduct = SellProduct();

  @override
  void dispose() {
    _productNameController.dispose();
    _productDescriptionController.dispose();
    _productStockController.dispose();
    _productPriceController.dispose();
    _productMinOrderController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }

  void _goToNextStep() async {
    FocusScope.of(context).unfocus(); // Dismiss the keyboard

    // First check for unit and image errors
    if (_selectedUnit == null && _currentStep == 1) {
      setState(() {
        _showUnitError = true;
      });
    } else {
      setState(() {
        _showUnitError = false;
      });
    }

    if (_selectedImages.isEmpty &&
        _selectedNetworkImages.isEmpty &&
        _currentStep == 1) {
      setState(() {
        _showImageError = true;
      });
    } else {
      setState(() {
        _showImageError = false;
      });
    }

    // Explicitly trigger stock field validation
    if (_productStockController.text.isEmpty && _currentStep == 1) {
      setState(() {
        _showStockError = true;
      });
    } else {
      setState(() {
        _showStockError = false;
      });
    }

    // Check if all fields are valid
    if (_formKey.currentState!.validate() &&
        !_showUnitError &&
        !_showImageError &&
        !_showStockError) {
      if (_currentStep == 2 && !sellProductController.isEdit.value) {
        bool success = await sellProductController.addSellProduct(
            SellProduct(
              categoryId: _selectedCategory,
              name: _productNameController.text,
              description: _productDescriptionController.text,
              selectedImages: _selectedImages,
              networkImages: _selectedNetworkImages,
              unitId:
                  _selectedUnit != null ? int.tryParse(_selectedUnit!) : null,
              stock: int.parse(_productStockController.text),
              price: _productPriceController.text,
              minOrder: int.parse(_productMinOrderController.text),
              deliveryLocations:
                  transformDeliveryLocations(_selectedDeliveryLocations),
              paymentTypes: _selectedPaymentTypes,
              additionalNotes: _additionalNotesController.text,
              buyersGroups: _selectedBuyersTypes,
            ),
            false);
        if (success) {
          ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
              backgroundColor: kSuccessColor,
              content: Text(
                'उत्पादन सफलतापूर्वक थपिएको छ।',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              )));
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (builder) {
            return ProductSuccessScreen(
              isEdit: false,
            );
          }));
        }

        return;
      } else if (_currentStep == 2 && sellProductController.isEdit.value) {
        bool success = await sellProductController.updateSellProduct(
          SellProduct(
            id: selectedProduct.id,
            categoryId: _selectedCategory,
            name: _productNameController.text,
            description: _productDescriptionController.text,
            selectedImages: _selectedImages,
            networkImages: _selectedNetworkImages,
            unitId: _selectedUnit != null ? int.tryParse(_selectedUnit!) : null,
            stock: int.parse(_productStockController.text),
            price: _productPriceController.text,
            minOrder: int.parse(_productMinOrderController.text),
            deliveryLocations:
                transformDeliveryLocations(_selectedDeliveryLocations),
            paymentTypes: _selectedPaymentTypes,
            additionalNotes: _additionalNotesController.text,
            buyersGroups: _selectedBuyersTypes,
          ),
        );
        if (success) {
          ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
              backgroundColor: kSuccessColor,
              content: Text(
                'उत्पादन सफलतापूर्वक अद्यावधिक गरिएको छ।',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              )));
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (builder) {
            return ProductSuccessScreen(
              isEdit: true,
            );
          }));
        }
        return;
      }

      setState(() {
        _currentStep++;
        _pageController.animateToPage(
          _currentStep,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('कृपया सबै आवश्यक जानकारी प्रविष्ट गर्नुहोस्।'),
        ),
      );
    }
  }

  Future<bool> _showExitConfirmation() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding:
              const EdgeInsets.all(10), // To control padding from the edges
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width *
                    0.8, // 80% of screen width
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 60), // Space for the icon
                    Text(
                      "रद्द गर्नुहोस्",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "के तपाईं यो उत्पादन ${sellProductController.isEdit.value ? 'अपडेट गर्ने' : 'थप्ने'} कार्य रद्द गर्ने निश्चित हुनुहुन्छ?",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            foregroundColor: Colors.black,
                            minimumSize: const Size(100, 40),
                          ),
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("जारी राख्नुहोस"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(100, 40),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text("रद्द गर्नुहोस्"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Positioned(
                top: 0, // Position the icon above the dialog
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedPictureInPictureExit,
                    color: Colors.red,
                    size: 50,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    return result ?? false; // Default to not leaving if the dialog is dismissed
  }

  // Future<void> _saveToDrafts() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final drafts = prefs.getStringList('draftProducts') ?? [];

  //   final productDetails = {
  //     'productName': _productNameController.text,
  //     'productDescription': _productDescriptionController.text,
  //     'productStock': _productStockController.text,
  //     'productPrice': _productPriceController.text,
  //     'productMinOrder': _productMinOrderController.text,
  //     'additionalNotes': _additionalNotesController.text,
  //     'selectedUnit': _selectedUnit,
  //   };

  //   drafts.add(productDetails.toString());
  //   await prefs.setStringList('draftProducts', drafts);

  //   if (context.mounted) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Product saved as draft successfully!')),
  //     );
  //   }
  // }

  void _goToPreviousStep() {
    setState(() {
      _showUnitError = false;
    });
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    if (sellProductController.isEdit.value) {
      setState(() {
        selectedProduct = sellProductController.selectedSellProduct.value;
        _selectedCategory =
            sellProductController.selectedSellProduct.value.categoryId ?? 0;
      });
      _productNameController.text = selectedProduct.name!;
      _productDescriptionController.text = selectedProduct.description ?? '';
      _productPriceController.text = selectedProduct.price.toString();
      _productStockController.text = selectedProduct.stock.toString();
      _productMinOrderController.text = selectedProduct.minOrder.toString();
      setState(() {
        _selectedUnit = selectedProduct.unitId.toString();
        selectedProduct.paymentTypes != null
            ? _selectedPaymentTypes.addAll(selectedProduct.paymentTypes!)
            : null;
        selectedProduct.buyersGroups != null
            ? _selectedBuyersTypes.addAll(selectedProduct.buyersGroups!)
            : null;
      });
      _additionalNotesController.text = selectedProduct.additionalNotes ?? '';
      if (selectedProduct.deliveryLocations != null &&
          sellProductController.deliveryLocations.isNotEmpty) {
        _selectedDeliveryLocations.addAll(getSelectedDeliveryLocations(
            selectedProduct, sellProductController.deliveryLocations));
      }
      if (selectedProduct.imageUrls != null) {
        _selectedNetworkImages.addAll(selectedProduct.imageUrls!);
      }
    }
    if (sellProductController.cropCategories.isNotEmpty &&
        !sellProductController.isEdit.value) {
      setState(() {
        _selectedCategory = sellProductController.cropCategories.first.id;
      });
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await _showExitConfirmation();
        if (shouldPop) {
          Navigator.pop(context);
        }
      },
      child: Stack(children: [
        Scaffold(
            appBar: AppBar(
              title: Text(
                  "${convertToNepaliNumber('3')} मध्ये चरण ${convertToNepaliNumber((_currentStep + 1).toString())}"),
              backgroundColor: kPrimaryColor,
            ),
            body: SafeArea(
              child: Form(
                key: _formKey,
                child: Stack(
                  children: [
                    PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        // Step 1: Add Shop Details
                        _buildShopDetailsStep(),

                        // Step 2: Add Product Details
                        _buildProductDetailsStep(),

                        // Step 3: Product Added Successfully
                        _buildDeliveryDetailsStep(),

                        // Step 4: Product Added Successfully
                        _buildSuccessStep(),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(color: kCanvasColor),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: _currentStep == 0
                            ? ElevatedButton(
                                onPressed: _goToNextStep,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryColor,
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  "अर्को पृष्ठ",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: _goToPreviousStep,
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                            color: kPrimaryColor),
                                        minimumSize: const Size(double.infinity,
                                            50), // Increase button height
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10), // Less rounded corners
                                        ),
                                      ),
                                      child: const Text(
                                        "अघिल्लो पृष्ठ",
                                        style: TextStyle(
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _goToNextStep,
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        backgroundColor: kPrimaryColor,
                                        minimumSize: const Size(double.infinity,
                                            50), // Increase button height
                                      ),
                                      child: Text(
                                        _currentStep == 2
                                            ? sellProductController.isEdit.value
                                                ? 'उत्पादन अपडेट गर्नुहोस्'
                                                : "उत्पादन थप्नुहोस्"
                                            : "अर्को पृष्ठ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
        Obx(
          () => sellProductController.isUpdateSellProductLoading.value ||
                  sellProductController.isAddSellProductLoading.value
              ? Container(
                  color: Colors.black.withOpacity(0.8),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),
                  ),
                )
              : Container(),
        )
      ]),
    );
  }

  Widget _buildShopDetailsStep() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _pageCounter(
                    title: 'उत्पादन विवरण थप्नुहोस्',
                    description: 'यहाँ आफ्नो उत्पादन विवरण प्रविष्ट गर्नुहोस्'),
                const SizedBox(height: 20),
                Obx(
                  () {
                    return Wrap(
                      runSpacing: 10,
                      children: [
                        const Text(
                          "उत्पादन प्रकार चयन गर्नुहोस्",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 7,
                            mainAxisSpacing: 7,
                            childAspectRatio: 1,
                          ),
                          itemCount:
                              sellProductController.cropCategories.length,
                          itemBuilder: (context, index) {
                            final category =
                                sellProductController.cropCategories[index];
                            bool isSelected = category.id == _selectedCategory;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedCategory = category.id!.toInt();
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.orange.shade100
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.orange
                                        : Colors.grey.shade300,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 1.6,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.network(
                                          '$imgUrl${category.image != null ? category.image! : ''}',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      category.name != null
                                          ? category.name!
                                          : '',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected
                                            ? Colors.orange
                                            : Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  "उत्पादनको विवरण",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                const Text(
                  "उत्पादन बांकी विवरण पेश गर्नुहोस्",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 10),
                Text(
                  'उत्पादनको नाम',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(13),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
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
                const SizedBox(height: 10),
                Text(
                  'उत्पादनको विवरण',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(13),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                InputTextField(
                  title: 'उत्पादनको विवरण प्रविष्टि गर्नुहोस्',
                  textEditingController: _productDescriptionController,
                  maxLines: 4,
                ),
                SizedBox(
                  height: 90,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductDetailsStep() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _pageCounter(
                title: 'उत्पादन विवरण थप्नुहोस्',
                description: 'यहाँ आफ्नो उत्पादन विवरण प्रविष्ट गर्नुहोस्'),
            const SizedBox(height: 20),
            const Text(
              "उत्पादन तस्विर चयन गर्नुहोस्",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            MultipleImagePicker(
              networkImages: _selectedNetworkImages,
              selectedImages: _selectedImages,
              onImageSelected: (images) {
                setState(() {
                  _selectedImages = images;
                  _showImageError = false;
                });
              },
            ),
            if (_showImageError)
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 0),
                child: Text(
                  'कृपया कम्तिमा एउटा तस्बिर चयन गर्नुहोस्',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.error, fontSize: 12),
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              "उत्पादनको अन्य विवरण प्रविष्टि गर्नुहोस्",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Text(
              'एकाइ',
              style: TextStyle(
                fontSize: getProportionateScreenWidth(13),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            Obx(
              () => DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  value: _selectedUnit,
                  isExpanded: true,
                  style: const TextStyle(color: Colors.white),
                  items: productController.units
                      .map<DropdownMenuItem<String>>((Unit unit) {
                    return DropdownMenuItem<String>(
                      value: unit.id.toString(),
                      child: Row(
                        children: [
                          Text(
                            unit.getName(Get.locale?.languageCode ?? 'en'),
                            style: const TextStyle(color: kCardTitleColor),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  hint: Text(
                    "एकाइ चयन गर्नुहोस्",
                    style: TextStyle(
                        fontSize: getProportionateScreenWidth(14),
                        fontWeight: FontWeight.w400),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedUnit = value;
                      _showUnitError =
                          false; // Clear error message on selection
                    });
                  },
                  buttonStyleData: ButtonStyleData(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color:
                                _showUnitError ? kErrorColor : kCardDescColor),
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
            if (_showUnitError)
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 10),
                child: Text(
                  'कृपया एकाइ चयन गर्नुहोस्।',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Theme.of(context).colorScheme.error),
                ),
              ),
            const SizedBox(
              height: 10,
            ),
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
                  return 'कृपया उत्पादनको स्टक मात्रा प्रविष्टि गर्नुहोस् ';
                }
                return null;
              },
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
              textEditingController: _productMinOrderController,
              textInputType: TextInputType.number,
              title: 'न्यूनतम अर्डर प्रविष्टि गर्नुहोस्',
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'कृपया उत्पादनको न्यूनतम अर्डर प्रविष्टि गर्नुहोस् ';
                }
                return null;
              },
            ),
            SizedBox(
              height: 90,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryDetailsStep() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _pageCounter(
                title: 'डेलिभरी विवरण थप्नुहोस्',
                description:
                    'यहाँ यस उत्पादनको लागि डेलिभरी विवरण प्रविष्ट गर्नुहोस्'),
            const SizedBox(height: 20),
            const Text(
              "डेलिभरी विवरण प्रविष्ट गर्नुहोस्",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'डेलिभरी हुने स्थान',
              style: TextStyle(
                fontSize: getProportionateScreenWidth(13),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Obx(
              () => sellProductController.deliveryLocations.isNotEmpty
                  ? CustomDropdown<DeliveryLocation>(
                      title: "डेलिभरी हुने स्थान",
                      items: sellProductController.deliveryLocations,
                      itemName: (item) => item.name,
                      itemType: (item) => item.locationType,
                      itemId: (item) => item.locationId.toString(),
                      selectedItems: _selectedDeliveryLocations,
                      onSelectionChanged: (selected) {
                        final selectedIds =
                            selected.map((e) => e.locationId).toList();
                        print(
                            "Selected Payment Methods: ${selected.map((e) => e.name).toList()}");
                        print("Selected Payment IDs: $selectedIds");
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'कृपया डेलिभरी स्थान चयन गर्नुहोस्';
                        }
                        return null;
                      },
                    )
                  : SizedBox(),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'भुक्तानीको प्रकार',
              style: TextStyle(
                fontSize: getProportionateScreenWidth(13),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Obx(
              () => sellProductController.paymentMethods.isNotEmpty
                  ? CustomDropdown<PaymentMethod>(
                      title: "भुक्तानीको प्रकार",
                      items: sellProductController.paymentMethods,
                      selectedItems: _selectedPaymentTypes,
                      itemId: (item) => item.id.toString(),
                      itemName: (item) => item.name,
                      itemImage: (item) => item.image,
                      onSelectionChanged: (selected) {
                        final selectedIds = selected.map((e) => e.id).toList();
                        print(
                            "Selected Payment Methods: ${selected.map((e) => e.name).toList()}");
                        print("Selected Payment IDs: $selectedIds");
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'कृपया भुक्तानीको प्रकार चयन गर्नुहोस्';
                        }
                        return null;
                      },
                    )
                  : SizedBox(),
            ),
            const SizedBox(height: 10),
            Text(
              'अतिरिक्त टिप्पणीहरू (यदि कुनै छ भने)',
              style: TextStyle(
                fontSize: getProportionateScreenWidth(13),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            InputTextField(
              maxLines: 5,
              textEditingController: _additionalNotesController,
              textInputType: TextInputType.number,
              title: 'अतिरिक्त टिप्पणी प्रविष्टि गर्नुहोस् (यदि कुनै छ भने)',
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'खरिदकर्ता',
              style: TextStyle(
                fontSize: getProportionateScreenWidth(13),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Obx(
              () => sellProductController.deliveryLocations.isNotEmpty
                  ? CustomDropdown<BuyersGroup>(
                      title: "खरिदकर्ता",
                      items: buyersGroupController.buyersGroups,
                      selectedItems: _selectedBuyersTypes,
                      itemId: (item) => item.id.toString(),
                      itemName: (item) => item.name!,
                      onSelectionChanged: (selected) {
                        final selectedIds = selected.map((e) => e.id).toList();
                        print(
                            "Selected Payment Methods: ${selected.map((e) => e.name).toList()}");
                        print("Selected Payment IDs: $selectedIds");
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'कृपया खरिदकर्ता चयन गर्नुहोस्';
                        }
                        return null;
                      },
                    )
                  : SizedBox(),
            ),
            SizedBox(
              height: 90,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessStep() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image.asset(
          //   'assets/images/success.png', // Add your success image here
          //   height: 150,
          // ),
          const SizedBox(height: 20),
          const Text(
            "Product added successfully!",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            "Your product is now visible to users.",
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Reset to the first step
              setState(() {
                _currentStep = 0;
                _pageController.jumpToPage(0);
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text("Add another product"),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () {
              // Navigate back or do other actions
              Navigator.pop(context);
            },
            child: const Text("Back to shop"),
          ),
        ],
      ),
    );
  }

  Widget _pageCounter({required String title, required String description}) {
    return Row(
      children: [
        Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            Center(
              child: SizedBox(
                width: 42,
                height: 42,
                child: CircularProgressIndicator(
                  backgroundColor: kPrimaryGrey,
                  valueColor:
                      AlwaysStoppedAnimation(kPrimaryColor.withOpacity(0.5)),
                  strokeWidth: 3,
                  value: (_currentStep + 1) / 3,
                ),
              ),
            ),
            Center(
              child: Text(
                '${convertToNepaliNumber((_currentStep + 1).toString())}/${convertToNepaliNumber('3')}',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            Text(
              description,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        )
      ],
    );
  }
}
