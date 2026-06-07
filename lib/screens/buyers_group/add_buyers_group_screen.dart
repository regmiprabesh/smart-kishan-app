import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_kishan/color_config.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/models/buyersgroup.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/widgets/input_text_field.dart';

class AddBuyersGroupScreen extends StatefulWidget {
  const AddBuyersGroupScreen({super.key});

  @override
  State<AddBuyersGroupScreen> createState() => _AddBuyersGroupScreenState();
}

class _AddBuyersGroupScreenState extends State<AddBuyersGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneFormKey = GlobalKey<FormState>();

  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  List<Buyers> _addedBuyers = [];
  BuyersGroup selectedBuyersGroup = BuyersGroup();

  Future<Buyers?> validateUser(String phoneNumber) async {
    Buyers? buyer = await buyersGroupController.validateBuyer(phoneNumber);
    if (buyer != null) return buyer;
  }

  void _addBuyer() async {
    final phoneNumber = _phoneNumberController.text.trim();

    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
              backgroundColor: kErrorColor,
              content: Text('कृपया फोन नम्बर प्रविष्ट गर्नुहोस्')),
        );
      return;
    }

    if (phoneNumber.length != 10 || !RegExp(r'^\d+$').hasMatch(phoneNumber)) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
              backgroundColor: kErrorColor,
              content: Text('कृपया मान्य फोन नम्बर प्रविष्ट गर्नुहोस्')),
        );
      return;
    }

    // Check if the buyer is already added
    bool alreadyAdded =
        _addedBuyers.any((buyer) => buyer.phone == '+977$phoneNumber');
    if (alreadyAdded) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            backgroundColor: kErrorColor,
            content: Text('यो फोन नम्बरको खरिदकर्ता पहिले नै थपिएको छ!'),
          ),
        );
      return;
    }

    // Validate the buyer using API
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('प्रमाणीकरण हुँदैछ...')),
      );
    final Buyers? buyer = await validateUser(phoneNumber);
    bool isValid = false;
    if (buyer != null) {
      isValid = true;
    }
    if (isValid) {
      setState(() {
        _addedBuyers.add(buyer!);
        _phoneNumberController.clear();
      });
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
              backgroundColor: kSuccessColor,
              content: Text('खरिदकर्ता सफलतापूर्वक थपियो')),
        );
    } else {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
              backgroundColor: kErrorColor,
              content: Text('फोन नम्बर मिलेन! फेरि प्रयास गर्नुहोस')),
        );
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (buyersGroupController.isEdit.value) {
        bool? success = await buyersGroupController.updateBuyersGroup(
          BuyersGroup(
              id: buyersGroupController.selectedBuyersGroup.value.id,
              name: _groupNameController.text,
              buyers: _addedBuyers),
        );
        if (success != null && success) {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                backgroundColor: kSuccessColor,
                content: Text('समूह सफलतापूर्वक अपडेट गरियो!'),
              ),
            );
        } else {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                backgroundColor: kErrorColor,
                content:
                    Text('समूह अपडेट असफल भयो! कृपया फेरि प्रयास गर्नुहोस्।'),
              ),
            );
        }
      } else {
        bool success = await buyersGroupController.addBuyersGroup(
            BuyersGroup(name: _groupNameController.text, buyers: _addedBuyers),
            false);
        if (success) {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                backgroundColor: kSuccessColor,
                content: Text('समूह सफलतापूर्वक थपियो!'),
              ),
            );
        } else {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                backgroundColor: kErrorColor,
                content: Text('समूह थप्न असफल! कृपया फेरि प्रयास गर्नुहोस्।'),
              ),
            );
        }
      }
    }
  }

  @override
  void initState() {
    if (buyersGroupController.isEdit.value) {
      setState(() {
        selectedBuyersGroup = buyersGroupController.selectedBuyersGroup.value;
      });
      _groupNameController.text = selectedBuyersGroup.name!;
      if (buyersGroupController.selectedBuyersGroup.value.buyers != null) {
        setState(() {
          _addedBuyers =
              buyersGroupController.selectedBuyersGroup.value.buyers!;
        });
      }
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(buyersGroupController.isEdit.value
            ? 'खरिदकर्ताहरूको समूह अपडेट गर्नुहोस्'
            : 'खरिदकर्ताहरूको समूह थप्नुहोस्'),
        backgroundColor: kPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Group Name Field
                Text(
                  'समूहको नाम',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(13),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                InputTextField(
                  textEditingController: _groupNameController,
                  title: 'समूहको नाम प्रविष्टि गर्नुहोस्',
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return 'कृपया आफ्नो समूहको नाम प्रविष्टि गर्नुहोस्';
                    }
                    if (value.length < 3) {
                      return "समूहको नाम कम्तिमा पनि ३ अक्षरको हुनुपर्छ";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                // Add Buyer by Phone Number
                Text(
                  'खरिदकर्ताको फोन नम्बर',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(13),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                InputTextField(
                  title: 'प्रयोगकर्ताको फोन नम्बर प्रविष्टि गर्नुहोस्',
                  textEditingController: _phoneNumberController,
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.phone,
                  // enable: !userController.isEdit.value,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(
                        top: 15,
                        bottom: defaultPadding,
                        left: defaultPadding,
                        right: 10),
                    child: RichText(
                      text: const TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: '(+977) |',
                            style:
                                TextStyle(fontSize: 14, color: kCardTitleColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // validation: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'कृपया प्रयोगकर्ताको फोन नम्बर प्रविष्टि गर्नुहोस्';
                  //   }
                  //   if (value.length < 10 || value.length > 10) {
                  //     return 'कृपया प्रयोगकर्ताको मान्य फोन नम्बर प्रविष्टि गर्नुहोस्';
                  //   }
                  //   return null;
                  // },
                ),
                SizedBox(height: 10),

                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        minimumSize: Size(
                            double.infinity, getProportionateScreenWidth(40))),
                    onPressed: _addBuyer,
                    child: const Text('खरिदकर्ता थप्नुहोस्')),

                SizedBox(height: 20),

                // Display Added Buyers
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'खरिदकर्ताहरू:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    _addedBuyers.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _addedBuyers.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                contentPadding:
                                    EdgeInsets.only(left: 0.0, right: 0.0),
                                leading: _addedBuyers[index].image != null &&
                                        _addedBuyers[index].image!.isNotEmpty
                                    ? CircleAvatar(
                                        radius: 20, // Size of the avatar
                                        backgroundImage: NetworkImage(
                                            _addedBuyers[index].image!),
                                      )
                                    : CircleAvatar(
                                        radius: 20,
                                        backgroundColor: getRandomColor(),
                                        child: Text(
                                          _addedBuyers[index]
                                              .name!
                                              .substring(0, 1)
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                title: Text(_addedBuyers[index].name!),
                                subtitle: Text(_addedBuyers[index].phone!),
                                trailing: IconButton.outlined(
                                  color: Colors.red,
                                  style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: Colors.red)),
                                  icon: Icon(CupertinoIcons.delete),
                                  onPressed: () {
                                    setState(() {
                                      _addedBuyers.removeAt(index);
                                    });
                                  },
                                ),
                              );
                            },
                          )
                        : Text(
                            'तपाईंले अहिलेसम्म कुनै पनि खरिदकर्ता थप्नुभएको छैन ।')
                  ],
                ),
                SizedBox(height: 20),

                // Submit Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      minimumSize: Size(
                          double.infinity, getProportionateScreenWidth(40))),
                  onPressed: _submitForm,
                  child: buyersGroupController.isEdit.value
                      ? const Text('अपडेट गर्नुहोस्')
                      : const Text('थप्नुहोस्'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
