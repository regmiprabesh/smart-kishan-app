import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/controllers/vendor_dashboard_controller.dart';
import 'package:smart_kishan/enums/orderStatus.dart';
import 'package:smart_kishan/models/order.dart';
import 'package:smart_kishan/models/searchHistory.dart';
import 'package:smart_kishan/screens/vendor/dashboard/widgets/line_chart_content.dart';
import 'package:smart_kishan/screens/vendor/dashboard/widgets/vendor_custom_drawer.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/widgets/custom_clip_path.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({super.key, required this.vendorDashboardController});
  final VendorDashboardController vendorDashboardController;
  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3E5FA).withOpacity(0.2),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedMenu01,
            color: Colors.white,
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.dashboard,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage("assets/images/profileimage.png"),
            ),
          ),
        ],
      ),
      drawer: VendorCustomDrawer(
        bodyController: vendorDashboardController,
      ),
      body: Stack(
        children: [DashboardPage()],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipPath(
                    clipper: CustomClipPath(),
                    child: Container(
                      height: 180,
                      color: kPrimaryColor,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Obx(
                      () => vendorHomeController.months.isNotEmpty &&
                              vendorHomeController.amounts.isNotEmpty
                          ? Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: defaultPadding),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(16)),
                              child: Container(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.width *
                                    0.80 *
                                    0.75,
                                padding: EdgeInsets.symmetric(
                                    horizontal: getProportionateScreenWidth(15),
                                    vertical: getProportionateScreenWidth(15)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .myOrders,
                                          style: TextStyle(
                                              fontFamily: 'poppins',
                                              fontWeight: FontWeight.w600,
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      14)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenWidth(15),
                                    ),
                                    Obx(
                                      () => vendorHomeController
                                              .months.isNotEmpty
                                          ? Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: LineChartContent(
                                                  labels: vendorHomeController
                                                      .months,
                                                  spots: List<FlSpot>.generate(
                                                    vendorHomeController
                                                        .amounts.length,
                                                    (index) => FlSpot(
                                                      index
                                                          .toDouble(), // X-axis value (index)
                                                      double.tryParse(
                                                              vendorHomeController
                                                                  .amounts[
                                                                      index]
                                                                  .toString()) ??
                                                          5, // Y-axis value
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : SizedBox(),
                                    )
                                  ],
                                ),
                              ))
                          : const SizedBox(),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.thisMonth,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => _buildStatCard(
                              image: 'assets/images/vendor/gross_sales.png',
                              title:
                                  "${AppLocalizations.of(context)!.currency}${convertToLocalizedNumber(vendorHomeController.grossSales.toString(), context)}",
                              subtitle:
                                  AppLocalizations.of(context)!.grossSales,
                              percentage: _formatPercentageWithArrow(
                                  vendorHomeController.grossSalesIncrease.value,
                                  context),
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                            child: Obx(
                          () => _buildStatCard(
                            image: 'assets/images/vendor/earnings.png',
                            title:
                                "${AppLocalizations.of(context)!.currency}${convertToLocalizedNumber(vendorHomeController.averageOrderValue.toString(), context)}",
                            subtitle:
                                AppLocalizations.of(context)!.averageSales,
                            percentage: _formatPercentageWithArrow(
                                vendorHomeController.averageOrderIncrease.value,
                                context),
                            color: Colors.green,
                          ),
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(() => _buildStatCard(
                                image:
                                    'assets/images/vendor/total_products.png',
                                title:
                                    "${convertToLocalizedNumber(vendorHomeController.totalProducts.toString(), context)}",
                                subtitle:
                                    AppLocalizations.of(context)!.totalProducts,
                                percentage: _formatPercentageWithArrow(
                                    vendorHomeController.productsIncrease.value,
                                    context),
                                color: Colors.orange,
                              )),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Obx(() => _buildStatCard(
                                image: 'assets/images/vendor/total_orders.png',
                                title:
                                    "${convertToLocalizedNumber(vendorHomeController.totalOrders.toString(), context)}",
                                subtitle:
                                    AppLocalizations.of(context)!.totalOrders,
                                percentage: _formatPercentageWithArrow(
                                    vendorHomeController.ordersIncrease.value,
                                    context),
                                color: Colors.purple,
                              )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Obx(
                      () => Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.recentOrders,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              GestureDetector(
                                onTap: () {
                                  vendorDashboardController.updateIndex(2);
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.viewAll,
                                  style: TextStyle(color: kPrimaryColor),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ListView.separated(
                              shrinkWrap: true,
                              primary: false,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return _buildOrderCard(
                                    orderDetails:
                                        vendorOrdersController.myOrders[index],
                                    context: context);
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                    height: 0,
                                  ),
                              itemCount:
                                  vendorOrdersController.myOrders.length),
                          SizedBox()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String image,
    required String title,
    required String subtitle,
    required String percentage,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    image,
                    scale: 1.3,
                  ),
                  Spacer(),
                  Text(
                    percentage,
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(
      {required Order orderDetails, required BuildContext context}) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${orderDetails.number}',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${formatDate(DateTime.parse(orderDetails.createdAt!), AppLocalizations.of(context)!.localeName)}',
                      style: TextStyle(color: kCardDescColor, fontSize: 14),
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.currency} ${convertToLocalizedNumber(orderDetails.totalPrice.toString(), context)}',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                    Text(
                      '(${convertToLocalizedNumber(orderDetails.items!.length.toString(), context)}) ${AppLocalizations.of(context)!.cartItems(orderDetails.items!.length)}',
                      style: TextStyle(fontSize: 13, color: kCardDescColor),
                    ),
                  ],
                ),
              ],
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.customerName,
                          style: TextStyle(color: kCardDescColor, fontSize: 14),
                        ),
                        Text(
                          '${orderDetails.customer!.name}',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 5),
                        Text(
                          AppLocalizations.of(context)!.orderStatus,
                          style: TextStyle(color: kCardDescColor, fontSize: 14),
                        ),
                        Text(
                          orderDetails.status!.localizedLabel(context),
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ]),
                  Image.asset('assets/images/vendor/invoice.png')
                ])
          ],
        ));
  }

  String _formatPercentageWithArrow(double rxValue, BuildContext context) {
    final value =
        double.tryParse(rxValue.toString()) ?? 0; // Safely parse to double
    final localizedValue =
        convertToLocalizedNumber(value.abs().toString(), context);
    if (value >= 0) {
      // Positive: Show up arrow
      return "↑ $localizedValue%";
    } else {
      // Negative: Show down arrow
      return "↓ $localizedValue%";
    }
  }
}
