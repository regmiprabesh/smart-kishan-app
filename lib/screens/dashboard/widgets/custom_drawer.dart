import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';
import 'package:smart_kishan/routes/app_routes.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        children: [
          // User Account Section
          UserAccountsDrawerHeader(
            accountName: Text(
              authController.user.value != null
                  ? authController.user.value!.name!
                  : '',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              authController.user.value != null
                  ? authController.user.value!.phone!
                  : '',
            ), // Replace with user's email/phone
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage(
                "assets/images/profileimage.png", // Replace with profile image URL
              ),
              backgroundColor: Colors.grey[200],
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor, // Use theme primary color
            ),
          ),
          // List of Actions
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero, // Remove extra padding
              children: [
                _buildDrawerItem(HugeIcons.strokeRoundedProductLoading,
                    AppLocalizations.of(context)!.buyerMode, () {
                  Get.offAllNamed(AppRoute.customerDashboard);
                }),
                _buildDrawerItem(HugeIcons.strokeRoundedShopSign,
                    AppLocalizations.of(context)!.sellerMode, () {
                  Get.offAllNamed(AppRoute.vendorDashboard);
                }),
                _buildDrawerItem(HugeIcons.strokeRoundedPropertyView,
                    AppLocalizations.of(context)!.inventory, () {
                  Get.toNamed(AppRoute.productsScreen);
                }),
                _buildDrawerItem(HugeIcons.strokeRoundedTaskDaily01,
                    AppLocalizations.of(context)!.dailyActivity, () {
                  Get.toNamed(AppRoute.dailyActivityScreen);
                }),
                _buildDrawerItem(HugeIcons.strokeRoundedPlant04,
                    AppLocalizations.of(context)!.farmlands, () {
                  Get.toNamed(AppRoute.farmlandScreen);
                }),
                // _buildDrawerItem(Icons.person, "Profile", () {
                //   // Add Profile navigation logic
                // }),
                // _buildDrawerItem(Icons.settings, "Settings", () {
                //   // Add Settings navigation logic
                // }),
                _buildDrawerItem(HugeIcons.strokeRoundedPlant04, 'Subsidies',
                    () {
                  Get.toNamed(AppRoute.subsidyScreen);
                }),
                _buildDrawerItem(HugeIcons.strokeRoundedLogout03,
                    AppLocalizations.of(context)!.logout, () {
                  authController.logout();
                }),
              ],
            ),
          ),
          // Logout Button at Bottom
          // Padding(
          //   padding:
          //       const EdgeInsets.only(bottom: 16.0), // Add spacing at bottom
          //   child: ListTile(
          //     leading: const Icon(HugeIcons.strokeRoundedLogout01,
          //         color: Colors.red),
          //     title: const Text(
          //       "Logout",
          //       style: TextStyle(color: Colors.red),
          //     ),
          //     onTap: () {
          //       // Add logout logic
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  // Helper method to create drawer items
  Widget _buildDrawerItem(
      List<List<dynamic>> icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: HugeIcon(
        icon: icon,
        color: kCardDescColor,
      ),
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: kCardTitleColor,
            fontFamily: 'Poppins'),
      ),
      onTap: onTap,
    );
  }
}
