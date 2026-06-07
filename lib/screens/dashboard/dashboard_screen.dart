import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/controllers/dashboard_controller.dart';
import 'package:smart_kishan/screens/charts/chart_screen.dart';
import 'package:smart_kishan/screens/dashboard/home_screen.dart';
import 'package:smart_kishan/screens/dashboard/weather_screen.dart';
import 'package:smart_kishan/screens/dashboard/widgets/footer_menu.dart';
import 'package:smart_kishan/screens/marketplace/marketplace_screen.dart';
import 'package:smart_kishan/screens/profile/profile_screen.dart';
import 'package:smart_kishan/screens/users/users_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
        builder: (controller) => Scaffold(
              backgroundColor: kCanvasColor,
              body: IndexedStack(
                index: controller.tabIndex,
                children: [
                  HomeScreen(),
                  ChartScreen(),
                  authController.user.value != null &&
                              authController.user.value!.parentId == 0 ||
                          authController.user.value!.parentId == null
                      ? UsersScreen()
                      : Container(),
                  ProfileScreen(),
                ],
              ),
              bottomNavigationBar: FooterMenu(dashboardController: controller),
            ));
  }
}
