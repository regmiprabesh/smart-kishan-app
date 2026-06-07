import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/screens/charts/widgets/period_dropdown.dart';
import 'package:smart_kishan/screens/expense_screen/widgets/expense_section.dart';
import 'package:smart_kishan/screens/expense_screen/widgets/line_chart_content.dart';
import 'package:smart_kishan/size_config.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text('खर्च विश्लेषण',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            Obx(
              () => expenseController.labels.isNotEmpty &&
                      expenseController.plots.isNotEmpty
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
                                  'खर्च चार्ट',
                                  style: TextStyle(
                                      fontFamily: 'poppins',
                                      fontWeight: FontWeight.w600,
                                      fontSize:
                                          getProportionateScreenWidth(14)),
                                ),
                                Obx(
                                  () => PeriodDropdown(
                                    selectedFilter:
                                        expenseController.selectedFilter.value,
                                    onUpdate: (String value) {
                                      expenseController.selectedFilter(value);
                                      expenseController.getActivities(value);
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
                                      labels: expenseController.labels,
                                      spots: expenseController.plots,
                                    )))
                          ],
                        ),
                      ))
                  : const SizedBox(),
            ),
            SizedBox(
              height: getProportionateScreenHeight(30),
            ),
            const ExpenseSection()
          ],
        )),
      ),
    );
  }
}
