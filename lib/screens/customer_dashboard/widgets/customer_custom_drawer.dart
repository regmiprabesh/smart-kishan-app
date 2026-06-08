import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/controllers/customer_dashboard_controller.dart';
import 'package:smart_kishan/helpers/app_mode.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';
import 'package:smart_kishan/widgets/app_drawer.dart';

class CustomerCustomDrawer extends StatelessWidget {
  const CustomerCustomDrawer({super.key, required this.bodyController});
  final CustomerDashboardController bodyController;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return AppDrawer(items: [
      AppDrawerItem(
          icon: HugeIcons.strokeRoundedProductLoading,
          title: l.sellerMode,
          onTap: () {
            Navigator.pop(context);
            authController.switchMode(AppMode.seller);
          }),
      AppDrawerItem(
          icon: HugeIcons.strokeRoundedPlant01,
          title: l.farmerMode,
          onTap: () {
            Navigator.pop(context);
            authController.switchMode(AppMode.farmer);
          }),
      AppDrawerItem(
          icon: HugeIcons.strokeRoundedLocation01,
          title: l.myDeliveryLocations,
          onTap: () {
            Navigator.pop(context);
            Get.toNamed(AppRoute.myDeliveryAddress);
          }),
      AppDrawerItem(
          icon: HugeIcons.strokeRoundedShoppingBagCheck,
          title: l.myCart,
          onTap: () {
            Navigator.pop(context);
            bodyController.updateIndex(2);
          }),
      AppDrawerItem(
          icon: HugeIcons.strokeRoundedShoppingCartCheck01,
          title: l.myProductOrders,
          onTap: () {
            Navigator.pop(context);
            Get.toNamed(AppRoute.orderHistoryScreen);
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
