import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For formatting the date
import 'package:smart_kishan/controllers/kalimati_price_controller.dart';
import 'package:smart_kishan/helpers/l10n.dart';

class KalimatiPriceScreen extends StatelessWidget {
  String _formatDate(String? rawDate, String localeName) {
    if (rawDate == null || rawDate.isEmpty) return '';
    final dt = DateTime.tryParse(rawDate);
    if (dt == null) return rawDate;
    return DateFormat('EEEE, dd MMMM, yyyy', localeName).format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final KalimatiPriceController kalimatiPriceController =
        Get.find<KalimatiPriceController>();

    // Get the current date
    String formattedDate =
        _formatDate(DateTime.now().toString(), l10n.localeName);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(l10n.kalimatiPriceList),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(formattedDate, style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
      body: Obx(() {
        if (kalimatiPriceController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final kalimatiData = kalimatiPriceController.kalimatiData.value;

        if (kalimatiData == null ||
            kalimatiData.prices == null ||
            kalimatiData.prices!.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text(l10n.commodity)),
                DataColumn(label: Text(l10n.unit)),
                DataColumn(label: Text(l10n.minPrice)),
                DataColumn(label: Text(l10n.maxPrice)),
                DataColumn(label: Text(l10n.avgPrice)),
              ],
              rows: kalimatiData.prices!.map((price) {
                return DataRow(
                  cells: [
                    DataCell(Text(price.commodityname ?? 'Unknown')),
                    DataCell(Text(price.commodityunit ?? 'N/A')),
                    DataCell(Text(price.minprice ?? 'N/A')),
                    DataCell(Text(price.maxprice ?? 'N/A')),
                    DataCell(Text(price.avgprice ?? 'N/A')),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      }),
    );
  }
}
