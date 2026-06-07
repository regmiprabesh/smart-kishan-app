import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For formatting the date
import 'package:smart_kishan/controllers/kalimati_price_controller.dart';

class KalimatiPriceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final KalimatiPriceController kalimatiPriceController =
        Get.find<KalimatiPriceController>();

    // Get the current date
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Kalimati Prices'),
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
              columns: const [
                DataColumn(label: Text('Commodity')),
                DataColumn(label: Text('Unit')),
                DataColumn(label: Text('Min Price')),
                DataColumn(label: Text('Max Price')),
                DataColumn(label: Text('Avg Price')),
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
