import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/models/sellproduct.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class SellProductScreen extends StatefulWidget {
  const SellProductScreen({super.key});

  @override
  State<SellProductScreen> createState() => _SellProductScreenState();
}

class _SellProductScreenState extends State<SellProductScreen> {
  @override
  void initState() {
    // buyersGroupController.getBuyersGroups();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.myProducts),
          automaticallyImplyLeading: false,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            sellProductController.isEdit(false);
            sellProductController.selectedSellProductImages.clear();
            sellProductController.networkSellProductImages.clear();
            Get.toNamed(AppRoute.addSellProductSteps);
          },
          backgroundColor: kPrimaryColor,
          child: const Icon(Icons.add),
        ),
        body: Obx(() => sellProductController.sellProducts.isNotEmpty
            ? RefreshIndicator(
                color: kPrimaryColor,
                onRefresh: () async {
                  await sellProductController.getSellProducts();
                },
                child: ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
                  padding: const EdgeInsets.all(15.0),
                  itemCount: sellProductController.sellProducts.length,
                  itemBuilder: (context, index) {
                    final sellProduct =
                        sellProductController.sellProducts[index];
                    return index ==
                            sellProductController.sellProducts.length - 1
                        ? Container(
                            margin: EdgeInsets.only(bottom: 120),
                            child: SellProductCard(sellProduct: sellProduct),
                          )
                        : SellProductCard(sellProduct: sellProduct);
                  },
                ),
              )
            : Transform.translate(
                offset: const Offset(0.0, -60.0),
                child: RefreshIndicator(
                  onRefresh: () async {
                    await sellProductController.getSellProducts();
                  },
                  displacement: 40,
                  child: ListView(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height -
                            kToolbarHeight - // Exclude AppBar height
                            MediaQuery.of(context).padding.top,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 80,
                                backgroundColor: Colors.green.shade50,
                                child: HugeIcon(
                                  icon: HugeIcons.strokeRoundedGroupItems,
                                  size: 80,
                                  color: Colors.green.shade300,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                AppLocalizations.of(context)!.emptyProductList,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                AppLocalizations.of(context)!.addProductForSale,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(15),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryColor,
                                    minimumSize: Size(
                                        getProportionateScreenWidth(20),
                                        getProportionateScreenWidth(40))),
                                onPressed: () {
                                  buyersGroupController.isEdit(false);
                                  buyersGroupController
                                      .selectedBuyersGroupImage.value = '';
                                  buyersGroupController
                                      .networkBuyersGroupImage.value = '';
                                  Get.toNamed(AppRoute.addSellProductSteps);
                                },
                                child: Text(AppLocalizations.of(context)!
                                    .addSaleProduct),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )));
  }
}

class SellProductCard extends StatefulWidget {
  final SellProduct sellProduct;

  const SellProductCard({Key? key, required this.sellProduct})
      : super(key: key);

  @override
  _SellProductCardState createState() => _SellProductCardState();
}

