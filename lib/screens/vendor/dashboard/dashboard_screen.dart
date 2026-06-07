import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/controllers/vendor_dashboard_controller.dart';
import 'package:smart_kishan/screens/profile/profile_screen.dart';
import 'package:smart_kishan/screens/sell_product/sell_product_screen.dart';
import 'package:smart_kishan/screens/vendor/dashboard/vendor_home_screen.dart';
import 'package:smart_kishan/screens/vendor/dashboard/widgets/vendor_custom_drawer.dart';
import 'package:smart_kishan/screens/vendor/dashboard/widgets/vendor_footer_menu.dart';
import 'package:smart_kishan/screens/vendor/orders/order_history_screen.dart';

class VendorDashboardScreen extends StatelessWidget {
  const VendorDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VendorDashboardController>(
        builder: (controller) => Scaffold(
              backgroundColor: Colors.white,
              drawer: VendorCustomDrawer(bodyController: controller),
              body: IndexedStack(
                index: controller.tabIndex,
                children: [
                  VendorHomeScreen(
                    vendorDashboardController: controller,
                  ),
                  SellProductScreen(),
                  OrderHistoryScreen(),
                  ProfileScreen(),
                ],
              ),
              bottomNavigationBar:
                  VendorFooterMenu(dashboardController: controller),
            ));
  }
}
