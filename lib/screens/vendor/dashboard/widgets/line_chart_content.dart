import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class LineChartContent extends StatelessWidget {
  const LineChartContent({
    super.key,
    required this.spots,
    required this.labels,
  });

  final List<String> labels;
  final List<FlSpot> spots;

  @override
  Widget build(BuildContext context) {
    // Validate that the number of labels matches the number of spots
    assert(spots.length <= labels.length,
        "The number of spots cannot exceed the number of labels.");

    double minY = spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
    double maxY = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);

    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipColor: (LineBarSpot group) => kPrimaryColor,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots
                  .map((barSpot) {
                    final flSpot = barSpot;
                    final int index = flSpot.x.toInt();
                    // Safeguard against out-of-bounds indices
                    if (index < 0 || index >= labels.length) return null;

                    TextAlign textAlign = TextAlign.center;
                    if (index == 0) {
                      textAlign = TextAlign.left;
                    }
                    if (index == labels.length - 1) {
                      textAlign = TextAlign.right;
                    }

                    return LineTooltipItem(
                      '${getLocalizedMonth(labels[index], context)}\n',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(context)!.currency,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextSpan(
                          text: convertToLocalizedNumber(
                              flSpot.y.toString(), context),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextSpan(
                          text: ' ${AppLocalizations.of(context)!.income}',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                      textAlign: textAlign,
                    );
                  })
                  .where((item) => item != null)
                  .toList();
            },
          ),
        ),
        borderData: FlBorderData(border: const Border()),
        gridData: FlGridData(
          drawHorizontalLine: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: kCardDescColor.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
        ),
        minX: 0,
        minY: 0,
        maxX: (spots.length - 1)
            .toDouble(), // Constrain maxX to the number of spots
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            dotData: FlDotData(show: false),
            curveSmoothness: 0.3,
            color: kPrimaryColor,
            isCurved: true,
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(show: false),
            spots: spots,
          )
        ],
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
                interval: 1,
                showTitles: true,
                reservedSize: 50,
                getTitlesWidget: (value, meta) =>
                    getTitles(value, meta, context)),
          ),
          // leftTitles: AxisTitles(
          //   sideTitles: SideTitles(
          //       reservedSize: 60,
          //       showTitles: true,
          //       getTitlesWidget: (value, meta) =>
          //           leftTitleWidgets(value, meta, context)),
          // ),
          leftTitles: AxisTitles(),
          rightTitles: AxisTitles(),
          topTitles: AxisTitles(),
        ),
      ),
    );
  }

  Widget getTitles(double value, TitleMeta meta, BuildContext context) {
    final index = value.toInt();

    // Safeguard against invalid indices
    if (index < 0 || index >= labels.length) return SizedBox.shrink();

    final style = TextStyle(
      fontWeight: FontWeight.w600,
      fontFamily: 'Poppins',
      fontSize: getProportionateScreenWidth(10),
    );

    return SideTitleWidget(
      space: 30.0,
      meta: meta,
      child: Text(
        getLocalizedMonth(labels[index], context),
        style: style,
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta, BuildContext context) {
    const style = TextStyle(
      fontSize: 12,
      color: Colors.black,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w500,
    );

    // Handle zero value case
    if (value == 0) {
      return SizedBox.shrink(); // Avoid showing '0' at the start
    }

    // Format currency and numbers
    final localizedCurrency =
        AppLocalizations.of(context)!.currency; // e.g., "रु"
    final localizedValue =
        convertToLocalizedNumber(value.toInt().toString(), context);
    final formattedText =
        "$localizedCurrency $localizedValue"; // Combine currency and number

    return SideTitleWidget(
      meta: meta,
      space: 10,
      child: Text(
        formattedText,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }
}
