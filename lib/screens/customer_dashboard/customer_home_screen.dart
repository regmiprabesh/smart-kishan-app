import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/controllers/customer_dashboard_controller.dart';
import 'package:smart_kishan/models/cropCategory.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/screens/customer/categories/list_category_screen.dart';
import 'package:smart_kishan/screens/customer_dashboard/widgets/buy_products_grid.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';
import 'package:smart_kishan/widgets/custom_clip_path.dart';

class CustomerHomeScreen extends StatelessWidget {
  CustomerHomeScreen({super.key, required this.dashboardController});
  bool isCollapsed = false;
  bool isStretched = true;
  bool increasePadding = true;
  bool reducePadding = false;
  double extendedHeight = 120.0;
  double padding = 10.0;
  double currentHeight = 0.0;
  double previousHeight = 0.0;
  CustomerDashboardController dashboardController;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return CustomScrollView(physics: const ClampingScrollPhysics(), slivers: [
      SliverAppBar(
        elevation: 0,
        backgroundColor: kCanvasColor,
        leading: IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedMenu01,
              color: Theme.of(context).iconTheme.color,
              size: 28,
            )),
        expandedHeight: 120.0,
        pinned: true,
        flexibleSpace: Container(
          color: kCanvasColor,
          child: SafeArea(
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              isCollapsed = constraints.biggest.height ==
                      MediaQuery.of(context).padding.top + kToolbarHeight
                  ? true
                  : false;
              isStretched = constraints.biggest.height ==
                      MediaQuery.of(context).padding.top + extendedHeight
                  ? true
                  : false;

              currentHeight = constraints.maxHeight;
              if (previousHeight < currentHeight) {
                increasePadding = false;
                reducePadding = true;
                previousHeight = currentHeight;
              }
              if (previousHeight > currentHeight) {
                increasePadding = true;
                reducePadding = false;
                previousHeight = currentHeight;
              }
              if (isCollapsed) {
                padding = 60;
                increasePadding = false;
                reducePadding = true;
              }
              if (isStretched) {
                padding = 15;
                increasePadding = true;
                reducePadding = false;
              }

              if (increasePadding) {
                double temp = padding + (constraints.maxHeight) / 100;
                if (temp <= 60) {
                  padding = temp;
                } else {
                  temp = temp - (temp - 60);
                  padding = temp;
                }
              }
              if (reducePadding) {
                double temp = padding - (constraints.maxHeight) / 100;
                if (temp >= 10) {
                  padding = temp;
                } else {
                  temp = temp + (10 - temp);
                  padding = temp;
                }
              }

              return FlexibleSpaceBar(
                centerTitle: false,
                expandedTitleScale: 1.3,
                // titlePadding: const EdgeInsets.only(left: 20, bottom: 10, right: 20),
                titlePadding:
                    EdgeInsets.only(left: padding, bottom: 10, right: 10),
                title: SizedBox(
                  height: 35,
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoute.productSearchScreen);
                    },
                    child: TextField(
                      enabled: false,
                      controller: searchController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: kPrimaryGrey.withOpacity(0.6),
                        hintStyle: TextStyle(
                            fontSize: getProportionateScreenWidth(12),
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 16),
                        hintText: AppLocalizations.of(context)!.searchHint,
                        prefixIcon: IconButton(
                          icon: Icon(
                            Icons.search,
                            size: 18,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {},
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                ),

                background: Column(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.only(top: 10.0, left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoute.myDeliveryAddress);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 35),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .deliveryLocation,
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        fontSize:
                                            getProportionateScreenWidth(12),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 0.0),
                                      child: Row(
                                        children: [
                                          HugeIcon(
                                            icon: HugeIcons
                                                .strokeRoundedLocation01,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          const SizedBox(width: 5),
                                          Obx(
                                            () => deliveryAddressController
                                                    .deliveryAddressList
                                                    .isNotEmpty
                                                ? Text(
                                                    deliveryAddressController
                                                                .getDefaultCityName()
                                                                .isEmpty &&
                                                            deliveryAddressController.getDefaultCityName() ==
                                                                ''
                                                        ? AppLocalizations.of(
                                                                context)!
                                                            .notSelected
                                                        : deliveryAddressController
                                                            .getDefaultCityName(),
                                                    style: theme
                                                        .textTheme.bodyMedium,
                                                  )
                                                : Text(AppLocalizations.of(
                                                        context)!
                                                    .notSelected),
                                          ),
                                          const HugeIcon(
                                            icon: HugeIcons
                                                .strokeRoundedArrowDown01,
                                            size: 17,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          CircleAvatar(
                            radius: 22,
                            backgroundImage:
                                AssetImage("assets/images/profileimage.png"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
      SliverList(
          delegate: SliverChildBuilderDelegate(childCount: 1,
              (BuildContext context, int index) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(
            children: [
              ClipPath(
                clipper: CustomClipPath(),
                child: Container(
                  height: 160,
                  color: Theme.of(context).canvasColor,
                ),
              ),
              Obx(
                () => bannerController.banners.isNotEmpty
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: CarouselSlider(
                          options: CarouselOptions(
                              enlargeCenterPage: true,
                              aspectRatio: 16 / 9,
                              viewportFraction: 1),
                          items: bannerController.banners.map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image:
                                              NetworkImage(imgUrl + i.image!))),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      )
                    : SizedBox(),
              ),
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Categories title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.categories,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ListCategoryScreen(
                              dashboardController: dashboardController);
                        },
                      ));
                    },
                    child: Text(
                      textAlign: TextAlign.end,
                      AppLocalizations.of(context)!.viewAll,
                      style: TextStyle(
                          fontSize: 15,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Horizontal List of Categories
              Obx(
                () => cropCategoryController.cropCategories.isNotEmpty
                    ? SizedBox(
                        height: 65, // Adjust height as needed
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                cropCategoryController.cropCategories.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(width: 10),
                            itemBuilder: (context, index) {
                              CropCategory cropCategory =
                                  cropCategoryController.cropCategories[index];
                              return _buildCategoryItem('${cropCategory.name}',
                                  '${cropCategory.image}', () {
                                buyProductsController.selectedCategories
                                    .clear();
                                buyProductsController.selectedPaymentMethods
                                    .clear();
                                buyProductsController.searchName('');
                                buyProductsController.selectedCategories
                                    .add(cropCategory);
                                buyProductsController.searchProducts();
                                dashboardController.updateIndex(1);
                              });
                            }),
                      )
                    : SizedBox(),
              )
            ]),
          ),
          SizedBox(height: 20),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.featuredProducts,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        GestureDetector(
                          onTap: () {
                            buyProductsController.selectedCategories.clear();
                            buyProductsController.selectedPaymentMethods
                                .clear();
                            buyProductsController.searchName('');
                            buyProductsController.searchProducts();
                            dashboardController.updateIndex(1);
                          },
                          child: Text(
                            textAlign: TextAlign.end,
                            AppLocalizations.of(context)!.viewAll,
                            style: TextStyle(
                                fontSize: 15,
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ])),
          Obx(
            () => buyProductsController.featuredProducts.isNotEmpty
                ? BuyProductsGrid(
                    products: buyProductsController.featuredProducts)
                : SizedBox(),
          ),
          SizedBox(
            height: 30,
          )
        ]);
      }))
    ]);
  }

  Widget _buildCategoryItem(
      String title, String imagePath, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: kPrimaryColor.withOpacity(0.2),
        ),
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
      ),
    );
  }
}
