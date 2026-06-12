import 'package:flutter/material.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/helpers/l10n.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(
              userController.isEdit.value
                  ? l10n.updateUserTitle
                  : l10n.addUserTitle,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
                            '${l10n.userFullName} *',
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
                            title: l10n.enterUserFullName,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return l10n.pleaseEnterUserFullName;
                              }
                              if (value.length < 3) {
                                return l10n.pleaseEnterValidUserName;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${l10n.userPhoneNumber} *',
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(13),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          InputTextField(
                            title: l10n.enterUserPhoneNumber,
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
                                  return l10n.pleaseEnterUserPhone;
                                }
                                if (value.length < 10 || value.length > 10) {
                                  return l10n.pleaseEnterValidUserPhone;
                                }
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            l10n.userEmail,
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(13),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          InputTextField(
                            title: l10n.enterUserEmail,
                            textEditingController: _userEmailController,
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.name,
                            prefixIcon: const Icon(Icons.email_outlined),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            l10n.userPassword,
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(13),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          InputTextField(
                              title: l10n.enterUserPassword,
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
                                    return l10n.pleaseEnterUserPassword;
                                  } else if (value.length < 8) {
                                    return l10n.passwordMinLength;
                                  }
                                  return null;
                                } else {
                                  if (value != null &&
                                      value.isNotEmpty &&
                                      value.length < 8) {
                                    return l10n.passwordMinLength;
                                  }
                                }
                              }),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            l10n.userConfirmPassword,
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(13),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          InputTextField(
                              title: l10n.confirmUserPassword,
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
                                  return l10n.confirmPasswordEmpty;
                                } else if (value !=
                                    _userpasswordController.text) {
                                  return l10n.passwordsDoNotMatch;
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
                                ? Text(l10n.update)
                                : Text(l10n.add),
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
