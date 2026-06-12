import 'package:get/route_manager.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/screens/auth/bindings/auth_binding.dart';
import 'package:smart_kishan/screens/auth/edit_profile_screen.dart';
import 'package:smart_kishan/screens/auth/forgot_password_screen.dart';
import 'package:smart_kishan/screens/auth/otp_verification_screen.dart';
import 'package:smart_kishan/screens/auth/phone_register_screen.dart';
import 'package:smart_kishan/screens/auth/reset_password_screen.dart';
import 'package:smart_kishan/screens/auth/signin_screen.dart';
import 'package:smart_kishan/screens/auth/signup_screen.dart';
import 'package:smart_kishan/screens/auth/update_location_screen.dart';
import 'package:smart_kishan/screens/auth/update_password_screen.dart';
import 'package:smart_kishan/screens/buyers_group/add_buyers_group_screen.dart';
import 'package:smart_kishan/screens/buyers_group/buyers_group_screen.dart';
import 'package:smart_kishan/screens/chatbot/chatbot_screen.dart';
import 'package:smart_kishan/screens/complaints/bindings/complaint_binding.dart';
import 'package:smart_kishan/screens/complaints/complaint_details_screen.dart';
import 'package:smart_kishan/screens/complaints/file_complaint_screen.dart';
import 'package:smart_kishan/screens/complaints/my_complaints_screen.dart';
import 'package:smart_kishan/screens/crop_info/binding/crop_info_binding.dart';
import 'package:smart_kishan/screens/crop_info/crop_info_list_screen.dart.dart';
import 'package:smart_kishan/screens/customer/delivery_screen/add_address_screen.dart';
import 'package:smart_kishan/screens/customer/delivery_screen/my_delivery_location.dart';
import 'package:smart_kishan/screens/customer/delivery_screen/order_delivery_screen.dart';
import 'package:smart_kishan/screens/customer/order_confirmation_screen/order_confirmation_screen.dart';
import 'package:smart_kishan/screens/customer/orders/order_history_screen.dart';
import 'package:smart_kishan/screens/customer/product_details/product_details_screen.dart';
import 'package:smart_kishan/screens/customer/product_search/product_search_screen.dart';
import 'package:smart_kishan/screens/customer_dashboard/bindings/dashboard_binding.dart';
import 'package:smart_kishan/screens/customer_dashboard/customer_product_list_screen.dart';
import 'package:smart_kishan/screens/customer_dashboard/dashboard_screen.dart';
import 'package:smart_kishan/screens/daily_activity/add_daily_activity_screen.dart';
import 'package:smart_kishan/screens/daily_activity/binding/daily_activity_binding.dart';
import 'package:smart_kishan/screens/daily_activity/daily_activity_screen.dart';
import 'package:smart_kishan/screens/dashboard/bindings/dashboard_binding.dart';
import 'package:smart_kishan/screens/dashboard/dashboard_screen.dart';
import 'package:smart_kishan/screens/expense_screen/bindings/expense_binding.dart';
import 'package:smart_kishan/screens/expense_screen/expense_screen.dart';
import 'package:smart_kishan/screens/farmland/add_farmland_screen.dart';
import 'package:smart_kishan/screens/farmland/binding/farmland_binding.dart';
import 'package:smart_kishan/screens/farmland/farmland_details_screen.dart';
import 'package:smart_kishan/screens/farmland/farmland_screen.dart';
import 'package:smart_kishan/screens/income_screen/bindings/income_binding.dart';
import 'package:smart_kishan/screens/income_screen/income_screen.dart';
import 'package:smart_kishan/screens/introduction_screen/introduction_screen.dart';
import 'package:smart_kishan/screens/kalimati_price/bindings/kalimati_price_binding.dart';
import 'package:smart_kishan/screens/kalimati_price/kalimati_price_screen.dart';
import 'package:smart_kishan/screens/marketplace/add_sell_product.dart';
import 'package:smart_kishan/screens/notes/add_note_screen.dart';
import 'package:smart_kishan/screens/notes/binding/note_binding.dart';
import 'package:smart_kishan/screens/notes/notes_screen.dart';
import 'package:smart_kishan/screens/products/add_product_screen.dart';
import 'package:smart_kishan/screens/products/binding/product_binding.dart';
import 'package:smart_kishan/screens/products/products_screen.dart';
import 'package:smart_kishan/screens/profile/profile_screen.dart';
import 'package:smart_kishan/screens/select_language/select_language_screen.dart';
import 'package:smart_kishan/screens/sell_product/add_sell_product_screen.dart';
import 'package:smart_kishan/screens/sell_product/bindings/sell_product_binding.dart';
import 'package:smart_kishan/screens/sell_product/sell_product_screen.dart';
import 'package:smart_kishan/screens/sell_product/product_success_screen.dart';
import 'package:smart_kishan/screens/service_center_screen/bindings/service_center_binding.dart';
import 'package:smart_kishan/screens/service_center_screen/service_center_details_screen.dart';
import 'package:smart_kishan/screens/service_center_screen/service_center_screen.dart';
import 'package:smart_kishan/screens/splash_screen/splash_screen.dart';
import 'package:smart_kishan/screens/subsidies_screen/apply_subsidy_screen.dart';
import 'package:smart_kishan/screens/subsidies_screen/bindings/subsidy_binding.dart';
import 'package:smart_kishan/screens/subsidies_screen/my_applications_screen.dart';
import 'package:smart_kishan/screens/subsidies_screen/subsidies_screen.dart';
import 'package:smart_kishan/screens/subsidies_screen/subsidy_details_screen.dart';
import 'package:smart_kishan/screens/subsidy_requests/my_subsidy_requests_screen.dart';
import 'package:smart_kishan/screens/subsidy_requests/request_subsidy_screen.dart';
import 'package:smart_kishan/screens/subsidy_requests/subsidy_request_details_screen.dart';
import 'package:smart_kishan/screens/surveys/bindings/survey_binding.dart';
import 'package:smart_kishan/screens/surveys/survey_list_screen.dart';
import 'package:smart_kishan/screens/surveys/take_survey_screen.dart';
import 'package:smart_kishan/screens/users/add_user_screen.dart';
import 'package:smart_kishan/screens/users/users_screen.dart';
import 'package:smart_kishan/screens/vendor/dashboard/bindings/dashboard_binding.dart';
import 'package:smart_kishan/screens/vendor/dashboard/dashboard_screen.dart';
import 'package:smart_kishan/screens/users/binding/user_binding.dart';

