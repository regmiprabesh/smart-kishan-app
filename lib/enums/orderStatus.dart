import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

enum OrderStatus {
  newOrder, // Using "newOrder" instead of "new" to avoid reserved keyword
  processing,
  shipped,
  delivered,
  cancelled,
}

extension OrderStatusExtension on OrderStatus {
  // Method to get the label
  String get label {
    switch (this) {
      case OrderStatus.newOrder:
        return 'Pending';
      case OrderStatus.processing:
        return 'Confirmed';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get rawValue {
    switch (this) {
      case OrderStatus.newOrder:
        return 'new'; // Matches Laravel enum case
      case OrderStatus.processing:
        return 'processing'; // Matches Laravel enum case
      case OrderStatus.shipped:
        return 'shipped'; // Matches Laravel enum case
      case OrderStatus.delivered:
        return 'delivered'; // Matches Laravel enum case
      case OrderStatus.cancelled:
        return 'cancelled'; // Matches Laravel enum case
    }
  }

  String localizedLabel(BuildContext context) {
    switch (this) {
      case OrderStatus.newOrder:
        return AppLocalizations.of(context)!.pending;
      case OrderStatus.processing:
        return AppLocalizations.of(context)!.confirmed;
      case OrderStatus.shipped:
        return AppLocalizations.of(context)!.shipped;
      case OrderStatus.delivered:
        return AppLocalizations.of(context)!.delivered;
      case OrderStatus.cancelled:
        return AppLocalizations.of(context)!.cancelled;
    }
  }

  // Method to get the color
  Color get color {
    switch (this) {
      case OrderStatus.newOrder:
        return Colors.blue;
      case OrderStatus.processing:
        return Colors.orange;
      case OrderStatus.shipped:
        return Colors.green.shade700;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  // Method to get the icon
  List<List<dynamic>> get icon {
    switch (this) {
      case OrderStatus.newOrder:
        return HugeIcons.strokeRoundedStars;
      case OrderStatus.processing:
        return HugeIcons.strokeRoundedPackageProcess;
      case OrderStatus.shipped:
        return HugeIcons.strokeRoundedShippingTruck01;
      case OrderStatus.delivered:
        return HugeIcons.strokeRoundedCheckmarkCircle01;
      case OrderStatus.cancelled:
        return HugeIcons.strokeRoundedCancelCircle;
    }
  }
}

extension OrderStatusFromString on String {
  OrderStatus toOrderStatus() {
    switch (this.toLowerCase()) {
      case 'new':
        return OrderStatus.newOrder;
      case 'processing':
        return OrderStatus.processing;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        throw Exception('Unknown Order Status: $this');
    }
  }
}
