import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/helpers/l10n.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class ProductListSection extends StatelessWidget {
  const ProductListSection({super.key});

  // Formats a Gregorian date string using the active locale.
  // English: Thursday, 08 May, 2025
  // Nepali:  बिहिबार, ०८ मे, २०२५  (intl translates via ne_NP locale)
  String _formatDate(String? rawDate, String localeName) {
    if (rawDate == null || rawDate.isEmpty) return '';
    final dt = DateTime.tryParse(rawDate);
    if (dt == null) return rawDate;
    return DateFormat('EEEE, dd MMMM, yyyy', localeName).format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Obx(() {
      return Container(
        margin:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.productListTitle,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: getProportionateScreenWidth(16),
              ),
            ),
            SizedBox(height: getProportionateScreenWidth(10)),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: kCanvasColor,
                boxShadow: [
                  BoxShadow(
                    color: kPrimaryColor.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: const Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: productController.products.isNotEmpty
                  ? ListView.builder(
                      itemCount: productController.products.length > 5
                          ? 5
                          : productController.products.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final product = productController.products[index];
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(15),
                            vertical: getProportionateScreenWidth(5),
                          ),
                          title: Text(
                            product.name ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: getProportionateScreenWidth(12),
                            ),
                          ),
                          subtitle: Text(
                            _formatDate(product.createdDate, l10n.localeName),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: getProportionateScreenWidth(10),
                            ),
                          ),
                          trailing: Text(
                            '${l10n.stockLabel} - ${localizedNumber(product.stock ?? 0)}',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: getProportionateScreenWidth(13),
                            ),
                          ),
                        );
                      },
                    )
                  : SizedBox(
                      height: 150,
                      child: Center(
                        child: Text(
                          l10n.noProductsFound,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: getProportionateScreenWidth(12),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      );
    });
  }
}
