import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/screens/charts/widgets/line_chart_content.dart';
import 'package:smart_kishan/screens/charts/widgets/period_dropdown.dart';
import 'package:smart_kishan/screens/charts/widgets/product_list.dart';
import 'package:smart_kishan/size_config.dart';

class ChartScreen extends StatelessWidget {
  ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
        title: const Text('लेखा चित्र',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            Obx(
              () => chartController.labels.isNotEmpty &&
                      chartController.incomePlots.isNotEmpty
                  ? Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: defaultPadding, horizontal: defaultPadding),
                      decoration: BoxDecoration(
                          // color: color,
                          boxShadow: [
                            BoxShadow(
                              color: kPrimaryColor.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.width * 0.95 * 0.70,
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(15),
                            vertical: getProportionateScreenWidth(15)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'आय/व्यय लेखा चित्र',
                                  style: TextStyle(
                                      fontFamily: 'poppins',
                                      fontWeight: FontWeight.w600,
                                      fontSize:
                                          getProportionateScreenWidth(14)),
                                ),
                                Obx(
                                  () => PeriodDropdown(
                                    selectedFilter:
                                        chartController.selectedFilter.value,
                                    onUpdate: (String value) {
                                      chartController.selectedFilter(value);
                                      chartController.getActivities(value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: getProportionateScreenWidth(15),
                            ),
                            Expanded(
                                child: Container(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: LineChartContent(
                                      labels: chartController.labels,
                                      incomeSpots: chartController.incomePlots,
                                      expenseSpots:
                                          chartController.expensePlots,
                                    )))
                          ],
                        ),
                      ))
                  : const SizedBox(),
            ),
            SizedBox(
              height: getProportionateScreenHeight(30),
            ),
            const ProductListSection()
          ],
        )),
      ),
    );
  }
}
