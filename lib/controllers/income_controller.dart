import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/models/activity.dart';
import 'package:smart_kishan/screens/daily_activity/services/local_activity_service.dart';

class IncomeController extends GetxController {
  static IncomeController instance = Get.find();

  RxList<Activity> activities = List<Activity>.empty(growable: true).obs;
  RxList<Activity> incomeActivities = List<Activity>.empty(growable: true).obs;

  final _localActivityService = LocalActivityService();
  RxList<Activity> profitableActivities =
      List<Activity>.empty(growable: true).obs;

  RxList<String> daysName = List<String>.empty(growable: true).obs;
  RxList<String> monthsName = List<String>.empty(growable: true).obs;
  RxList<String> yearsName = List<String>.empty(growable: true).obs;

  RxDouble minPlotX = 0.00.obs;
  RxDouble maxPlotX = 0.00.obs;
  RxDouble minPlotY = 0.00.obs;
  RxDouble maxPlotY = 0.00.obs;

  RxList<FlSpot> plots = List<FlSpot>.empty(growable: true).obs;
  RxList<String> labels = List<String>.empty(growable: true).obs;

  RxString selectedFilter = 'Daily'.obs;

  @override
  void onInit() async {
    super.onInit();
    await _localActivityService.init();
    await getDays();
    await getMonths();
    await getYears();
    getActivities(selectedFilter.value);
  }

  getDays() async {
    final now = DateTime.now();
    final format = DateFormat('E', 'ne_NP');
    for (var i = 1; i <= 7; i++) {
      final nextDay = now.add(Duration(days: i));
      String dayName = format.format(nextDay);
      daysName.add(dayName);
    }
  }

  getMonths() async {
    final now = DateTime.now();
    final format = DateFormat('MMM', 'ne_NP');

    for (var i = 6; i <= 12; i++) {
      final nextMonth = DateTime(now.year, now.month + i);
      String monthName = format.format(nextMonth);
      monthsName.add(monthName);
    }
  }

  getYears() async {
    int currentYear = DateTime.now().year;
    for (int i = 4; i > 0; i--) {
      yearsName.add((currentYear - i).toString());
    }
    yearsName.add(currentYear.toString());
  }

  Future<List<FlSpot>> incomeByMonth(List<Activity> data) async {
    var groupedData = groupBy<Activity, String>(
      data,
      (dataPoint) => DateFormat('MMM', 'ne_NP')
          .format(DateTime.tryParse(dataPoint.date!)!),
    );
    var allMonthsData = <String, List<Activity>>{};
    List<double> incomeList = [];
    List<FlSpot> monthlyPlots = [];
    for (var month = 1; month <= 6; month++) {
      var monthName = DateFormat('MMM', 'ne_NP').format(DateTime(2022, month));
      allMonthsData[monthName] = groupedData[monthName] ?? [];
    }
    for (var month in monthsName) {
      if (allMonthsData[month] != null && allMonthsData[month]!.isNotEmpty) {
        List<Activity> activityInMonth = allMonthsData[month]!.toList();
        double sum = 0;
        for (int i = 0; i < activityInMonth.length; i++) {
          sum += activityInMonth[i].income!;
        }
        incomeList.add(sum);
      } else {
        incomeList.add(0);
      }
    }
    for (int j = 0; j < incomeList.length; j++) {
      monthlyPlots.add(FlSpot(j.toDouble(), incomeList[j]));
    }
    minPlotX(0);
    maxPlotX(monthsName.length - 1);
    minPlotY(0);
    maxPlotY(incomeList.max.toDouble());
    return monthlyPlots;
  }

  Future<List<FlSpot>> incomeByDays(List<Activity> data) async {
    var groupedData = groupBy<Activity, String>(
      data,
      (dataPoint) =>
          DateFormat('E', 'ne_NP').format(DateTime.tryParse(dataPoint.date!)!),
    );
    var allDaysData = <String, List<Activity>>{};
    List<double> incomeList = [];
    List<FlSpot> dailyPlots = [];
    for (var day = 1; day <= 6; day++) {
      var dayName = DateFormat('E', 'ne_NP').format(DateTime(2022, day));
      allDaysData[dayName] = groupedData[dayName] ?? [];
    }
    for (var day in daysName) {
      if (allDaysData[day] != null && allDaysData[day]!.isNotEmpty) {
        List<Activity> activityInDay = allDaysData[day]!.toList();
        double sum = 0;
        for (int i = 0; i < activityInDay.length; i++) {
          sum += activityInDay[i].income!;
        }
        incomeList.add(sum);
      } else {
        incomeList.add(0);
      }
    }
    for (int j = 0; j < incomeList.length; j++) {
      dailyPlots.add(FlSpot(j.toDouble(), incomeList[j]));
    }
    minPlotX(0);
    maxPlotX(daysName.length - 1);
    minPlotY(0);
    maxPlotY(incomeList.max.toDouble());
    return dailyPlots;
  }

  Future<List<FlSpot>> incomeByYear(List<Activity> data) async {
    int currentYear = DateTime.now().year;
    Map<String, List<Activity>> groupedData = groupBy(data, (item) {
      DateTime date = DateTime.parse(item.date!);
      int year = date.year;
      return (((year - currentYear) ~/ 5) * 5 + currentYear).toString();
    });
    List<double> incomeList = [];
    List<FlSpot> yearlyPlots = [];
    for (var year in yearsName) {
      if (groupedData[year] != null && groupedData[year]!.isNotEmpty) {
        List<Activity> activityInYear = groupedData[year]!.toList();
        double sum = 0;
        for (int i = 0; i < activityInYear.length; i++) {
          sum += activityInYear[i].income!;
        }
        incomeList.add(sum);
      } else {
        incomeList.add(0);
      }
    }
    for (int j = 0; j < incomeList.length; j++) {
      yearlyPlots.add(FlSpot(j.toDouble(), incomeList[j]));
    }
    minPlotX(0);
    maxPlotX(yearsName.length - 1);
    minPlotY(0);
    maxPlotY(incomeList.max.toDouble());
    return yearlyPlots;
  }

  getActivities(String filter) async {
    try {
      // var data = await _localActivityService.readActivities();
      // activities.assignAll(activityListFromJson(jsonEncode(data)));
      var data = dailyActivityController.activities;
      activities.assignAll(data);
      List<Activity> incomeActivity =
          activities.where((activity) => activity.income != null).toList();
      incomeActivities(incomeActivity);
      print(activities);
      if (filter == 'Daily') {
        plots.value = await incomeByDays(incomeActivity);
        labels.value = daysName;
      }
      if (filter == 'Monthly') {
        plots.value = await incomeByMonth(incomeActivity);
        labels.value = monthsName;
      }
      if (filter == 'Yearly') {
        plots.value = await incomeByYear(incomeActivity);
        labels.value = yearsName;
      }
    } catch (e) {
      print(e);
    } finally {}
  }
}
