import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/models/deliveryAddress.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/widgets/input_text_field.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({Key? key}) : super(key: key);

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool isDefault = false;

  @override
  void initState() {
    if (deliveryAddressController.isEdit.value) {
      DeliveryAddress? address =
          deliveryAddressController.selectedDeliveryAddress.value;
      _titleController.text = address!.addressTitle;
      _cityController.text = address.city;
      _addressController.text = address.description.toString();
      _phoneController.text = address.phone.toString();
      isDefault = address.isDefault;
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          deliveryAddressController.isEdit.value
              ? AppLocalizations.of(context)!.updateAddress
              : AppLocalizations.of(context)!.addNewAddress,
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            deliveryAddressController.isEdit(false);
            deliveryAddressController.selectedDeliveryAddress(null);
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.addressTitle,
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(13),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  InputTextField(
                    textEditingController: _titleController,
                    prefixIcon:
                        const HugeIcon(icon: HugeIcons.strokeRoundedLocation01),
                    title: AppLocalizations.of(context)!.addressTitle,
                    validation: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter address title";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  Text(
                    AppLocalizations.of(context)!.city,
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(13),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  InputTextField(
                    textEditingController: _cityController,
                    prefixIcon:
                        const HugeIcon(icon: HugeIcons.strokeRoundedCity01),
                    title: AppLocalizations.of(context)!.city,
                    validation: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter name of your city";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  Text(
                    AppLocalizations.of(context)!.addressDescription,
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(13),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  InputTextField(
                    textEditingController: _addressController,
                    title: AppLocalizations.of(context)!.addressDescription,
                    maxLines: 4,
                    validation: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter address description";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  Text(
                    AppLocalizations.of(context)!.phoneNumber,
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(13),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  InputTextField(
                    textEditingController: _phoneController,
                    title: AppLocalizations.of(context)!.phoneNumber,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(
                          top: 15,
                          bottom: defaultPadding,
                          left: defaultPadding,
                          right: 10),
                      child: Text(
                        '(+${convertToLocalizedNumber(977.toString(), context)}) |',
                        style: TextStyle(fontSize: 14, color: kCardTitleColor),
                      ),
                    ),
                    validation: (value) {
                      if (value == null || value.isEmpty) {
                        return 'कृपया प्रयोगकर्ताको फोन नम्बर प्रविष्टि गर्नुहोस्';
                      }
                      if (value.length < 6 || value.length > 10) {
                        return 'कृपया प्रयोगकर्ताको मान्य फोन नम्बर प्रविष्टि गर्नुहोस्';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isDefault = !isDefault;
                      });
                    },
                    child: Row(
                      children: [
                        Container(
                          height: 28,
                          width: 28,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: isDefault ? Colors.green : Colors.white,
                            border: Border.all(width: 2, color: Colors.green),
                          ),
                          child: isDefault
                              ? const Icon(
                                  Icons.check,
                                  size: 18.0,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 15),
                        Text(
                          AppLocalizations.of(context)!.setAsDefaultAddress,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (deliveryAddressController.isEdit.value) {
                            DeliveryAddress newAddress = DeliveryAddress(
                              id: deliveryAddressController
                                  .selectedDeliveryAddress.value!.id,
                              addressTitle: _titleController.text,
                              city: _cityController.text,
                              phone: _phoneController.text,
                              description: _addressController.text,
                              isDefault: isDefault,
                            );
                            deliveryAddressController
                                .updateDeliveryAddress(newAddress);
                            deliveryAddressController.isEdit(false);
                            deliveryAddressController
                                .selectedDeliveryAddress(null);
                          } else {
                            DeliveryAddress newAddress = DeliveryAddress(
                              addressTitle: _titleController.text,
                              city: _cityController.text,
                              phone: _phoneController.text,
                              description: _addressController.text,
                              isDefault: isDefault,
                            );
                            deliveryAddressController
                                .addDeliveryAddress(newAddress);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: kPrimaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        deliveryAddressController.isEdit.value
                            ? AppLocalizations.of(context)!.updateAddress
                            : AppLocalizations.of(context)!.saveAddress,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
