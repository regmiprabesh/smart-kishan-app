import 'package:smart_kishan/controllers/CropInfoController.dart';
import 'package:smart_kishan/controllers/auth_controller.dart';
import 'package:smart_kishan/controllers/buy_products_controller.dart';
import 'package:smart_kishan/controllers/buyers_group_controller.dart';
import 'package:smart_kishan/controllers/chart_controller.dart';
import 'package:smart_kishan/controllers/crop_category_controller.dart';
import 'package:smart_kishan/controllers/daily_activity_controller.dart';
import 'package:smart_kishan/controllers/delivery_address_controller.dart';
import 'package:smart_kishan/controllers/expense_controller.dart';
import 'package:smart_kishan/controllers/farmland_controller.dart';
import 'package:smart_kishan/controllers/income_controller.dart';
import 'package:smart_kishan/controllers/kalimati_price_controller.dart';
import 'package:smart_kishan/controllers/note_controller.dart';
import 'package:smart_kishan/controllers/otp_controller.dart';
import 'package:smart_kishan/controllers/product_cart_controller.dart';
import 'package:smart_kishan/controllers/product_controller.dart';
import 'package:smart_kishan/controllers/customer_order_controller.dart';
import 'package:smart_kishan/controllers/search_history_controller.dart';
import 'package:smart_kishan/controllers/sell_product_controller.dart';
import 'package:smart_kishan/controllers/subsidy_controller..dart';
import 'package:smart_kishan/controllers/user_controller.dart';
import 'package:smart_kishan/controllers/vendor_home_controller.dart';
import 'package:smart_kishan/controllers/vendor_order_controller.dart';
import 'package:smart_kishan/controllers/weather_controller.dart';
import 'package:smart_kishan/controllers/banner_controller.dart';
import 'package:smart_kishan/controllers/customer_dashboard_controller.dart';
import 'package:smart_kishan/controllers/vendor_dashboard_controller.dart';

OTPController otpController = OTPController.instance;
AuthController authController = AuthController.instance;

NoteController get noteController => NoteController.instance;
ProductController get productController => ProductController.instance;
DailyActivityController get dailyActivityController =>
    DailyActivityController.instance;
IncomeController get incomeController => IncomeController.instance;
ExpenseController get expenseController => ExpenseController.instance;
ChartController get chartController => ChartController.instance;
FarmlandController get farmlandController => FarmlandController.instance;
WeatherController get weatherController => WeatherController.instance;
SubsidyController get subsidyController => SubsidyController.instance;

UserController userController = UserController.instance;
CropInfocontroller cropInfoController = CropInfocontroller.instance;
BuyersGroupController buyersGroupController = BuyersGroupController.instance;
SellProductController sellProductController = SellProductController.instance;
BannerController bannerController = BannerController.instance;
CropCategoryController cropCategoryController = CropCategoryController.instance;
BuyProductsController buyProductsController = BuyProductsController.instance;
ProductCartController productCartController = ProductCartController.instance;
CustomerDashboardController customerDashboardController =
    CustomerDashboardController.instance;
SearchHistoryController searchHistoryController =
    SearchHistoryController.instance;
DeliveryAddressController deliveryAddressController =
    DeliveryAddressController.instance;
CustomerOrdersController customerOrdersController =
    CustomerOrdersController.instance;
VendorDashboardController vendorDashboardController =
    VendorDashboardController.instance;
VendorHomeController vendorHomeController = VendorHomeController.instance;
VendorOrdersController vendorOrdersController = VendorOrdersController.instance;
KalimatiPriceController kalimatiPriceController =
    KalimatiPriceController.instance;
