import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';
import 'package:smart_kishan/controllers/customer_dashboard_controller.dart';
import 'package:smart_kishan/routes/app_routes.dart';

class CustomerCustomDrawer extends StatefulWidget {
  const CustomerCustomDrawer({super.key, required this.bodyController});
  final CustomerDashboardController bodyController;
  @override
  State<CustomerCustomDrawer> createState() => _CustomerCustomDrawerState();
}

class _CustomerCustomDrawerState extends State<CustomerCustomDrawer> {
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
                    AppLocalizations.of(context)!.sellerMode, () {
                  Navigator.pop(context);
                  Get.offAllNamed(AppRoute.vendorDashboard);
                }),
                _buildDrawerItem(HugeIcons.strokeRoundedPlant01,
                    AppLocalizations.of(context)!.farmerMode, () {
                  Navigator.pop(context);
                  Get.offAllNamed(AppRoute.dashboard);
                }),
                _buildDrawerItem(HugeIcons.strokeRoundedLocation01,
                    AppLocalizations.of(context)!.myDeliveryLocations, () {
                  Navigator.pop(context);
                  Get.toNamed(AppRoute.myDeliveryAddress);
                }),
                _buildDrawerItem(HugeIcons.strokeRoundedShoppingBagCheck,
                    AppLocalizations.of(context)!.myCart, () {
                  Navigator.pop(context);
                  widget.bodyController.updateIndex(2);
                }),
                _buildDrawerItem(HugeIcons.strokeRoundedShoppingCartCheck01,
                    AppLocalizations.of(context)!.myProductOrders, () {
                  Navigator.pop(context);
                  Get.toNamed(AppRoute.orderHistoryScreen);
                }),
                _buildDrawerItem(HugeIcons.strokeRoundedLogout03,
                    AppLocalizations.of(context)!.logout, () {
                  Navigator.pop(context);
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
