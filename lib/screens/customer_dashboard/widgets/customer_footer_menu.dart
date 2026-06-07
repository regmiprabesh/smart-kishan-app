import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/controllers/customer_dashboard_controller.dart';
import 'package:smart_kishan/screens/customer_dashboard/widgets/footer_nav_bar.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class CustomerFooterMenu extends StatelessWidget {
  const CustomerFooterMenu({super.key, required this.dashboardController});
  final CustomerDashboardController dashboardController;
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
        child: CustomerFooterNavBar(
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
          customBottomBarItems: [
            FooterBottomBarItems(
              label: AppLocalizations.of(context)!.home,
              icon: HugeIcons.strokeRoundedHome01,
            ),
            FooterBottomBarItems(
              label: AppLocalizations.of(context)!.market,
              icon: HugeIcons.strokeRoundedStore01,
            ),
            FooterBottomBarItems(
              label: AppLocalizations.of(context)!.myCart,
              icon: HugeIcons.strokeRoundedShoppingBagCheck,
            ),
            FooterBottomBarItems(
                label: AppLocalizations.of(context)!.profile,
                icon: HugeIcons.strokeRoundedProfile),
          ],
        ));
  }
}
