import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/helpers/l10n.dart'; // localizedNumber — your working import
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class LineChartContent extends StatelessWidget {
  const LineChartContent({
    super.key,
    required this.incomeSpots,
    required this.expenseSpots,
    required this.labelDates,
    required this.filter,
  });

  final List<DateTime> labelDates;
  final String filter;
  final List<FlSpot> incomeSpots;
  final List<FlSpot> expenseSpots;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Only the day/month NAMES need this — digits are handled by localizedNumber.
    final intlLocale = Localizations.localeOf(context).languageCode == 'ne'
        ? 'ne_NP'
        : 'en_US';

    // Plain strings; digit localization happens in the callbacks below.
    String formatLabel(DateTime d) {
      switch (filter) {
        case 'Monthly':
          return DateFormat('MMM', intlLocale).format(d);
        case 'Yearly':
          return d.year.toString();
        case 'Daily':
        default:
          return DateFormat('E', intlLocale).format(d);
      }
    }

    final labels = labelDates.map(formatLabel).toList();

    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipColor: (LineBarSpot group) => kPrimaryColor,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                TextAlign textAlign = TextAlign.center;
                if (barSpot.x.toInt() == 0) {
                  textAlign = TextAlign.left;
                }
                if (barSpot.x.toInt() == labels.length - 1) {
                  textAlign = TextAlign.right;
                }
                return LineTooltipItem(
                  '${localizedNumber(labels[barSpot.x.toInt()])}\n',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: '${l10n.currencySymbol} ',
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(
                      text: localizedNumber(
                        barSpot.y == barSpot.y.roundToDouble()
                            ? barSpot.y.toInt()
                            : barSpot.y,
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
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
          getDrawingHorizontalLine: (value) => FlLine(
            color: kCardDescColor.withOpacity(0.3),
            strokeWidth: 1,
          ),
        ),
        minX: 0,
        minY: 0,
        maxX: chartController.maxPlotX.value,
        maxY: chartController.maxPlotY.value,
        lineBarsData: [
          LineChartBarData(
            dotData: FlDotData(show: false),
            curveSmoothness: 0.3,
            color: kPrimaryColor,
            isCurved: true,
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(show: false),
            spots: incomeSpots,
          ),
          LineChartBarData(
            dotData: FlDotData(show: false),
            curveSmoothness: 0.3,
            color: kSecondaryColor,
            isCurved: true,
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(show: false),
            spots: expenseSpots,
          ),
        ],
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              interval: 1,
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) => _getTitles(value, meta, labels),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              reservedSize: 60,
              showTitles: true,
              getTitlesWidget: (value, meta) =>
                  _leftTitleWidgets(value, meta, l10n),
            ),
          ),
          rightTitles: AxisTitles(),
          topTitles: AxisTitles(),
        ),
      ),
    );
  }

  Widget _getTitles(double value, TitleMeta meta, List<String> labels) {
    final index = value.toInt();
    if (index < 0 || index >= labels.length) {
      return const SizedBox.shrink();
    }
    return SideTitleWidget(
      space: 30.0,
      meta: meta,
      // localizedNumber converts year digits; it's a no-op on day/month text.
      child: Text(
        localizedNumber(labels[index]),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: getProportionateScreenWidth(10),
        ),
      ),
    );
  }

  Widget _leftTitleWidgets(
      double value, TitleMeta meta, AppLocalizations l10n) {
    const style = TextStyle(
      fontSize: 11,
      color: Colors.black,
      fontWeight: FontWeight.w600,
    );
    final text = value == 0 ? '' : '${l10n.currencySymbol} $value';
    return SideTitleWidget(
      meta: meta,
      space: 10,
      child: Text(localizedNumber(text),
          style: style, textAlign: TextAlign.center),
    );
  }
}
