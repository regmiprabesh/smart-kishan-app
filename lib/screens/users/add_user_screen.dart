import 'package:flutter/material.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/models/user.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/widgets/input_text_field.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _userPhoneController = TextEditingController();
  final _userpasswordController = TextEditingController();
  final _userConfirmPasswordController = TextEditingController();
  User selectedUser = User();

  @override
  void initState() {
    if (userController.isEdit.value) {
      setState(() {
        selectedUser = userController.selectedUser.value;
        _userNameController.text = selectedUser.name!;
        _userEmailController.text = selectedUser.email!.contains('@ourapp.com')
            ? ''
            : selectedUser.email!;
        _userPhoneController.text = selectedUser.phone!;
      });
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: const Color.fromARGB(255, 171, 243, 189),
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(
              userController.isEdit.value
                  ? 'प्रयोगकर्ता अपडेट गर्नुहोस्'
                  : 'प्रयोगकर्ता थप्नुहोस्',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'प्रयोगकर्ताको पूरा नाम *',
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(13),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          InputTextField(
                            prefixIcon: const Icon(Icons.contact_mail),
                            textEditingController: _userNameController,
                            title: 'प्रयोगकर्ताको पूरा नाम प्रविष्टि गर्नुहोस्',
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return 'कृपया प्रयोगकर्ताको पूरा नाम प्रविष्टि गर्नुहोस्';
                              }
                              if (value.length < 3) {
                                return "कृपया प्रयोगकर्ताको मान्य नाम प्रविष्ट गर्नुहोस्";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'प्रयोगकर्ताको फोन नम्बर *',
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(13),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          InputTextField(
                            title:
                                'प्रयोगकर्ताको फोन नम्बर प्रविष्टि गर्नुहोस्',
                            textEditingController: _userPhoneController,
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.phone,
                            enable: !userController.isEdit.value,
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
                                      style: TextStyle(
                                          fontSize: 14, color: kCardTitleColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            validation: (value) {
                              if (!userController.isEdit.value) {
                                if (value == null || value.isEmpty) {
                                  return 'कृपया प्रयोगकर्ताको फोन नम्बर प्रविष्टि गर्नुहोस्';
                                }
                                if (value.length < 10 || value.length > 10) {
                                  return 'कृपया प्रयोगकर्ताको मान्य फोन नम्बर प्रविष्टि गर्नुहोस्';
                                }
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'प्रयोगकर्ताको ई - मेल ठेगाना',
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(13),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          InputTextField(
                            title:
                                'प्रयोगकर्ताको ई - मेल ठेगाना प्रविष्टि गर्नुहोस्',
                            textEditingController: _userEmailController,
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.name,
                            prefixIcon: const Icon(Icons.email_outlined),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'प्रयोगकर्ताको पासवर्ड',
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(13),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          InputTextField(
                              title:
                                  'प्रयोगकर्ताको पासवर्ड प्रविष्टि गर्नुहोस्',
                              textEditingController: _userpasswordController,
                              textInputAction: TextInputAction.done,
                              textInputType: TextInputType.text,
                              obsecureText: true,
                              prefixIcon: const Icon(
                                Icons.lock,
                                size: 20,
                              ),
                              validation: (value) {
                                if (!userController.isEdit.value) {
                                  if (value == null || value.isEmpty) {
                                    return "कृपया प्रयोगकर्ताको पासवर्ड प्रविष्ट गर्नुहोस्";
                                  } else if (value.length < 8) {
                                    return "पासवर्ड कम्तिमा ८ वर्ण लामो हुनुपर्छ";
                                  }
                                  return null;
                                } else {
                                  if (value != null &&
                                      value.isNotEmpty &&
                                      value.length < 8) {
                                    return "पासवर्ड कम्तिमा ८ वर्ण लामो हुनुपर्छ";
                                  }
                                }
                              }),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'प्रयोगकर्ताको पुन पासवर्ड',
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(13),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          InputTextField(
                              title: 'प्रयोगकर्ताको पासवर्ड सुनिश्चित गर्नुहोस',
                              textEditingController:
                                  _userConfirmPasswordController,
                              textInputAction: TextInputAction.done,
                              textInputType: TextInputType.text,
                              obsecureText: true,
                              prefixIcon: const Icon(
                                Icons.lock,
                                size: 20,
                              ),
                              validation: (value) {
                                if (!userController.isEdit.value &&
                                    (value == null || value.isEmpty)) {
                                  return "पुन पासवर्ड फिल्ड खाली हुन सक्दैन";
                                } else if (value !=
                                    _userpasswordController.text) {
                                  return "पासवर्ड मेल खाएन";
                                }
                                return null;
                              }),
                          SizedBox(
                            height: getProportionateScreenWidth(20),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                minimumSize: Size(double.infinity,
                                    getProportionateScreenWidth(40))),
                            child: userController.isEdit.value
                                ? const Text('अपडेट गर्नुहोस्')
                                : const Text('थप्नुहोस्'),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                User user = User(
                                    id: userController.selectedUser.value.id,
                                    name: _userNameController.text,
                                    email: _userEmailController.text,
                                    password: _userpasswordController.text);
                                if (userController.isEdit.value) {
                                  user.phone = _userPhoneController.text;
                                  userController.updateUser(user);
                                  return;
                                }
                                user.phone = '+977${_userPhoneController.text}';
                                userController.addUser(user);
                              }
                            },
                          ),
                        ])))));
  }
}
