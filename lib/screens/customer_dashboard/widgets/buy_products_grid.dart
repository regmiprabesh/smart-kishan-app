import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/models/productCart.dart';
import 'package:smart_kishan/models/sellproduct.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class BuyProductsGrid extends StatelessWidget {
  const BuyProductsGrid({super.key, required this.products});
  final List<SellProduct> products;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: GridView.builder(
        itemCount: products.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.6, // Adjust this ratio for card aspect
        ),
        itemBuilder: (context, index) {
          final product = products[index];

          return Container(
            margin: EdgeInsets.symmetric(
                horizontal: 1, vertical: index == 0 || index == 1 ? 1 : 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: kCanvasColor,
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 1.0)],
            ),
            child: InkWell(
              onTap: () {
                Get.toNamed(AppRoute.productDetailsScreen, arguments: product);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(0), top: Radius.circular(12)),
                      child: Image.network(
                        product.imageUrls != null
                            ? '$imgUrl${product.imageUrls![0]}'
                            : '',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${product.name}',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis),
                          maxLines: 1,
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
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
                          ],
                        ),
                        SizedBox(height: 5),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Direct Buy Action
                            Get.toNamed(AppRoute.orderDeliveryScreen,
                                arguments: {
                                  'productId': product.id,
                                  'quantity': product.minOrder,
                                });
                          },
                          icon: HugeIcon(
                              icon: HugeIcons.strokeRoundedDeliveryBox01,
                              size: 16),
                          label: Text(AppLocalizations.of(context)!.buyItNow),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              minimumSize: Size(double.infinity, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Add to Bag action
                            productCartController.addCartItem(ProductCart(
                                productId: product.id!,
                                quantity: product.minOrder!,
                                product: product));
                          },
                          icon: HugeIcon(
                              icon: HugeIcons.strokeRoundedShoppingBag01,
                              size: 16),
                          label: Text(AppLocalizations.of(context)!.addToBag),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              foregroundColor: Colors.black,
                              minimumSize: Size(double.infinity, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        ),
                        SizedBox(height: 10),
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
