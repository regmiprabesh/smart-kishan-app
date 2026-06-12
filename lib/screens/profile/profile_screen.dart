import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/helpers/l10n.dart';
import 'package:smart_kishan/languages/langauge_constants.dart';
import 'package:smart_kishan/languages/language.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/screens/farmland/widgets/camera_picker.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';
import 'package:smart_kishan/main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _selectedLanguageCode;
  List<Language>? _languages;
  bool _isUploadingImage = false;

  void _loadSelectedLanguage() async {
    Locale locale = await getLocale();
    setState(() {
      _languages = Language.languageList();
      _selectedLanguageCode = locale.languageCode;
    });
  }

  void _changeLanguage(Language language) async {
    setState(() {
      _selectedLanguageCode = language.languageCode;
    });
    MyApp.setLocale(Locale(_selectedLanguageCode!));
    await setLocale(language.languageCode);
  }

  void _handleImagePick() {
    CameraPicker.showPicker(
      context,
      onPicked: (String imagePath) async {
        setState(() {
          _isUploadingImage = true;
        });

        try {
          final result = await authController.uploadProfileImage(imagePath);
          if (result) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: kSuccessColor,
                content: Text(
                  'Profile image updated successfully',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: kErrorColor,
                content: Text(
                  'Failed to update profile image',
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
                'Error uploading image',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
          );
        } finally {
          setState(() {
            _isUploadingImage = false;
          });
        }
      },
    );
  }

  @override
  void initState() {
    _loadSelectedLanguage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final t = translation(context);
    final user = authController.user.value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
        title: Text(AppLocalizations.of(context)!.profile,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
      body: CustomScrollView(
        slivers: [
          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 20),
                // Profile Card
                Column(
                  children: [
                    // Avatar with border and camera button
                    Obx(() {
                      final user = authController.user.value;
                      return Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage: user?.image != null
                                    ? NetworkImage('$imgUrl${user!.image}')
                                    : AssetImage(
                                            "assets/images/profileimage.png")
                                        as ImageProvider,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap:
                                  _isUploadingImage ? null : _handleImagePick,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: _isUploadingImage
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : const Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                    SizedBox(height: 16),

                    // Name
                    Text(
                      user != null ? user.name! : 'Bikash Lamichane',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),
                    SizedBox(height: 8),

                    // Phone
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.phone, size: 16, color: Colors.green[700]),
                          SizedBox(width: 6),
                          Text(
                            localizedNumber(
                                user != null ? user.phone! : '+9779843XXXXXX'),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),

                    // Profile Details Card
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Card(
                        elevation: 4,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            // Location Section
                            _buildLocationSection(context, user),

                            // Full width divider
                            Divider(height: 1, thickness: 1),

                            // Language Section
                            _buildLanguageSection(context),

                            // Full width divider
                            Divider(height: 1, thickness: 1),

                            // Settings Options
                            _buildMenuOption(
                              icon: CupertinoIcons.person_circle,
                              title: t.editProfile ?? 'Edit Profile',
                              onTap: () async {
                                final result = await Get.toNamed(
                                    AppRoute.editProfileScreen);

                                // Refresh the screen if update was successful
                                if (result == true) {
                                  setState(() {
                                    // This will trigger a rebuild with updated user data
                                  });
                                }
                              },
                            ),

                            _buildMenuOption(
                              icon: CupertinoIcons.location_solid,
                              title: t.updateLocation ?? 'Update Location',
                              onTap: () async {
                                final result = await Get.toNamed(
                                    AppRoute.updateLocationScreen);
                                if (result == true) {
                                  setState(() {
                                    // Triggers rebuild to show updated location data
                                  });
                                }
                              },
                            ),

                            _buildMenuOption(
                              icon: CupertinoIcons.lock_circle,
                              title: t.changePassword ?? 'Change Password',
                              onTap: () {
                                Get.toNamed(AppRoute.updatePasswordScreen);
                              },
                            ),

                            // _buildMenuOption(
                            //   icon: CupertinoIcons.info_circle,
                            //   title: t.aboutUs ?? 'About Us',
                            //   showDivider: false,
                            //   onTap: () {
                            //     Get.toNamed(AppRoute.ab
                            // outScreen);
                            //   },
                            //   isLast: true,
                            // ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Logout Button with modern design
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.red[400]!, Colors.red[600]!],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.3),
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              _showLogoutDialog(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.logout_rounded,
                                      color: Colors.white, size: 24),
                                  SizedBox(width: 12),
                                  Text(
                                    t.logout,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 30),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection(BuildContext context, dynamic user) {
    final t = translation(context);
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green[100]!),
                ),
                child: Icon(
                  Icons.location_on_rounded,
                  color: Colors.green[600],
                  size: 22,
                ),
              ),
              SizedBox(width: 16),
              Text(
                t.location ?? 'Location',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.place_outlined, color: Colors.grey[600], size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    user?.fullAddress ?? t.locationNotSet ?? 'Location not set',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSection(BuildContext context) {
    final t = translation(context);
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue[100]!),
            ),
            child: Icon(
              Icons.language_rounded,
              color: Colors.blue[600],
              size: 22,
            ),
          ),
          SizedBox(width: 16),
          Text(
            t.language ?? 'Language',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
          Spacer(),
          if (_languages != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: DropdownButton<Language>(
                value: _languages!.firstWhere(
                  (lang) => lang.languageCode == _selectedLanguageCode,
                  orElse: () => Language.languageList()[0],
                ),
                onChanged: (Language? language) {
                  if (language != null) {
                    _changeLanguage(language);
                  }
                },
                isDense: true,
                icon: Icon(Icons.arrow_drop_down,
                    color: Colors.grey[700], size: 20),
                items: _languages!.map<DropdownMenuItem<Language>>((lang) {
                  return DropdownMenuItem<Language>(
                    value: lang,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(lang.flag, style: TextStyle(fontSize: 16)),
                        SizedBox(width: 4),
                        Text(
                          lang.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showDivider = true,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: isFirst ? Radius.circular(20) : Radius.zero,
            topRight: isFirst ? Radius.circular(20) : Radius.zero,
            bottomLeft: isLast ? Radius.circular(20) : Radius.zero,
            bottomRight: isLast ? Radius.circular(20) : Radius.zero,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: Colors.grey[200]!, width: 1.5),
                      ),
                      child: Icon(icon, color: Colors.grey[700], size: 22),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: EdgeInsets.only(left: 66),
            child: Divider(height: 1, thickness: 1),
          ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final t = translation(context);

    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red[50]!, Colors.red[100]!],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: Colors.red[600],
                  size: 48,
                ),
              ),
              SizedBox(height: 24),
              Text(
                t.confirmLogout ?? 'Confirm Logout',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                t.logoutMessage ?? 'Are you sure you want to logout?',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        t.cancel,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        authController.logout();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.red[600],
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        t.logout,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
