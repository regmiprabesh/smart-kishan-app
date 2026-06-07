import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/screens/charts/widgets/period_dropdown.dart';
import 'package:smart_kishan/screens/income_screen/widgets/income_section.dart';
import 'package:smart_kishan/screens/income_screen/widgets/line_chart_content.dart';
import 'package:smart_kishan/size_config.dart';

class IncomeScreen extends StatelessWidget {
  IncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text('आम्दानी विश्लेषण',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            Obx(
              () => incomeController.labels.isNotEmpty &&
                      incomeController.plots.isNotEmpty
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
                          ], borderRadius: BorderRadius.circular(10)),
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
                                  'आमदानी चार्ट',
                                  style: TextStyle(
                                      fontFamily: 'poppins',
                                      fontWeight: FontWeight.w600,
                                      fontSize:
                                          getProportionateScreenWidth(14)),
                                ),
                                Obx(
                                  () => PeriodDropdown(
                                    selectedFilter:
                                        incomeController.selectedFilter.value,
                                    onUpdate: (String value) {
                                      incomeController.selectedFilter(value);
                                      incomeController.getActivities(value);
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
                                      labels: incomeController.labels,
                                      spots: incomeController.plots,
                                    )))
                          ],
                        ),
                      ))
                  : const SizedBox(),
            ),
            SizedBox(
              height: getProportionateScreenHeight(30),
            ),
            const IncomeSection()
          ],
        )),
      ),
    );
  }
}
