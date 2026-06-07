import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              HugeIcon(
                icon: HugeIcons.strokeRoundedCheckmarkCircle01,
                size: 120,
                color: kPrimaryColor,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '${AppLocalizations.of(context)!.orderConfirmedTitle} !',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              Text(
                '${AppLocalizations.of(context)!.orderConfirmedMessage} !',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black45),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      minimumSize: Size(getProportionateScreenWidth(20),
                          getProportionateScreenWidth(40))),
                  onPressed: () {
                    customerDashboardController.updateIndex(0);
                    Get.toNamed(AppRoute.customerDashboard);
                  },
                  child: Text(AppLocalizations.of(context)!.continueShopping)),
              Spacer(),
              SafeArea(
                  child: Row(
                children: [
                  Text(
                    '${AppLocalizations.of(context)!.haveAnyQuestions} ',
                    style: TextStyle(color: Colors.black54),
                  ),
                  Text(
                    '${AppLocalizations.of(context)!.connectToUs} !',
                    style: TextStyle(
                        color: kPrimaryColor, fontWeight: FontWeight.w600),
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
