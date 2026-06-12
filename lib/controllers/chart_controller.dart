import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/models/activity.dart';

class ChartController extends GetxController {
  static ChartController get instance => Get.find();

  static const int _dayCount = 7;
  static const int _monthCount = 7;
  static const int _yearCount = 5;

  final RxList<Activity> activities = <Activity>[].obs;

  // Bucket keys (ASCII, locale-independent) — used only for aggregation.
  final List<String> _dayKeys = [];
  final List<String> _monthKeys = [];
  final List<String> _yearKeys = [];

  // Bucket reference dates — formatted into labels at the widget layer,
  // so the labels react to locale changes.
  final List<DateTime> _dayDates = [];
  final List<DateTime> _monthDates = [];
  final List<DateTime> _yearDates = [];

  // Active filter's dates, consumed by the chart widget.
  final RxList<DateTime> labelDates = <DateTime>[].obs;

  // Plot output
  final RxList<FlSpot> incomePlots = <FlSpot>[].obs;
  final RxList<FlSpot> expensePlots = <FlSpot>[].obs;

  final RxDouble minPlotX = 0.0.obs;
  final RxDouble maxPlotX = 0.0.obs;
  final RxDouble minPlotY = 0.0.obs;
  final RxDouble maxPlotY = 0.0.obs;

  final RxDouble maxIncome = 0.0.obs;
  final RxDouble maxExpense = 0.0.obs;

  final RxString selectedFilter = 'Daily'.obs;

  // ASCII bucket-key formatters reused across rebuilds.
  static final DateFormat _dayKeyFmt = DateFormat('yyyy-MM-dd');
  static final DateFormat _monthKeyFmt = DateFormat('yyyy-MM');
  static final DateFormat _yearKeyFmt = DateFormat('yyyy');

  @override
  void onInit() {
    super.onInit();
    getActivities(selectedFilter.value);
  }

  // Bucket builders — produce ASCII keys + reference dates only, no labels.
  void _buildDays() {
    _dayKeys.clear();
    _dayDates.clear();

    final now = DateTime.now();
    for (var i = _dayCount - 1; i >= 0; i--) {
      final day = DateTime(now.year, now.month, now.day - i);
      _dayKeys.add(_dayKeyFmt.format(day));
      _dayDates.add(day);
    }
  }

  void _buildMonths() {
    _monthKeys.clear();
    _monthDates.clear();

    final now = DateTime.now();
    // DateTime normalises a month index of 0 or below, so `now.month - i`
    // safely rolls into prior years.
    for (var i = _monthCount - 1; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i);
      _monthKeys.add(_monthKeyFmt.format(month));
      _monthDates.add(month);
    }
  }

  void _buildYears() {
    _yearKeys.clear();
    _yearDates.clear();

    final currentYear = DateTime.now().year;
    for (var i = _yearCount - 1; i >= 0; i--) {
      final year = currentYear - i;
      _yearKeys.add(year.toString());
      _yearDates.add(DateTime(year));
    }
  }

  /// Sums [valueOf] for every activity that falls into each bucket, returning
  /// one [FlSpot] per bucket (X = bucket index, Y = summed value).
  List<FlSpot> _plot(
    List<Activity> data,
    List<String> bucketKeys,
    DateFormat keyFmt,
    double Function(Activity) valueOf,
  ) {
    final grouped = groupBy<Activity, String>(
      data.where((a) => a.date != null),
      (a) {
        final dt = DateTime.tryParse(a.date!);
        return dt == null ? '' : keyFmt.format(dt.toLocal());
      },
    );

    return [
      for (var i = 0; i < bucketKeys.length; i++)
        FlSpot(
          i.toDouble(),
          (grouped[bucketKeys[i]] ?? const <Activity>[])
              .fold<double>(0.0, (sum, a) => sum + valueOf(a)),
        ),
    ];
  }

  double _peak(List<FlSpot> spots) =>
      spots.fold<double>(0.0, (max, s) => s.y > max ? s.y : max);

  Future<void> getActivities(String filter) async {
    try {
      selectedFilter.value = filter;
      activities.assignAll(dailyActivityController.activities);

      final income = activities.where((a) => a.income != null).toList();
      final expense = activities.where((a) => a.expense != null).toList();

      late final List<String> keys;
      late final DateFormat keyFmt;

      switch (filter) {
        case 'Monthly':
          _buildMonths();
          keys = _monthKeys;
          keyFmt = _monthKeyFmt;
          labelDates.assignAll(_monthDates);
          break;
        case 'Yearly':
          _buildYears();
          keys = _yearKeys;
          keyFmt = _yearKeyFmt;
          labelDates.assignAll(_yearDates);
          break;
        case 'Daily':
        default:
          _buildDays();
          keys = _dayKeys;
          keyFmt = _dayKeyFmt;
          labelDates.assignAll(_dayDates);
      }

      incomePlots.assignAll(_plot(income, keys, keyFmt, (a) => a.income ?? 0));
      expensePlots
          .assignAll(_plot(expense, keys, keyFmt, (a) => a.expense ?? 0));

      maxIncome.value = _peak(incomePlots);
      maxExpense.value = _peak(expensePlots);

      minPlotX.value = 0;
      maxPlotX.value = (keys.length - 1).toDouble();
      minPlotY.value = 0;
      maxPlotY.value = maxIncome.value > maxExpense.value
          ? maxIncome.value
          : maxExpense.value;
    } catch (e) {
      debugPrint('getActivities error: $e');
    }
  }
}
