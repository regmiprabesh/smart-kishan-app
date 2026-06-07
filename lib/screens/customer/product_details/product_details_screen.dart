import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/models/deliverylocation.dart';
import 'package:smart_kishan/models/productCart.dart';
import 'package:smart_kishan/models/sellproduct.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _currentPage = 0;
  int _selectedQuantity = 0;
  int minOrder = 1;
  int stock = 0;
  SellProduct? product;
  List<DeliveryLocation> deliveryLocations = [];

  void increment() {
    if (_selectedQuantity < stock) {
      setState(() {
        _selectedQuantity++;
      });
    }
  }

  void decrement() {
    setState(() {
      if (_selectedQuantity > 1 && _selectedQuantity > minOrder) {
        _selectedQuantity--;
      }
    });
  }

  @override
  void initState() {
    SellProduct currentProduct = Get.arguments as SellProduct;
    setState(() {
      product = currentProduct;
    });
    if (product != null) {
      setState(() {
        deliveryLocations = getSelectedDeliveryLocations(
            product!, buyProductsController.deliveryLocations);
        _selectedQuantity = product!.minOrder != null ? product!.minOrder! : 1;
        minOrder = product!.minOrder != null ? product!.minOrder! : 1;
        stock = product!.stock != null ? product!.stock! : 1;
      });
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: product != null
          ? Column(
              children: [
                SizedBox(
                  height: 330,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: SizedBox(
                          height: 300,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Carousel Slider
                              CarouselSlider(
                                options: CarouselOptions(
                                  enlargeCenterPage: true,
                                  height: 300,
                                  viewportFraction: 1,
                                  enlargeFactor: 0,
                                  animateToClosest: false,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _currentPage = index;
                                    });
                                  },
                                ),
                                items: product!.imageUrls!.map((i) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(imgUrl + i),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                              // Gradient Overlay
                              IgnorePointer(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.white.withOpacity(0.4),
                                        Colors.transparent,
                                      ],
                                      stops: [0.0, 0.9],
                                    ),
                                  ),
                                ),
                              ),
                              // Back Button
                              Positioned(
                                top: 60,
                                left: 16,
                                child: InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.black45,
                                    child: Icon(Icons.arrow_back,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Dots Indicator
                      product!.imageUrls != null &&
                              product!.imageUrls!.length > 1
                          ? Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  height: 20,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      for (int i = 0;
                                          i < product!.imageUrls!.length;
                                          i++)
                                        Container(
                                          margin: const EdgeInsets.all(5),
                                          height: i == _currentPage ? 10 : 7,
                                          width: i == _currentPage ? 10 : 7,
                                          decoration: BoxDecoration(
                                            color: i == _currentPage
                                                ? kPrimaryColor
                                                : Colors.grey,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                // Other Content
                Expanded(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: ListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            children: [
                              Text(
                                '${product!.name}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              product!.creator != null
                                  ? Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: AssetImage(
                                              "assets/images/profileimage.png"),
                                        ),
                                        SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('${product!.creator!.name}',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Row(
                                              children: [
                                                Icon(Icons.star,
                                                    color: Colors.amber,
                                                    size: 16),
                                                Text(convertToLocalizedNumber(
                                                    4.2.toString(), context)),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  : SizedBox(),
                              SizedBox(height: 16),
                              Text(
                                product!.unit != null
                                    ? '${AppLocalizations.of(context)!.currency}${convertToLocalizedNumber(product!.price.toString(), context)} / ${product!.unit!.code}'
                                    : '${AppLocalizations.of(context)!.currency}${convertToLocalizedNumber(product!.price.toString(), context)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                              // SizedBox(height: 8),
                              Text(
                                '${product!.description}',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 15),
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Text(
                                    '${AppLocalizations.of(context)!.minimumOrder}: ',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    product!.minOrder != null &&
                                            product!.unit != null
                                        ? '${convertToLocalizedNumber(product!.minOrder.toString(), context)} ${product!.unit!.code}'
                                        : convertToLocalizedNumber(
                                            product!.minOrder.toString(),
                                            context),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: kSecondaryColor),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                AppLocalizations.of(context)!
                                    .acceptedPaymentMethods,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              product!.paymentTypes != null
                                  ? SizedBox(
                                      height: 40,
                                      child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: kPrimaryGrey
                                                      .withOpacity(0.6)),
                                              padding: EdgeInsets.only(
                                                  left: 5, right: 10),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 30,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                '$imgUrl${product!.paymentTypes![index].image}'))),
                                                  ),
                                                  Text(
                                                    product!
                                                        .paymentTypes![index]
                                                        .name,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, index) =>
                                              SizedBox(
                                                width: 10,
                                              ),
                                          itemCount:
                                              product!.paymentTypes!.length),
                                    )
                                  : SizedBox(),
                              SizedBox(height: 16),
                              Text(
                                AppLocalizations.of(context)!.deliveryLocations,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              deliveryLocations.isNotEmpty
                                  ? SizedBox(
                                      height: 40,
                                      child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: kPrimaryGrey
                                                      .withOpacity(0.6)),
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    deliveryLocations[index]
                                                        .name,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, index) =>
                                              SizedBox(
                                                width: 10,
                                              ),
                                          itemCount: deliveryLocations.length),
                                    )
                                  : Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: kPrimaryGrey.withOpacity(0.6),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: Text(
                                          'All Over Nepal',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),

                              product!.additionalNotes != null
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 16),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .additionalNotes,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '${product!.additionalNotes}',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 15),
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 110,
                              )
                            ],
                          ),
                        ),
                      ),
                      // Positioned Quantity Row at Bottom
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(
                              bottom: 30, top: 10, left: 15, right: 15),
                          child: Row(
                            children: [
                              // Quantity Box
                              Expanded(
                                child: Container(
                                  height: 50,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Decrement Button
                                      InkWell(
                                        onTap: decrement,
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.red.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Icon(Icons.remove,
                                              color: Colors.red, size: 24),
                                        ),
                                      ),
                                      // Quantity Display
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          convertToLocalizedNumber(
                                              _selectedQuantity.toString(),
                                              context),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      // Increment Button
                                      InkWell(
                                        onTap: increment,
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.green.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Icon(Icons.add,
                                              color: Colors.green, size: 24),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              // Next Page Button
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    productCartController.addCartItem(
                                        ProductCart(
                                            productId: product!.id!,
                                            quantity: _selectedQuantity,
                                            product: product));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryColor,
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.addToBag,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : SizedBox(),
    );
  }
}
