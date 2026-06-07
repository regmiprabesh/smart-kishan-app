import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/controllers/dashboard_controller.dart';
import 'package:smart_kishan/screens/dashboard/widgets/footer_nav_bar.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class FooterMenu extends StatelessWidget {
  const FooterMenu({super.key, required this.dashboardController});
  final DashboardController dashboardController;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: kCardDescColor,
              blurRadius: 5,
            ),
          ],
        ),
        child: FooterNavBar(
          selectedColor: kPrimaryColor,
          unSelectedColor: Colors.black54,
          backgroundColor: Colors.white,
          currentIndex: dashboardController.tabIndex,
          unselectedIconSize: getProportionateScreenWidth(20),
          selectedIconSize: getProportionateScreenWidth(20),
          selectedFontSize: getProportionateScreenWidth(10),
          unselectedFontSize: getProportionateScreenWidth(10),
          onTap: (index) {
            dashboardController.updateIndex(index);
          },
          enableLineIndicator: true,
          lineIndicatorWidth: 2,
          indicatorType: IndicatorType.Top,
          // gradient: LinearGradient(
          //   colors: [Colors.pink, Colors.yellow],
          // ),
          customBottomBarItems: [
            FooterBottomBarItems(
              label: AppLocalizations.of(context)!.home,
              icon: CupertinoIcons.home,
            ),
            FooterBottomBarItems(
                label: AppLocalizations.of(context)!.chart,
                icon: CupertinoIcons.graph_square),
            authController.user.value != null &&
                        authController.user.value!.parentId == 0 ||
                    authController.user.value!.parentId == null
                ? FooterBottomBarItems(
                    label: AppLocalizations.of(context)!.users,
                    icon: CupertinoIcons.person_2)
                : null,
            FooterBottomBarItems(
                label: AppLocalizations.of(context)!.profile,
                icon: CupertinoIcons.profile_circled),
          ],
        ));
  }
}
