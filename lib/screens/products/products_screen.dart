import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/size_config.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});
  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  Widget _buildProductCard(int index) {
    final product = productController.products[index];

    // Get icon and color based on isSellable
    IconData typeIcon;
    Color typeColor;
    String typeLabel;

    switch (product.isSellable) {
      case 1:
        typeIcon = Icons.trending_up;
        typeColor = Colors.green;
        typeLabel = 'बिक्री';
        break;
      case 2:
        typeIcon = Icons.shopping_bag;
        typeColor = Colors.blue;
        typeLabel = 'खरिद';
        break;
      case 3:
        typeIcon = Icons.swap_horiz;
        typeColor = Colors.orange;
        typeLabel = 'दुबै';
        break;
      default:
        typeIcon = Icons.help_outline;
        typeColor = Colors.grey;
        typeLabel = '';
    }

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(16),
        vertical: getProportionateScreenWidth(8),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            splashColor: kPrimaryColor.withOpacity(0.1),
            highlightColor: kPrimaryColor.withOpacity(0.05),
            onTap: () {
              productController.isEdit(true);
              productController.selectedProduct(product);
              Get.toNamed(AppRoute.addProductScreen);
            },
            child: Padding(
              padding: EdgeInsets.all(getProportionateScreenWidth(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    children: [
                      // Product Icon
                      Container(
                        padding:
                            EdgeInsets.all(getProportionateScreenWidth(12)),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              kPrimaryColor.withOpacity(0.8),
                              kPrimaryColor,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: kPrimaryColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.inventory_2,
                          color: Colors.white,
                          size: getProportionateScreenWidth(24),
                        ),
                      ),
                      SizedBox(width: getProportionateScreenWidth(12)),

                      // Product Name and Type
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name!,
                              style: TextStyle(
                                fontSize: getProportionateScreenWidth(15),
                                color: Colors.grey.shade900,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: getProportionateScreenWidth(4)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(8),
                                vertical: getProportionateScreenWidth(4),
                              ),
                              decoration: BoxDecoration(
                                color: typeColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: typeColor.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    typeIcon,
                                    size: getProportionateScreenWidth(14),
                                    color: typeColor,
                                  ),
                                  SizedBox(
                                      width: getProportionateScreenWidth(4)),
                                  Text(
                                    typeLabel,
                                    style: TextStyle(
                                      fontSize: getProportionateScreenWidth(11),
                                      color: typeColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Action Buttons - wrapped in Material to stay above ripple
                      Material(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Material(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                splashColor: Colors.blue.shade200,
                                highlightColor: Colors.blue.shade100,
                                onTap: () {
                                  productController.isEdit(true);
                                  productController.selectedProduct(product);
                                  Get.toNamed(AppRoute.addProductScreen);
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(
                                      getProportionateScreenWidth(10)),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.blue.shade700,
                                    size: getProportionateScreenWidth(20),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: getProportionateScreenWidth(8)),
                            Material(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                splashColor: Colors.red.shade200,
                                highlightColor: Colors.red.shade100,
                                onTap: () => _showDeleteDialog(product.id!),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                      getProportionateScreenWidth(10)),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red.shade700,
                                    size: getProportionateScreenWidth(20),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Description
                  if (product.description != null &&
                      product.description!.isNotEmpty) ...[
                    SizedBox(height: getProportionateScreenWidth(12)),
                    Text(
                      product.description!,
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(13),
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  SizedBox(height: getProportionateScreenWidth(12)),

                  // Stock Info - wrapped in Material to stay above ripple
                  Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: EdgeInsets.all(getProportionateScreenWidth(12)),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.pie_chart,
                            size: getProportionateScreenWidth(16),
                            color: kPrimaryColor,
                          ),
                          SizedBox(width: getProportionateScreenWidth(8)),
                          Text(
                            'स्टक: ',
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(12),
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${product.stock ?? 0}',
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(13),
                              color: Colors.grey.shade900,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (product.unitId != null) ...[
                            SizedBox(width: getProportionateScreenWidth(4)),
                            Text(
                              _getUnitName(product.unitId!),
                              style: TextStyle(
                                fontSize: getProportionateScreenWidth(12),
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getUnitName(int unitId) {
    try {
      final unit = productController.units.firstWhere((u) => u.id == unitId);
      return unit.getName(Get.locale?.languageCode ?? 'en');
    } catch (e) {
      return '';
    }
  }

  Future<void> _showDeleteDialog(int productId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.warning_rounded,
                  color: Colors.red.shade700,
                  size: getProportionateScreenWidth(24),
                ),
              ),
              SizedBox(width: getProportionateScreenWidth(12)),
              Expanded(
                child: Text(
                  "मेटाउने पुष्टि गर्नुहोस्",
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(16),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            "तपाईं यो जिन्सी समान मेटाउन निश्चित हुनुहुन्छ?",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(14),
              fontWeight: FontWeight.w500,
              color: kCardDescColor,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                "रद्द गर्नुहोस्",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                  vertical: getProportionateScreenWidth(10),
                ),
              ),
              onPressed: () async {
                productController.deleteProduct(productId);
                Get.back();
              },
              child: const Text(
                "मेटाउनुहोस्",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(getProportionateScreenWidth(30)),
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              size: getProportionateScreenWidth(80),
              color: kPrimaryColor.withOpacity(0.6),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(24)),
          Text(
            'तपाईंसँग हाल कुनै जिन्सी समान छैन !',
            style: TextStyle(
              fontSize: getProportionateScreenWidth(16),
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(8)),
          Text(
            'नयाँ जिन्सी समान थप्न तलको बटन थिच्नुहोस्',
            style: TextStyle(
              fontSize: getProportionateScreenWidth(13),
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade500,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(24)),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [kPrimaryColor, kPrimaryColor.withOpacity(0.8)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: kPrimaryColor.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(32),
                  vertical: getProportionateScreenWidth(14),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                productController.isEdit(false);
                Get.toNamed(AppRoute.addProductScreen);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: getProportionateScreenWidth(20),
                  ),
                  SizedBox(width: getProportionateScreenWidth(8)),
                  Text(
                    'जिन्सी समान थप गर्नुहोस',
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(15),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,
        scrolledUnderElevation: 0,
        title: const Text(
          'जिन्सी समानहरू',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: Obx(
        () => productController.products.isNotEmpty
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [kPrimaryColor, kPrimaryColor.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryColor.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: FloatingActionButton(
                  onPressed: () {
                    productController.isEdit(false);
                    Get.toNamed(AppRoute.addProductScreen);
                  },
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child: const Icon(Icons.add, size: 28),
                ),
              )
            : const SizedBox.shrink(),
      ),
      body: Column(
        children: [
          // Decorative header curve
          Container(
            height: getProportionateScreenWidth(30),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(getProportionateScreenWidth(30)),
                bottomRight: Radius.circular(getProportionateScreenWidth(30)),
              ),
            ),
          ),

          // Content
          Expanded(
            child: Obx(
              () => productController.products.isNotEmpty
                  ? ListView.builder(
                      padding: EdgeInsets.only(
                        top: getProportionateScreenWidth(8),
                        bottom: getProportionateScreenWidth(80),
                      ),
                      itemBuilder: ((context, index) {
                        return _buildProductCard(index);
                      }),
                      itemCount: productController.products.length,
                    )
                  : _buildEmptyState(),
            ),
          ),
        ],
      ),
    );
  }
}
