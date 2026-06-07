import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/auth_controller.dart';
import 'package:smart_kishan/languages/langauge_constants.dart';
import 'package:smart_kishan/size_config.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.find();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: authController.user.value?.name ?? '');
    _emailController =
        TextEditingController(text: authController.user.value?.email ?? '');
    _phoneController =
        TextEditingController(text: authController.user.value?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await authController.updateProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
      );

      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: kSuccessColor,
            content: Text(
              'Profile updated successfully',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        );

        // Use Get.back() with result to trigger refresh
        Get.back(result: true);

        // OR use this to force navigation to profile screen
        // Get.offAllNamed(AppRoute.profileScreen);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: kErrorColor,
            content: Text(
              'Failed to update profile',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: kErrorColor,
          content: Text(
            'An error occurred',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = translation(context);

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          t.editProfile,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(getProportionateScreenWidth(20)),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(20)),

                // White Card Container
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name Field
                      Text(
                        t.fullName,
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(14),
                          fontWeight: FontWeight.w600,
                          color: kTextColor,
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(8)),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: t.enterFullName,
                          prefixIcon: const Icon(Icons.person_outline,
                              color: kPrimaryColor),
                          filled: true,
                          fillColor: kBackgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(15),
                            vertical: getProportionateScreenHeight(15),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return t.pleaseEnterName;
                          }
                          if (value.length < 3) {
                            return t.nameTooShort;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: getProportionateScreenHeight(20)),

                      // Email Field
                      Text(
                        t.email,
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(14),
                          fontWeight: FontWeight.w600,
                          color: kTextColor,
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(8)),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: t.enterEmail,
                          prefixIcon: const Icon(Icons.email_outlined,
                              color: kPrimaryColor),
                          filled: true,
                          fillColor: kBackgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(15),
                            vertical: getProportionateScreenHeight(15),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return t.pleaseEnterEmail;
                          }
                          if (!GetUtils.isEmail(value)) {
                            return t.invalidEmail;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: getProportionateScreenHeight(20)),

                      // Phone Field
                      Text(
                        t.phoneNumber,
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(14),
                          fontWeight: FontWeight.w600,
                          color: kTextColor,
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(8)),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: t.enterPhoneNumber,
                          prefixIcon: const Icon(Icons.phone_outlined,
                              color: kPrimaryColor),
                          filled: true,
                          fillColor: kBackgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(15),
                            vertical: getProportionateScreenHeight(15),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return t.pleaseEnterPhone;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: getProportionateScreenHeight(30)),

                // Update Button
                SizedBox(
                  width: double.infinity,
                  height: getProportionateScreenHeight(50),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            t.updateProfile,
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(16),
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
