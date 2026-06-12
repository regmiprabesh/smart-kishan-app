import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/models/activity.dart';

class ExpenseController extends GetxController {
  static ExpenseController get instance => Get.find();

  static const int _dayCount = 7;
  static const int _monthCount = 7;
  static const int _yearCount = 5;

  final RxList<Activity> activities = <Activity>[].obs;
  final RxList<Activity> expenseActivities = <Activity>[].obs;

  // Axis labels (Nepali) for the currently selected filter.
  final RxList<String> daysName = <String>[].obs;
  final RxList<String> monthsName = <String>[].obs;
  final RxList<String> yearsName = <String>[].obs;
  final RxList<String> labels = <String>[].obs;

  // Bucket keys that line up 1:1 with the label lists above.
  final List<String> _dayKeys = [];
  final List<String> _monthKeys = [];
  final List<String> _yearKeys = [];

  // Plot output.
  final RxList<FlSpot> plots = <FlSpot>[].obs;

  final RxDouble minPlotX = 0.0.obs;
  final RxDouble maxPlotX = 0.0.obs;
  final RxDouble minPlotY = 0.0.obs;
  final RxDouble maxPlotY = 0.0.obs;

  final RxString selectedFilter = 'Daily'.obs;

  // Date formatters reused across rebuilds.
  static final DateFormat _dayKeyFmt = DateFormat('yyyy-MM-dd');
  static final DateFormat _monthKeyFmt = DateFormat('yyyy-MM');
  static final DateFormat _yearKeyFmt = DateFormat('yyyy');

  @override
  void onInit() {
    super.onInit();
    _buildDays();
    _buildMonths();
    _buildYears();
    getActivities(selectedFilter.value);
  }

  //  Bucket builders

  void _buildDays() {
    daysName.clear();
    _dayKeys.clear();

    final now = DateTime.now();
    final labelFmt = DateFormat('E', 'ne_NP');

    for (var i = _dayCount - 1; i >= 0; i--) {
      final day = DateTime(now.year, now.month, now.day - i);
      daysName.add(labelFmt.format(day));
      _dayKeys.add(_dayKeyFmt.format(day));
    }
  }

  void _buildMonths() {
    monthsName.clear();
    _monthKeys.clear();

    final now = DateTime.now();
    final labelFmt = DateFormat('MMM', 'ne_NP');

    // Walk backwards from the current month. DateTime normalises a month
    // index of 0 or below, so `now.month - i` safely rolls into prior years.
    for (var i = _monthCount - 1; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i);
      monthsName.add(labelFmt.format(month));
      _monthKeys.add(_monthKeyFmt.format(month));
    }
  }

  void _buildYears() {
    yearsName.clear();
    _yearKeys.clear();

    final currentYear = DateTime.now().year;
    for (var i = _yearCount - 1; i >= 0; i--) {
      final year = currentYear - i;
      yearsName.add(year.toString());
      _yearKeys.add(year.toString());
    }
  }

  //  Aggregation

  /// Sums expense for every activity that falls into each bucket, returning
  /// one [FlSpot] per bucket (X = bucket index, Y = summed value).
  List<FlSpot> _plot(
    List<Activity> data,
    List<String> bucketKeys,
    DateFormat keyFmt,
  ) {
    final grouped = groupBy<Activity, String>(
      data.where((a) => a.date != null),
      (a) {
        final dt = DateTime.tryParse(a.date!);
        // Unparseable dates fall into an empty key that matches no bucket.
        return dt == null ? '' : keyFmt.format(dt.toLocal());
      },
    );

    return [
      for (var i = 0; i < bucketKeys.length; i++)
        FlSpot(
          i.toDouble(),
          (grouped[bucketKeys[i]] ?? const <Activity>[])
              .fold<double>(0.0, (sum, a) => sum + (a.expense ?? 0)),
        ),
    ];
  }

  double _peak(List<FlSpot> spots) =>
      spots.fold<double>(0.0, (max, s) => s.y > max ? s.y : max);

  void _updatePlotBounds(List<String> keys, List<FlSpot> spots) {
    minPlotX.value = 0;
    maxPlotX.value = (keys.length - 1).toDouble();
    minPlotY.value = 0;
    maxPlotY.value = _peak(spots);
  }

  //  Public entry point

  Future<void> getActivities(String filter) async {
    try {
      selectedFilter.value = filter;
      activities.assignAll(dailyActivityController.activities);

      final expense = activities.where((a) => a.expense != null).toList();
      expenseActivities.assignAll(expense);

      late final List<String> keys;
      late final DateFormat keyFmt;

      switch (filter) {
        case 'Monthly':
          _buildMonths();
          keys = _monthKeys;
          keyFmt = _monthKeyFmt;
          labels.assignAll(monthsName);
          break;
        case 'Yearly':
          _buildYears();
          keys = _yearKeys;
          keyFmt = _yearKeyFmt;
          labels.assignAll(yearsName);
          break;
        case 'Daily':
        default:
          _buildDays();
          keys = _dayKeys;
          keyFmt = _dayKeyFmt;
          labels.assignAll(daysName);
      }

      final spots = _plot(expense, keys, keyFmt);
      plots.assignAll(spots);
      _updatePlotBounds(keys, spots);
    } catch (e) {
      debugPrint('ExpenseController.getActivities error: $e');
    }
  }
}