class _SellProductCardState extends State<SellProductCard> {
  @override
  Widget build(BuildContext context) {
    final sellProduct = widget.sellProduct;
    return InkWell(
        onTap: () {
          sellProductController.isEdit(true);
          sellProductController.selectedSellProduct(sellProduct);
          if (sellProduct.imageUrls != null) {
            sellProductController.networkSellProductImages
                .addAll(sellProduct.imageUrls!);
          } else {
            sellProductController.networkSellProductImages.clear();
          }
          Get.toNamed(AppRoute.addSellProductSteps);
        },
        highlightColor: Colors.white,
        splashColor: kPrimaryColor.withOpacity(0.2),
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: kPrimaryColor.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 15,
                  offset: const Offset(5, 5),
                ),
                BoxShadow(
                  color: kPrimaryColor.withOpacity(0.2),
                  offset: Offset(-5, -5),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
              color: Colors.white,
            ),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 65,
                          height: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      '$imgUrl${sellProduct.imageUrls![0]}'),
                                  fit: BoxFit.cover)),
                          // child: Image.network(
                          //   '$imgUrl${sellProduct.imageUrls![0]}',
                          //   height: 60,
                          //   width: 60,
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      '${sellProduct.name}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount:
                                          sellProduct.paymentTypes!.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                            margin:
                                                const EdgeInsets.only(left: 5),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2, vertical: 2),
                                            decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Image.network(
                                              '$imgUrl${sellProduct.paymentTypes![index].image}',
                                              width: 20,
                                            ));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                  '${AppLocalizations.of(context)!.currency} ${convertToLocalizedNumber(sellProduct.price.toString(), context)}/${sellProduct.unit != null ? sellProduct.unit!.name : ''}',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey)),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      '${AppLocalizations.of(context)!.inStock}: ${convertToLocalizedNumber(sellProduct.stock.toString(), context)}',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.green)),
                                  Text(
                                      '${AppLocalizations.of(context)!.minimumOrder}: ${convertToLocalizedNumber(sellProduct.minOrder.toString(), context)}',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.amber)),
                                ],
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 76,
                        ),
                        Text(
                            '${AppLocalizations.of(context)!.status} : ${sellProduct.status == 1 ? AppLocalizations.of(context)!.active : AppLocalizations.of(context)!.inactive}',
                            style: TextStyle(fontSize: 14, color: Colors.grey)),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton.outlined(
                                color: Colors.grey,
                                visualDensity: VisualDensity.compact,
                                iconSize: 16,
                                style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Colors.grey)),
                                onPressed: () async {
                                  sellProductController.isEdit(true);
                                  sellProductController
                                      .selectedSellProduct(sellProduct);
                                  if (sellProduct.imageUrls != null) {
                                    sellProductController
                                        .networkSellProductImages
                                        .addAll(sellProduct.imageUrls!);
                                  } else {
                                    sellProductController
                                        .networkSellProductImages
                                        .clear();
                                  }
                                  Get.toNamed(AppRoute.addSellProductSteps);
                                },
                                icon: HugeIcon(
                                  icon: HugeIcons.strokeRoundedEdit02,
                                ),
                              ),
                              IconButton.outlined(
                                color: kErrorColor,
                                visualDensity: VisualDensity.compact,
                                iconSize: 16,
                                style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: kErrorColor)),
                                onPressed: () async {
                                  // Show confirmation dialog or directly handle deletion
                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        backgroundColor: Colors.transparent,
                                        insetPadding: const EdgeInsets.all(
                                            10), // To control padding from the edges
                                        child: Stack(
                                          alignment: Alignment.center,
                                          clipBehavior: Clip.none,
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8, // 80% of screen width
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 40),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const SizedBox(
                                                      height:
                                                          60), // Space for the icon
                                                  Text(
                                                    "बिक्री उत्पादन मेटाउनुस्",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    "के तपाईं यो बिक्रीका लागि रहेको सामान मेटाउन चाहनुहुन्छ?",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black54,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.grey[200],
                                                          foregroundColor:
                                                              Colors.black,
                                                          minimumSize:
                                                              const Size(
                                                                  100, 40),
                                                        ),
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(false),
                                                        child: const Text(
                                                            "रद्द गर्नुहोस्"),
                                                      ),
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.red,
                                                          foregroundColor:
                                                              Colors.white,
                                                          minimumSize:
                                                              const Size(
                                                                  100, 40),
                                                        ),
                                                        onPressed: () {
                                                          sellProductController
                                                              .deleteSellProduct(
                                                                  sellProduct
                                                                      .id!);
                                                          Navigator.of(context)
                                                              .pop(true);
                                                        },
                                                        child: const Text(
                                                            "मेटाउनुस्"),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              top:
                                                  0, // Position the icon above the dialog
                                              child: CircleAvatar(
                                                radius: 50,
                                                backgroundColor: Colors.white,
                                                child: HugeIcon(
                                                  icon: HugeIcons
                                                      .strokeRoundedProductLoading,
                                                  color: Colors.red,
                                                  size: 50,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: HugeIcon(
                                  icon: HugeIcons.strokeRoundedDelete01,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )));
  }
}
