import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';
import 'package:smart_kishan/controllers/vendor_dashboard_controller.dart';
import 'package:smart_kishan/routes/app_routes.dart';

class VendorCustomDrawer extends StatefulWidget {
  const VendorCustomDrawer({super.key, required this.bodyController});
  final VendorDashboardController bodyController;
  @override
  State<VendorCustomDrawer> createState() => _VendorCustomDrawerState();
}

class _VendorCustomDrawerState extends State<VendorCustomDrawer> {
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
                  Navigator.pop(context);
                  Get.offAllNamed(AppRoute.customerDashboard);
                }),
                _buildDrawerItem(HugeIcons.strokeRoundedPlant01,
                    AppLocalizations.of(context)!.farmerMode, () {
                  Navigator.pop(context);
                  Get.offAllNamed(AppRoute.dashboard);
                }),
                _buildDrawerItem(HugeIcons.strokeRoundedUserGroup,
                    AppLocalizations.of(context)!.buyersGroups, () {
                  Navigator.pop(context);
                  Get.toNamed(AppRoute.buyersGroup);
                }),
                _buildDrawerItem(HugeIcons.strokeRoundedProductLoading,
                    AppLocalizations.of(context)!.sellProduct, () {
                  Navigator.pop(context);
                  widget.bodyController.updateIndex(1);
                }),
                _buildDrawerItem(HugeIcons.strokeRoundedShoppingBagAdd,
                    AppLocalizations.of(context)!.myOrders, () {
                  Navigator.pop(context);
                  widget.bodyController.updateIndex(2);
                }),
                _buildDrawerItem(HugeIcons.strokeRoundedLogout03,
                    AppLocalizations.of(context)!.logout, () {
                  Navigator.pop(context);
                  authController.logout();
                }),
              ],
            ),
          ),
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
