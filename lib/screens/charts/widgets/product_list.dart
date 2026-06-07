import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/models/activity.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/size_config.dart';

class ProductListSection extends StatelessWidget {
  const ProductListSection({super.key});

  @override
  Widget build(BuildContext context) {
    final DateFormat dateOnlyFormat = DateFormat("EEEE, dd MMMM");

    return Obx(() {
      List<Activity> incomeActivities =
          incomeController.activities.where((e) => e.income != null).toList();

      return Container(
        margin:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'जिन्सी समान',
              style: TextStyle(
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: getProportionateScreenWidth(14)),
            ),
            SizedBox(
              height: getProportionateScreenWidth(10),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  color: kCanvasColor,
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryColor.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20)),
              child: productController.products.isNotEmpty
                  ? ListView.builder(
                      itemCount: productController.products.length > 5
                          ? 5
                          : productController.products.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(15),
                            vertical: getProportionateScreenWidth(5)),
                        title: GestureDetector(
                          onTap: () {},
                          child: Text(
                            '${productController.products[index].name}',
                            style: TextStyle(
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: getProportionateScreenWidth(12)),
                          ),
                        ),
                        subtitle: Text(
                          productController.products[index].date != null
                              ? dateOnlyFormat.format(DateTime.parse(
                                  productController.products[index].date!))
                              : 'No Date Found',
                          style: TextStyle(
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: getProportionateScreenWidth(10)),
                        ),
                        trailing: Text(
                          'स्टक - ${productController.products[index].stock}',
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: getProportionateScreenWidth(13)),
                        ),
                      ),
                    )
                  : Container(
                      height: 150,
                      alignment: Alignment.center,
                      child: Text(
                        'तपाईंसँग हाल कुनै उत्पादन छैन !',
                        style: TextStyle(
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: getProportionateScreenWidth(12)),
                      ),
                    ),
            ),
          ],
        ),
      );
    });
  }
}
