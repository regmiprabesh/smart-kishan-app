import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/controllers/customer_dashboard_controller.dart';
import 'package:smart_kishan/models/paymentmethod.dart';
import 'package:smart_kishan/models/productCart.dart';
import 'package:smart_kishan/widgets/confirm_dialog.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class CustomerCartScreen extends StatefulWidget {
  const CustomerCartScreen({super.key, required this.dashboardController});
  final CustomerDashboardController dashboardController;
  @override
  State<CustomerCartScreen> createState() => _CustomerCartScreenState();
}

class _CustomerCartScreenState extends State<CustomerCartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            AppLocalizations.of(context)!.shoppingCart,
          ),
          backgroundColor: kPrimaryColor,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.yourCart,
                              style: TextStyle(
                                  color: kCardTitleColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(width: 10),
                            Obx(
                              () => Container(
                                decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: Text(
                                  productCartController.myCart.isEmpty
                                      ? AppLocalizations.of(context)!.noItems
                                      : '${convertToLocalizedNumber(productCartController.myCart.length.toString(), context)} ${AppLocalizations.of(context)!.cartItems((productCartController.myCart.length))}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 2, color: kPrimaryGrey),
                      SizedBox(height: 20),
                      Obx(() => productCartController.myCart.isNotEmpty
                          ? ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: productCartController.myCart.length,
                              separatorBuilder: (context, index) => SizedBox(
                                height: 20,
                                child: Divider(height: 10),
                              ),
                              itemBuilder: (context, index) {
                                ProductCart cartItem =
                                    productCartController.myCart[index];
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 80,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              '$imgUrl${cartItem.product!.imageUrls![0]}'),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${cartItem.product!.name}',
                                            maxLines: 1,
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: kCardTitleColor),
                                          ),
                                          Text(
                                            '${AppLocalizations.of(context)!.currency}${convertToLocalizedNumber(cartItem.product!.price.toString(), context)}/${cartItem.product!.unit!.code}',
                                            style: TextStyle(
                                                color: kCardDescColor),
                                          ),
                                          Text(
                                            '${AppLocalizations.of(context)!.quantityShort} ${convertToLocalizedNumber(cartItem.quantity.toString(), context)} ${cartItem.product!.unit!.code}',
                                            style: TextStyle(
                                                color: kCardDescColor),
                                          ),
                                          SizedBox(
                                            height: 20,
                                            child: ListView.separated(
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              itemCount: cartItem.product!
                                                  .paymentTypes!.length,
                                              separatorBuilder:
                                                  (context, index) => SizedBox(
                                                width: 5,
                                              ),
                                              itemBuilder: (context, index) {
                                                PaymentMethod paymentMethod =
                                                    cartItem.product!
                                                        .paymentTypes![index];
                                                return Container(
                                                  height: 20,
                                                  width: 20,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 2,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
                                                              '$imgUrl${paymentMethod.image}'))),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton.outlined(
                                      color: Colors.red,
                                      visualDensity: VisualDensity.compact,
                                      iconSize: 16,
                                      style: OutlinedButton.styleFrom(
                                        side:
                                            const BorderSide(color: Colors.red),
                                      ),
                                      onPressed: () async {
                                        await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ConfirmationDialog(
                                              title:
                                                  AppLocalizations.of(context)!
                                                      .deleteCartTitle,
                                              subtitle:
                                                  AppLocalizations.of(context)!
                                                      .deleteCartMessage,
                                              icon: Icons.remove,
                                              confirmButtonText:
                                                  AppLocalizations.of(context)!
                                                      .delete,
                                              cancelButtonText:
                                                  AppLocalizations.of(context)!
                                                      .cancel,
                                              onConfirm: () {
                                                productCartController
                                                    .deleteCartItem(
                                                        cartItem.id!);
                                                Navigator.of(context).pop(true);
                                              },
                                              onCancel: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                            );
                                          },
                                        );
                                      },
                                      icon: const HugeIcon(
                                          icon:
                                              HugeIcons.strokeRoundedDelete02),
                                    ),
                                  ],
                                );
                              },
                            )
                          : Center(
                              // Center widget added here
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Vertically centers the content
                                children: [
                                  Image.asset(
                                    'assets/images/empty_cart.png',
                                    height: 300,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .yourCartIsEmpty,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: kCardTitleColor,
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.cartMessage,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: kCardDescColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 20),
                                  OutlinedButton(
                                    onPressed: () {
                                      widget.dashboardController.updateIndex(1);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          color: kPrimaryColor),
                                      minimumSize: const Size(
                                          150, 50), // Increase button height
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
                            )),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Obx(
              () => productCartController.myCart.isNotEmpty
                  ? Container(
                      color: kPrimaryGrey.withOpacity(0.3),
                      padding: EdgeInsets.only(
                          bottom: 10, top: 10, left: 15, right: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.total,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: kCardDescColor),
                                ),
                                Text(
                                  '${AppLocalizations.of(context)!.currency} ${convertToLocalizedNumber(productCartController.totalCartPrice.toStringAsFixed(2), context)}',
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Get.toNamed('/orderDeliveryScreen');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                minimumSize: const Size(double.infinity, 45),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.checkOut,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
            ),
          ],
        ));
  }
}