class AppPage {
  static var list = [
    GetPage(
      name: AppRoute.splashScreen,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoute.selectLanguageScreen,
      page: () => const SelectLanguageScreen(),
    ),
    GetPage(
      name: AppRoute.introductionScreen,
      page: () => const IntroductionPage(),
    ),
    GetPage(
        name: AppRoute.phoneRegisterScreen,
        page: () => const PhoneRegisterScreen(),
        binding: AuthBinding()),
    GetPage(
      name: AppRoute.otpScreen,
      page: () => const OTPScreen(),
    ),
    GetPage(
      name: AppRoute.signUpScreen,
      page: () => const SignUpScreen(),
    ),
    GetPage(
      name: AppRoute.signInScreen,
      page: () => const SignInScreen(),
    ),
    GetPage(
      name: AppRoute.forgotPasswordScreen,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(
      name: AppRoute.resetPasswordScreen,
      page: () => const ResetPasswordScreen(),
    ),

    GetPage(
      name: AppRoute.dashboard,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoute.productsScreen,
      page: () => const ProductsScreen(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: AppRoute.addProductScreen,
      page: () => const AddProductScreen(),
    ),
    GetPage(
      name: AppRoute.dailyActivityScreen,
      page: () => const DailyActivityScreen(),
      binding: DailyActivityBinding(),
    ),
    GetPage(
      name: AppRoute.addDailyActivityScreen,
      page: () => const AddDailyActivityScreen(),
    ),
    GetPage(
        name: AppRoute.incomeScreen,
        page: () => IncomeScreen(),
        binding: IncomeBinding()),
    GetPage(
        name: AppRoute.expenseScreen,
        page: () => ExpenseScreen(),
        binding: ExpenseBinding()),
    GetPage(
      name: AppRoute.notesScreen,
      page: () => const NotesScreen(),
      binding: NoteBinding(),
    ),
    GetPage(
      name: AppRoute.addNoteScreen,
      page: () => const AddNoteScreen(),
    ),
    GetPage(
      name: AppRoute.usersScreen,
      page: () => const UsersScreen(),
      binding: UserBinding(),
    ),
    GetPage(
      name: AppRoute.addUserScreen,
      page: () => AddUserScreen(),
    ),
    GetPage(
      name: AppRoute.farmlandScreen,
      page: () => const FarmlandsScreen(),
      binding: FarmlandBinding(),
    ),
    GetPage(
      name: AppRoute.addFarmlandScreen,
      page: () => const AddFarmlandScreen(),
    ),
    GetPage(
      name: AppRoute.farmlandDetailsScreen,
      page: () => const FarmlandDetailsScreen(),
    ),
    GetPage(
      name: AppRoute.cropInfoListScreen,
      page: () => const CropInfoListScreen(),
      binding: CropInfoBinding(),
    ),

    // GetPage(
    //   name: AppRoute.cropInfoScreen,
    //   page: () => const CropInfoScreen(),
    // ),
    GetPage(name: AppRoute.addSellProduct, page: () => AddSellProductScreen()),
    //Buyers Group
    GetPage(
      name: AppRoute.buyersGroup,
      page: () => const BuyersGroupScreen(),
      binding: UserBinding(),
    ),
    GetPage(
      name: AppRoute.addBuyersGroup,
      page: () => AddBuyersGroupScreen(),
    ),
    //Products for sell
    GetPage(
      name: AppRoute.mySellProduct,
      binding: SellProductBinding(),
      page: () => const SellProductScreen(),
    ),
    GetPage(
      name: AppRoute.addSellProductSteps,
      page: () => AddSellProductSteps(),
    ),
    GetPage(
      name: AppRoute.productSuccessScreen,
      page: () => ProductSuccessScreen(
        isEdit: false,
      ),
    ),
    GetPage(
      name: AppRoute.customerDashboard,
      page: () => const CustomerDashboardScreen(),
      binding: CustomerDashboardBinding(),
    ),
    GetPage(
      name: AppRoute.productSearchScreen,
      page: () => const ProductSearchScreen(),
    ),
    GetPage(
      name: AppRoute.productDetailsScreen,
      page: () => const ProductDetailsScreen(),
    ),
    // GetPage(
    //   name: AppRoute.listCategoryScreen,
    //   page: () => const ListCategoryScreen(),
    // ),
    GetPage(
      name: AppRoute.listProductScreen,
      page: () => const CustomerProductListScreen(),
    ),
    GetPage(
      name: AppRoute.orderDeliveryScreen,
      page: () => const OrderDeliveryScreen(),
    ),
    GetPage(
      name: AppRoute.addAddressScreen,
      page: () => const AddAddressScreen(),
    ),
    GetPage(
      name: AppRoute.myDeliveryAddress,
      page: () => const MyDeliveryAddress(),
    ),
    GetPage(
      name: AppRoute.orderConfirmationScreen,
      page: () => const OrderConfirmationScreen(),
    ),
    GetPage(
      name: AppRoute.orderHistoryScreen,
      page: () => const OrderHistoryScreen(),
    ),
    GetPage(
      name: AppRoute.vendorDashboard,
      page: () => const VendorDashboardScreen(),
      binding: VendorDashboardBinding(),
    ),
    GetPage(
      name: AppRoute.kalimatiPriceScreen,
      page: () => KalimatiPriceScreen(),
      binding: KalimatiPriceBinding(),
    ),
    GetPage(
      name: AppRoute.subsidyScreen,
      page: () => SubsidiesScreen(),
      binding: SubsidyBinding(),
    ),
    GetPage(
      name: AppRoute.serviceCentersScreen,
      page: () => const ServiceCenterScreen(),
      binding: ServiceCenterBinding(),
    ),

    GetPage(
      name: AppRoute.serviceCenterDetailsScreen,
      page: () => const ServiceCenterDetailsScreen(),
    ),
    GetPage(
      name: AppRoute.subsidyDetailsScreen,
      page: () => const SubsidyDetailsScreen(),
    ),
    GetPage(
      name: AppRoute.applySubsidyScreen,
      page: () => const ApplySubsidyScreen(),
    ),
    GetPage(
      name: AppRoute.mySubsidyApplicationsScreen,
      page: () => const MyApplicationsScreen(),
    ),
    GetPage(
      name: AppRoute.profileScreen,
      page: () => const ProfileScreen(),
    ),
    GetPage(
      name: AppRoute.editProfileScreen,
      page: () => const EditProfileScreen(),
    ),
    GetPage(
      name: AppRoute.updateLocationScreen,
      page: () => const UpdateLocationScreen(),
    ),
    GetPage(
      name: AppRoute.updatePasswordScreen,
      page: () => const UpdatePasswordScreen(),
    ),
    GetPage(
      name: AppRoute.requestSubsidyScreen,
      page: () => const RequestSubsidyScreen(),
    ),
    GetPage(
      name: AppRoute.mySubsidyRequestsScreen,
      page: () => const MySubsidyRequestsScreen(),
    ),
    GetPage(
      name: AppRoute.subsidyRequestDetailsScreen,
      page: () => const SubsidyRequestDetailsScreen(),
    ),
    GetPage(
      name: AppRoute.complaintsScreen,
      page: () => const MyComplaintsScreen(),
      binding: ComplaintBinding(),
    ),
    GetPage(
      name: AppRoute.fileComplaintScreen,
      page: () => const FileComplaintScreen(),
    ),
    GetPage(
      name: AppRoute.complaintDetailsScreen,
      page: () => const ComplaintDetailsScreen(),
    ),
    GetPage(
      name: AppRoute.surveysScreen,
      page: () => SurveysListScreen(),
      binding: SurveyBinding(),
    ),
    GetPage(
      name: AppRoute.takeSurveyScreen,
      page: () => TakeSurveyScreen(),
    ),
    GetPage(
      name: AppRoute.chatbotScreen,
      page: () => const ChatbotScreen(),
    )
  ];
}
