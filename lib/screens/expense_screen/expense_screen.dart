import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/screens/charts/widgets/period_dropdown.dart';
import 'package:smart_kishan/screens/expense_screen/widgets/expense_section.dart';
import 'package:smart_kishan/screens/expense_screen/widgets/line_chart_content.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          l10n.expenseAnalysis,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Obx(() {
                final hasData = expenseController.labels.isNotEmpty &&
                    expenseController.plots.isNotEmpty;

                if (!hasData) return const SizedBox();

                return Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: defaultPadding,
                    horizontal: defaultPadding,
                  ),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryColor.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width * 0.95 * 0.70,
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(15),
                      vertical: getProportionateScreenWidth(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _chartTitle(
                                  l10n, expenseController.selectedFilter.value),
                              style: TextStyle(
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: getProportionateScreenWidth(14),
                              ),
                            ),
                            PeriodDropdown(
                              selectedFilter:
                                  expenseController.selectedFilter.value,
                              onUpdate: (String value) {
                                expenseController.selectedFilter(value);
                                expenseController.getActivities(value);
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: getProportionateScreenWidth(15)),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(top: 10),
                            child: LineChartContent(
                              labels: expenseController.labels,
                              spots: expenseController.plots,
                            ),
                          ),
                        ),
                        SizedBox(height: getProportionateScreenWidth(6)),
                        // Period range hint shown below the chart
                        Center(
                          child: Text(
                            _periodSubtitle(
                                l10n, expenseController.selectedFilter.value),
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: getProportionateScreenWidth(11),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(height: getProportionateScreenHeight(30)),
              const ExpenseSection(),
            ],
          ),
        ),
      ),
    );
  }

  // Chart title changes based on the selected period filter
  String _chartTitle(AppLocalizations l10n, String filter) {
    switch (filter) {
      case 'Monthly':
        return l10n.expenseChartMonthly;
      case 'Yearly':
        return l10n.expenseChartYearly;
      case 'Daily':
      default:
        return l10n.expenseChartDaily;
    }
  }

  // Subtitle describes the visible range (last 7 days / 7 months / 5 years)
  String _periodSubtitle(AppLocalizations l10n, String filter) {
    switch (filter) {
      case 'Monthly':
        return l10n.last7Months;
      case 'Yearly':
        return l10n.last5Years;
      case 'Daily':
      default:
        return l10n.last7Days;
    }
  }
}
