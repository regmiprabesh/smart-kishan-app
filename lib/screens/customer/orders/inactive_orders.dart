import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/enums/orderStatus.dart';
import 'package:smart_kishan/models/order.dart';
import 'package:smart_kishan/screens/customer/orders/widgets/order_group_cart.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class InactiveOrders extends StatefulWidget {
  const InactiveOrders({super.key});

  @override
  State<InactiveOrders> createState() => _InactiveOrdersState();
}

class _InactiveOrdersState extends State<InactiveOrders> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        // Filter orders with inactive statuses
        var inactiveOrders = customerOrdersController.myOrders
            .where((order) => [OrderStatus.cancelled, OrderStatus.delivered]
                .contains(order.status))
            .toList();

        return inactiveOrders.isEmpty
            ? Transform.translate(
                offset: const Offset(0.0, -40.0),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Vertically centers the content
                    children: [
                      Image.asset(
                        'assets/images/empty_orders.png',
                        height: 150,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        AppLocalizations.of(context)!.inactiveOrdersTitle,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: kCardTitleColor,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.inactiveOrdersDescription,
                        style: TextStyle(
                          fontSize: 14,
                          color: kCardDescColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      OutlinedButton(
                        onPressed: () {
                          customerDashboardController.updateIndex(1);
                          Get.back();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: kPrimaryColor),
                          minimumSize:
                              const Size(150, 50), // Increase button height
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Less rounded corners
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.buyProducts,
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.separated(
                itemCount: inactiveOrders.length,
                padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenWidth(15)),
                itemBuilder: (context, index) {
                  Order currentOrder = inactiveOrders[index];
                  return OrderGroupCard(order: currentOrder);
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: getProportionateScreenWidth(15),
                  );
                },
              );
      },
    );
  }
}
