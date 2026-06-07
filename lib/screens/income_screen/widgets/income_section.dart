import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/models/activity.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/size_config.dart';

class IncomeSection extends StatelessWidget {
  const IncomeSection({super.key});

  Widget _buildIncomeItem(Activity activity, DateFormat dateFormat) {
    return Container(
      margin: EdgeInsets.only(bottom: getProportionateScreenWidth(8)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          splashColor: kPrimaryColor.withOpacity(0.1),
          highlightColor: kPrimaryColor.withOpacity(0.05),
          onTap: () {
            dailyActivityController.selectedActivity(activity);
            dailyActivityController.isEdit(true);
            Get.toNamed(AppRoute.addDailyActivityScreen);
          },
          child: Padding(
            padding: EdgeInsets.all(getProportionateScreenWidth(12)),
            child: Row(
              children: [
                // Icon
                Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.arrow_downward,
                    color: kPrimaryColor,
                    size: getProportionateScreenWidth(18),
                  ),
                ),
                SizedBox(width: getProportionateScreenWidth(12)),

                // Title and Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.title ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: getProportionateScreenWidth(13),
                          color: Colors.grey.shade900,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: getProportionateScreenWidth(2)),
                      Text(
                        activity.date != null
                            ? dateFormat.format(DateTime.parse(activity.date!))
                            : 'No Date Found',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: getProportionateScreenWidth(11),
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Amount
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(10),
                    vertical: getProportionateScreenWidth(6),
                  ),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'रू ${activity.income?.toStringAsFixed(2) ?? '0.00'}',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: getProportionateScreenWidth(13),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenWidth(40),
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(getProportionateScreenWidth(20)),
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.account_balance_wallet_outlined,
              size: getProportionateScreenWidth(40),
              color: kPrimaryColor.withOpacity(0.5),
            ),
          ),
          SizedBox(height: getProportionateScreenWidth(12)),
          Text(
            'तपाईंको आय इतिहास खाली छ!',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: getProportionateScreenWidth(13),
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateOnlyFormat = DateFormat("EEEE, dd MMMM");

    return Obx(() {
      List<Activity> incomeActivities =
          incomeController.activities.where((e) => e.income != null).toList();

      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.trending_down,
                    color: kPrimaryColor,
                    size: getProportionateScreenWidth(18),
                  ),
                ),
                SizedBox(width: getProportionateScreenWidth(10)),
                Text(
                  'मेरो आम्दानी',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: getProportionateScreenWidth(15),
                    color: Colors.grey.shade900,
                  ),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenWidth(12)),

            // Content Container
            Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(12)),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                borderRadius: BorderRadius.circular(16),
              ),
              child: incomeActivities.isNotEmpty
                  ? ListView.builder(
                      itemCount: incomeActivities.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => _buildIncomeItem(
                        incomeActivities[index],
                        dateOnlyFormat,
                      ),
                    )
                  : _buildEmptyState(),
            ),
          ],
        ),
      );
    });
  }
}
