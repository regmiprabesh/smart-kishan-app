import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/customer_dashboard_controller.dart';
import 'package:smart_kishan/screens/customer_dashboard/customer_cart_screen.dart';
import 'package:smart_kishan/screens/customer_dashboard/customer_home_screen.dart';
import 'package:smart_kishan/screens/customer_dashboard/customer_product_list_screen.dart';
import 'package:smart_kishan/screens/customer_dashboard/widgets/customer_custom_drawer.dart';
import 'package:smart_kishan/screens/customer_dashboard/widgets/customer_footer_menu.dart';
import 'package:smart_kishan/screens/profile/profile_screen.dart';

class CustomerDashboardScreen extends StatelessWidget {
  const CustomerDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomerDashboardController>(
        builder: (controller) => Scaffold(
              backgroundColor: Colors.white,
              drawer: CustomerCustomDrawer(bodyController: controller),
              body: IndexedStack(
                index: controller.tabIndex,
                children: [
                  CustomerHomeScreen(
                    dashboardController: controller,
                  ),
                  CustomerProductListScreen(),
                  CustomerCartScreen(
                    dashboardController: controller,
                  ),
                  ProfileScreen(),
                ],
              ),
              bottomNavigationBar:
                  CustomerFooterMenu(dashboardController: controller),
            ));
  }
}
