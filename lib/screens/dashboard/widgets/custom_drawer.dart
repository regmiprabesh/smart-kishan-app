import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/helpers/app_mode.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';
import 'package:smart_kishan/widgets/app_drawer.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return AppDrawer(items: [
      AppDrawerItem(
          icon: HugeIcons.strokeRoundedProductLoading,
          title: l.buyerMode,
          onTap: () => authController.switchMode(AppMode.buyer)),
      AppDrawerItem(
          icon: HugeIcons.strokeRoundedShopSign,
          title: l.sellerMode,
          onTap: () => authController.switchMode(AppMode.seller)),
      AppDrawerItem(
          icon: HugeIcons.strokeRoundedPropertyView,
          title: l.inventory,
          onTap: () => Get.toNamed(AppRoute.productsScreen)),
      AppDrawerItem(
          icon: HugeIcons.strokeRoundedTaskDaily01,
          title: l.dailyActivity,
          onTap: () => Get.toNamed(AppRoute.dailyActivityScreen)),
      AppDrawerItem(
          icon: HugeIcons.strokeRoundedPlant04,
          title: l.farmlands,
          onTap: () => Get.toNamed(AppRoute.farmlandScreen)),
      AppDrawerItem(
          icon: HugeIcons.strokeRoundedPlant04,
          title: l.subsidies,
          onTap: () => Get.toNamed(AppRoute.subsidyScreen)),
      AppDrawerItem(
          icon: HugeIcons.strokeRoundedLogout03,
          title: l.logout,
          onTap: () => authController.logout()),
    ]);
  }
}
