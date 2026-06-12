import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/screens/charts/widgets/line_chart_content.dart';
import 'package:smart_kishan/screens/charts/widgets/period_dropdown.dart';
import 'package:smart_kishan/screens/charts/widgets/product_list.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
        title: Text(
          l10n.chartScreenTitle,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Obx(() {
                final hasData = chartController.labelDates.isNotEmpty &&
                    chartController.incomePlots.isNotEmpty;

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
                                  l10n, chartController.selectedFilter.value),
                              style: TextStyle(
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: getProportionateScreenWidth(12),
                              ),
                            ),
                            PeriodDropdown(
                              selectedFilter:
                                  chartController.selectedFilter.value,
                              onUpdate: (String value) {
                                chartController.selectedFilter(value);
                                chartController.getActivities(value);
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: getProportionateScreenWidth(15)),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(top: 10),
                            child: LineChartContent(
                              labelDates: chartController.labelDates,
                              filter: chartController.selectedFilter.value,
                              incomeSpots: chartController.incomePlots,
                              expenseSpots: chartController.expensePlots,
                            ),
                          ),
                        ),
                        SizedBox(height: getProportionateScreenWidth(6)),
                        // Period range hint shown below the chart
                        Center(
                          child: Text(
                            _periodSubtitle(
                                l10n, chartController.selectedFilter.value),
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
              const ProductListSection(),
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
        return l10n.chartTitleMonthly;
      case 'Yearly':
        return l10n.chartTitleYearly;
      case 'Daily':
      default:
        return l10n.chartTitleDaily;
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
