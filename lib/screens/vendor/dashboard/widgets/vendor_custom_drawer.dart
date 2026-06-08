import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/controllers/vendor_dashboard_controller.dart';
import 'package:smart_kishan/helpers/app_mode.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';
import 'package:smart_kishan/widgets/app_drawer.dart';

class VendorCustomDrawer extends StatelessWidget {
  const VendorCustomDrawer({super.key, required this.bodyController});
  final VendorDashboardController bodyController;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return AppDrawer(items: [
      AppDrawerItem(
          icon: HugeIcons.strokeRoundedProductLoading,
          title: l.buyerMode,
          onTap: () {
            Navigator.pop(context);
            authController.switchMode(AppMode.buyer);
          }),
      AppDrawerItem(
          icon: HugeIcons.strokeRoundedPlant01,
          title: l.farmerMode,
          onTap: () {
            Navigator.pop(context);
            authController.switchMode(AppMode.farmer);
          }),
      AppDrawerItem(
          icon: HugeIcons.strokeRoundedUserGroup,
          title: l.buyersGroups,
          onTap: () {
            Navigator.pop(context);
            Get.toNamed(AppRoute.buyersGroup);
          }),
      AppDrawerItem(
          icon: HugeIcons.strokeRoundedProductLoading,
          title: l.sellProduct,
          onTap: () {
            Navigator.pop(context);
            bodyController.updateIndex(1);
          }),
      AppDrawerItem(
          icon: HugeIcons.strokeRoundedShoppingBagAdd,
          title: l.myOrders,
          onTap: () {
            Navigator.pop(context);
            bodyController.updateIndex(2);
          }),
      AppDrawerItem(
          icon: HugeIcons.strokeRoundedLogout03,
          title: l.logout,
          onTap: () {
            Navigator.pop(context);
            authController.logout();
          }),
    ]);
  }
}
