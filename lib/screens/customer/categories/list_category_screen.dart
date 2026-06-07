import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/controllers/customer_dashboard_controller.dart';
import 'package:smart_kishan/models/cropCategory.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class ListCategoryScreen extends StatelessWidget {
  const ListCategoryScreen({super.key, required this.dashboardController});
  final CustomerDashboardController dashboardController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.allCategories),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Obx(
              () => cropCategoryController.cropCategories.isNotEmpty
                  ? GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                      ),
                      itemCount: cropCategoryController.cropCategories.length,
                      itemBuilder: (context, index) {
                        CropCategory currentCategory =
                            cropCategoryController.cropCategories[index];
                        return InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            buyProductsController.selectedCategories.clear();
                            buyProductsController.selectedCategories.clear();
                            buyProductsController.selectedPaymentMethods
                                .clear();
                            buyProductsController.searchName('');
                            buyProductsController.selectedCategories
                                .add(currentCategory);
                            buyProductsController.searchProducts();
                            dashboardController.updateIndex(1);
                            Get.back();
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(color: kPrimaryGrey),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Constrained image to prevent overflow
                                Expanded(
                                  child: Image.network(
                                    '$imgUrl${currentCategory.image}',
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error,
                                            stackTrace) =>
                                        Icon(Icons
                                            .error), // Fallback in case of an error
                                  ),
                                ),
                                SizedBox(
                                    height: 5), // Space between image and text
                                Text(
                                  '${currentCategory.name}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String title, String imagePath) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 150),
          child: Container(
            color: kPrimaryColor.withOpacity(0.2),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Align(
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage:
                        NetworkImage('$imgUrl$imagePath'), // Add image here
                    backgroundColor: Colors.transparent,
                  ),
                ),
                SizedBox(width: 15),
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: kCardTitleColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
