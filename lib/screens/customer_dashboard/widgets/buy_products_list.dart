import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/models/paymentmethod.dart';
import 'package:smart_kishan/models/productCart.dart';
import 'package:smart_kishan/models/sellproduct.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class BuyProductsList extends StatelessWidget {
  const BuyProductsList({super.key, required this.products});
  final List<SellProduct> products;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: ListView.separated(
        itemCount: products.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(0),
        separatorBuilder: (context, index) => Divider(
          height: 2,
        ),
        itemBuilder: (context, index) {
          final product = products[index];
          return Container(
            height: 130,
            padding: EdgeInsets.symmetric(vertical: 15),
            margin: EdgeInsets.symmetric(
                horizontal: 1, vertical: index == 0 || index == 1 ? 1 : 0),
            child: InkWell(
              onTap: () {
                Get.toNamed(AppRoute.productDetailsScreen, arguments: product);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 105,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              product.imageUrls != null
                                  ? '$imgUrl${product.imageUrls![0]}'
                                  : '',
                            ))),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${product.name}',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            Spacer(),
                            product.paymentTypes != null
                                ? SizedBox(
                                    height: 20,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: product.paymentTypes!.length,
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                        width: 5,
                                      ),
                                      itemBuilder: (context, index) {
                                        PaymentMethod paymentMethod =
                                            product.paymentTypes![index];
                                        return Container(
                                          height: 20,
                                          width: 20,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 2, vertical: 2),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      '$imgUrl${paymentMethod.image}'))),
                                        );
                                      },
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                        Text(
                          product.unit != null
                              ? '${AppLocalizations.of(context)!.currency}${convertToLocalizedNumber(product.price.toString(), context)} / ${product.unit!.code}'
                              : '${AppLocalizations.of(context)!.currency}${convertToLocalizedNumber(product.price.toString(), context)}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          product.unit != null && product.minOrder != null
                              ? '${AppLocalizations.of(context)!.minimumOrder} : ${convertToLocalizedNumber(product.minOrder.toString(), context)} ${product.unit!.code}'
                              : '${AppLocalizations.of(context)!.minimumOrder} : ${convertToLocalizedNumber(product.minOrder.toString(), context)}',
                          style: TextStyle(color: kCardDescColor),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 30,
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    // Direct Buy Action
                                    Get.toNamed(AppRoute.orderDeliveryScreen,
                                        arguments: {
                                          'productId': product.id,
                                          'quantity': product.minOrder,
                                        });
                                  },
                                  icon: HugeIcon(
                                      icon:
                                          HugeIcons.strokeRoundedDeliveryBox01,
                                      size: 16),
                                  label: Text(
                                    AppLocalizations.of(context)!.buyItNow,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryColor,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    minimumSize: Size(double.infinity, 30),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // Change radius here
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    productCartController.addCartItem(
                                        ProductCart(
                                            productId: product.id!,
                                            quantity: product.minOrder!,
                                            product: product));
                                  },
                                  icon: HugeIcon(
                                      icon:
                                          HugeIcons.strokeRoundedShoppingBag01,
                                      size: 16),
                                  label: Text(
                                    AppLocalizations.of(context)!.addToBag,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // Change radius here
                                    ),
                                    backgroundColor: Colors.grey[200],
                                    foregroundColor: Colors.black,
                                    minimumSize: Size(double.infinity, 30),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
