import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/enums/orderStatus.dart';
import 'package:smart_kishan/models/order.dart';
import 'package:smart_kishan/screens/vendor/orders/widgets/order_group_card.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class ActiveOrders extends StatefulWidget {
  const ActiveOrders({super.key});

  @override
  State<ActiveOrders> createState() => _ActiveOrdersState();
}

class _ActiveOrdersState extends State<ActiveOrders> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        // Filter active orders
        final activeOrders = vendorOrdersController.myOrders
            .where((order) =>
                order.status == OrderStatus.newOrder ||
                order.status == OrderStatus.processing ||
                order.status == OrderStatus.shipped)
            .toList();
        return activeOrders.isEmpty
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
                        AppLocalizations.of(context)!.noActiveOrders,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: kCardTitleColor,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!
                            .activeVendorOrdersDescription,
                        style: TextStyle(
                          fontSize: 14,
                          color: kCardDescColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      // OutlinedButton(
                      //   onPressed: () {},
                      //   style: OutlinedButton.styleFrom(
                      //     side: const BorderSide(color: kPrimaryColor),
                      //     minimumSize:
                      //         const Size(150, 50), // Increase button height
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(
                      //           10), // Less rounded corners
                      //     ),
                      //   ),
                      //   child: const Text(
                      //     "Buy Products",
                      //     style: TextStyle(
                      //         color: kPrimaryColor,
                      //         fontWeight: FontWeight.w600),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              )
            : ListView.separated(
                itemCount: activeOrders.length,
                padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenWidth(15)),
                itemBuilder: (context, index) {
                  Order currentOrder = activeOrders[index];
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
