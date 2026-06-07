import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/size_config.dart';

class LineChartContent extends StatelessWidget {
  const LineChartContent(
      {super.key, required this.spots, required this.labels});
  final List<String> labels;
  final List<FlSpot> spots;
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipColor: (LineBarSpot group) => kPrimaryColor,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                TextAlign textAlign = TextAlign.center;
                if (flSpot.x.toInt() == 0) {
                  textAlign = TextAlign.left;
                }
                if (flSpot.x.toInt() == labels.length - 1) {
                  textAlign = TextAlign.right;
                }

                return LineTooltipItem(
                  '${labels[flSpot.x.toInt()]}\n',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    const TextSpan(
                      text: 'रू. ',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(
                      text: flSpot.y.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const TextSpan(
                      text: ' खर्च',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                  textAlign: textAlign,
                );
              }).toList();
            },
          ),
        ),
        borderData: FlBorderData(border: const Border()),
        gridData: FlGridData(
          drawHorizontalLine: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: kCardDescColor,
              strokeWidth: 1,
            );
          },
        ),
        minX: 0,
        minY: 0,
        maxX: expenseController.maxPlotX.value,
        maxY: expenseController.maxPlotY.value,
        lineBarsData: [
          LineChartBarData(
              dotData: FlDotData(show: false),
              curveSmoothness: 0.3,
              color: kPrimaryColor,
              isCurved: true,
              barWidth: 3,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(show: false),
              spots: spots)
        ],
        titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                interval: 1,
                showTitles: true,
                reservedSize: 50,
                getTitlesWidget: getTitles,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 60,
                showTitles: true,
                getTitlesWidget: leftTitleWidgets,
              ),
            ),
            rightTitles: AxisTitles(),
            topTitles: AxisTitles()),
      ),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      fontWeight: FontWeight.w600,
      fontFamily: 'Poppins',
      fontSize: getProportionateScreenWidth(10),
    );

    return SideTitleWidget(
        space: 30.0,
        meta: meta,
        child: Text(
          labels[value.toInt()],
          style: style,
        ));
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
        fontSize: 10,
        color: Colors.black,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500);
    String text;
    switch (value.toInt()) {
      case 0:
        text = '';
        break;
      default:
        text = 'रू. $value';
    }
    return SideTitleWidget(
      meta: meta,
      space: 10,
      child: Text(text, style: style, textAlign: TextAlign.center),
    );
  }
}
