import 'package:smart_kishan/routes/app_routes.dart';

class AppMode {
  static const String farmer = 'farmer';
  static const String buyer = 'buyer';
  static const String seller = 'seller';
}

String routeForMode(String? mode) {
  switch (mode) {
    case AppMode.buyer:
      return AppRoute.customerDashboard;
    case AppMode.seller:
      return AppRoute.vendorDashboard;
    case AppMode.farmer:
    default:
      return AppRoute.dashboard;
  }
}
