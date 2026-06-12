// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Smart Kishan';

  @override
  String get language => 'Language';

  @override
  String get selectLanguageMsg => 'Please select your preferred language';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get loginMsg => 'Please sign in to continue.';

  @override
  String get phoneNumber => 'Phone';

  @override
  String get inputPhone => 'Enter Phone Number';

  @override
  String get inputPhoneMsg => 'Please enter your phone number';

  @override
  String get enterValidPhone => 'Please enter valid phone number!';

  @override
  String get password => 'Password';

  @override
  String get inputPassword => 'Enter Your Password';

  @override
  String get inputPasswordMsg => 'Please enter your password';

  @override
  String get login => 'Login';

  @override
  String get noAccount => 'Don\'t have an account';

  @override
  String get registerNow => 'Register Now';

  @override
  String get or => 'OR';

  @override
  String get navigateForgotPwdMsgBefore => 'Forgot Your ';

  @override
  String get navigateForgotPwdMsgAfter => 'Password';

  @override
  String get nextPage => 'Next';

  @override
  String get story1Title => 'Farming Made Easier';

  @override
  String get story2Title => 'Manage Multiple Farmlands';

  @override
  String get story3Title => 'Organize Farm Stock Efficiently';

  @override
  String get story4Title => 'Quick Notes for Fast Reminders';

  @override
  String get story1Desc =>
      'Simplify farm management with tools designed to help you grow and succeed effortlessly.';

  @override
  String get story2Desc =>
      'Store and track data from different farmlands, customized for each plot.';

  @override
  String get story3Desc =>
      'Keep a clear record of all farm supplies and stock levels in one place.';

  @override
  String get story4Desc =>
      'Note down important tasks or ideas instantly to stay organized and on top of your farm\'s needs.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get createAccountTitle => 'Create New Account';

  @override
  String get createAccountDesc =>
      'Enter your phone number to continue, we will send you OTP to verify';

  @override
  String get requestOTP => 'Request OTP';

  @override
  String get wrongPhonePassword => 'Wrong phone / password';

  @override
  String get accountCreated => 'Your account has been created successfully!';

  @override
  String get passwordResetSuccess =>
      'Password changed successfully. Please sign in.';

  @override
  String get passwordResetFailed => 'Could not change password.';

  @override
  String get logoutFailed => 'Something went wrong! Please try again.';

  @override
  String get otpSent => 'A verification code has been sent to your phone.';

  @override
  String get otpResent =>
      'A new verification code has been sent to your phone.';

  @override
  String get phoneAlreadyRegistered =>
      'This phone number is already registered.';

  @override
  String get phoneNotRegistered => 'This phone number is not registered.';

  @override
  String otpThrottled(String seconds) {
    return 'Please wait $seconds seconds before requesting another code.';
  }

  @override
  String get otpSendFailed => 'Could not send the verification code.';

  @override
  String get otpInvalid => 'The verification code is incorrect.';

  @override
  String get genericError => 'Something went wrong. Please try again.';

  @override
  String loginThrottled(String seconds) {
    return 'Too many attempts. Please wait $seconds seconds and try again.';
  }

  @override
  String get sessionExpired => 'Your session has expired. Please log in again.';

  @override
  String get noInternet =>
      'Couldn\'t connect. Please check your internet connection and try again.';

  @override
  String get alreadyAccount => 'Already have an account?';

  @override
  String get signInNav => 'Login';

  @override
  String get forgotPwdTitle => 'Forgot Your Password?';

  @override
  String get forgotPwdDesc =>
      'Enter your phone number to continue, we will send you verification code to reset your password.';

  @override
  String get noForget => 'Back to ';

  @override
  String get knowAboutCrops => 'Want to know about different crops?';

  @override
  String get crops => 'Crops';

  @override
  String get clickHere => 'Click Here!';

  @override
  String get logout => 'Logout';

  @override
  String get home => 'Home';

  @override
  String get chart => 'Chart';

  @override
  String get incomeAnalysis => 'Income Analysis';

  @override
  String get incomeChartDaily => 'Daily Income Chart';

  @override
  String get incomeChartMonthly => 'Monthly Income Chart';

  @override
  String get incomeChartYearly => 'Yearly Income Chart';

  @override
  String get last7Days => 'Last 7 days';

  @override
  String get last7Months => 'Last 7 months';

  @override
  String get last5Years => 'Last 5 years';

  @override
  String get expenseAnalysis => 'Expense Analysis';

  @override
  String get expenseChartDaily => 'Daily Expense Chart';

  @override
  String get expenseChartMonthly => 'Monthly Expense Chart';

  @override
  String get expenseChartYearly => 'Yearly Expense Chart';

  @override
  String get chartScreenTitle => 'Ledger Chart';

  @override
  String get chartTitleDaily => 'Daily Income/Expense Chart';

  @override
  String get chartTitleMonthly => 'Monthly Income/Expense Chart';

  @override
  String get chartTitleYearly => 'Yearly Income/Expense Chart';

  @override
  String get currencySymbol => 'Rs.';

  @override
  String get filterDaily => 'Daily';

  @override
  String get filterMonthly => 'Monthly';

  @override
  String get filterYearly => 'Yearly';

  @override
  String get productListTitle => 'Inventory';

  @override
  String get stockLabel => 'Stock';

  @override
  String get noProductsFound => 'You have no products yet!';

  @override
  String get noDateFound => 'No Date Found';

  @override
  String get loadingCity => 'Loading city...';

  @override
  String get goodDayForPesticide => 'Today is a good day to apply pesticides.';

  @override
  String get badDayForPesticide =>
      'Today is not a good day to apply pesticides.';

  @override
  String get weatherThunderstorm => 'Thunderstorm';

  @override
  String get weatherDrizzle => 'Drizzle';

  @override
  String get weatherRain => 'Rain';

  @override
  String get weatherSnow => 'Snow';

  @override
  String get weatherClear => 'Clear';

  @override
  String get weatherClouds => 'Cloudy';

  @override
  String get weatherMist => 'Mist';

  @override
  String get weatherHaze => 'Haze';

  @override
  String get weatherFog => 'Fog';

  @override
  String get newNote => 'New Note';

  @override
  String get addNote => 'Add Note';

  @override
  String get updateNote => 'Update Note';

  @override
  String get add => 'Add';

  @override
  String get update => 'Update';

  @override
  String get edit => 'Edit';

  @override
  String get notesEmptyDescription =>
      'Add notes to keep your important thoughts and information safe';

  @override
  String get deleteNoteConfirm =>
      'Are you sure you want to delete this note? This action cannot be undone.';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String daysAgo(String count) {
    return '$count days ago';
  }

  @override
  String get noteTitle => 'Note Title';

  @override
  String get enterNoteTitle => 'Enter note title';

  @override
  String get pleaseEnterNoteTitle => 'Please enter your note title';

  @override
  String get noteTitleMinLength => 'Note title must be at least 3 characters';

  @override
  String get noteDescription => 'Note Description';

  @override
  String get enterNoteDescription => 'Enter note description';

  @override
  String get notePriority => 'Note Priority';

  @override
  String get enterNotePriority => 'Enter note priority';

  @override
  String get governmentServices => 'Government Services';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get homeGovOfficesTitle => 'Government Offices';

  @override
  String get homeGovOfficesSubtitle =>
      'Find nearby agriculture offices and labs';

  @override
  String get homeGovOfficesBadge => 'Locations';

  @override
  String get homeSubsidiesTitle => 'Subsidies &\nBenefits';

  @override
  String get homeSubsidiesSubtitle => 'Explore government subsidies';

  @override
  String get homeSubsidiesBadge => 'Gov Support';

  @override
  String get homeComplaintsTitle => 'File\nComplaints';

  @override
  String get homeComplaintsSubtitle => 'Report your problems';

  @override
  String get homeComplaintsBadge => 'Report Issues';

  @override
  String get homeSurveysTitle => 'Surveys';

  @override
  String get homeSurveysSubtitle => 'Share your feedback';

  @override
  String get homeSurveysBadge => 'Feedback';

  @override
  String get serviceCenters => 'Service Centers';

  @override
  String get listView => 'List View';

  @override
  String get mapView => 'Map View';

  @override
  String get filters => 'Filters';

  @override
  String get currentLocationNotAvailable => 'Current location not available';

  @override
  String get searchServiceCentersHint => 'Search service centers...';

  @override
  String get loadingRoute => 'Loading route...';

  @override
  String get nearestServiceCenters => 'Nearest Service Centers';

  @override
  String get noServiceCentersFound => 'No service centers found';

  @override
  String get tryAdjustingFilters => 'Try adjusting your filters or search';

  @override
  String get km => 'km';

  @override
  String get away => 'away';

  @override
  String get routeLoaded => 'Route loaded';

  @override
  String get notApplicable => 'N/A';

  @override
  String get featured => 'Featured';

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get details => 'Details';

  @override
  String get filtersAndSort => 'Filters & Sort';

  @override
  String get clearAll => 'Clear All';

  @override
  String get distance => 'Distance';

  @override
  String get name => 'Name';

  @override
  String get rating => 'Rating';

  @override
  String get newest => 'Newest';

  @override
  String get searchRadius => 'Search Radius';

  @override
  String get showFeaturedOnly => 'Show Featured Only';

  @override
  String get applyFilters => 'Apply Filters';

  @override
  String get serviceCenterNotFound => 'Service center not found';

  @override
  String get basedOnUserReviews => 'Based on user reviews';

  @override
  String get ratingSingular => 'rating';

  @override
  String get ratingPlural => 'ratings';

  @override
  String get reviewSingular => 'review';

  @override
  String get reviewPlural => 'reviews';

  @override
  String get contactInformation => 'Contact Information';

  @override
  String get phone => 'Phone';

  @override
  String get website => 'Website';

  @override
  String get contactPerson => 'Contact Person';

  @override
  String get directions => 'Directions';

  @override
  String wardNo(String no) {
    return 'Ward No: $no';
  }

  @override
  String get operatingHours => 'Operating Hours';

  @override
  String get servicesOffered => 'Services Offered';

  @override
  String get yourRating => 'Your Rating';

  @override
  String get editRating => 'Edit Rating';

  @override
  String get helpOthersRate => 'Help others by rating this service center';

  @override
  String get addYourRating => 'Add Your Rating';

  @override
  String get rateServiceCenter => 'Rate Service Center';

  @override
  String get writeReviewOptional => 'Write a review (optional)';

  @override
  String get shareYourExperienceHint => 'Share your experience...';

  @override
  String get submit => 'Submit';

  @override
  String get editYourRating => 'Edit Your Rating';

  @override
  String get deleteRatingQuestion => 'Delete Rating?';

  @override
  String get deleteRatingReviewConfirm =>
      'Are you sure you want to delete your rating and review? This action cannot be undone.';

  @override
  String get ratingSubmittedSuccess => 'Rating submitted successfully!';

  @override
  String get ratingUpdatedSuccess => 'Rating updated successfully!';

  @override
  String get youRatedThisCenter => 'You rated this service center';

  @override
  String get recentReviews => 'Recent Reviews';

  @override
  String viewAllReviews(String count) {
    return 'View all $count reviews';
  }

  @override
  String get anonymous => 'Anonymous';

  @override
  String get ago => 'ago';

  @override
  String get minUnit => 'min';

  @override
  String get hrUnit => 'hr';

  @override
  String get dayUnit => 'day';

  @override
  String get daysUnit => 'days';

  @override
  String get weekUnit => 'week';

  @override
  String get weeksUnit => 'weeks';

  @override
  String get topRatedServiceCenters => 'Top Rated Service Centers';

  @override
  String get basicInformation => 'Basic Information';

  @override
  String get requestDetails => 'Request Details';

  @override
  String get requestTarget => 'Request Target';

  @override
  String get actionCannotBeUndone => 'This action cannot be undone.';

  @override
  String get kalimatiPriceList => 'Kalimati Price List';

  @override
  String get commodity => 'Commodity';

  @override
  String get unit => 'Unit';

  @override
  String get minPrice => 'Min Price';

  @override
  String get maxPrice => 'Max Price';

  @override
  String get avgPrice => 'Avg Price';

  @override
  String get tapAnyFileToViewOrDownload => 'Tap any file to view or download.';

  @override
  String get addUser => 'Add User';

  @override
  String get noUsersYet => 'You haven\'t added any users yet!';

  @override
  String get deleteUserConfirm => 'Are you sure you want to delete this user?';

  @override
  String get addUserTitle => 'Add User';

  @override
  String get updateUserTitle => 'Update User';

  @override
  String get userFullName => 'User\'s Full Name';

  @override
  String get enterUserFullName => 'Enter user\'s full name';

  @override
  String get pleaseEnterUserFullName => 'Please enter user\'s full name';

  @override
  String get pleaseEnterValidUserName => 'Please enter a valid user name';

  @override
  String get userPhoneNumber => 'User\'s Phone Number';

  @override
  String get enterUserPhoneNumber => 'Enter user\'s phone number';

  @override
  String get pleaseEnterUserPhone => 'Please enter user\'s phone number';

  @override
  String get pleaseEnterValidUserPhone =>
      'Please enter a valid user phone number';

  @override
  String get userEmail => 'User\'s Email Address';

  @override
  String get enterUserEmail => 'Enter user\'s email address';

  @override
  String get userPassword => 'User\'s Password';

  @override
  String get enterUserPassword => 'Enter user\'s password';

  @override
  String get pleaseEnterUserPassword => 'Please enter user\'s password';

  @override
  String get passwordMinLength => 'Password must be at least 8 characters';

  @override
  String get userConfirmPassword => 'Confirm User\'s Password';

  @override
  String get confirmUserPassword => 'Confirm user\'s password';

  @override
  String get confirmPasswordEmpty => 'Confirm password field cannot be empty';

  @override
  String get users => 'Users';

  @override
  String get profile => 'Profile';

  @override
  String get dailyActivities => 'Daily \n Activity';

  @override
  String get dailyActivity => 'Daily Activity';

  @override
  String get products => 'Products';

  @override
  String get expenses => 'Expenses';

  @override
  String get sales => 'Sales';

  @override
  String get farmlands => 'Farm\nLands';

  @override
  String get notes => 'Notes';

  @override
  String get noNotesMsg => 'You don\'t have any notes yet!';

  @override
  String get c => 'C';

  @override
  String get humidity => 'Humidity';

  @override
  String get search => 'Search';

  @override
  String get searchHint => 'Search...';

  @override
  String get sellerMode => 'Seller Mode';

  @override
  String get buyerMode => 'Buyer Mode';

  @override
  String get farmerMode => 'Farmer Mode';

  @override
  String get myDeliveryLocations => 'My Delivery Address';

  @override
  String get myCart => 'My Cart';

  @override
  String get myProductOrders => 'My Orders';

  @override
  String get logOut => 'Log Out';

  @override
  String get market => 'MarketPlace';

  @override
  String get noItems => 'No Items';

  @override
  String get yourCart => 'Your Cart';

  @override
  String get buyProducts => 'Buy Products';

  @override
  String get yourCartIsEmpty => 'Your Cart is Empty!';

  @override
  String get cartMessage =>
      'You will see products here once you start adding to your cart!';

  @override
  String get shoppingCart => 'Shopping Cart';

  @override
  String get results => 'Results';

  @override
  String get showingDefaultProducts => 'Showing Default Results';

  @override
  String get sortBy => 'Sort By';

  @override
  String get defaultResults => 'Default';

  @override
  String get recentlyAdded => 'Recently Added';

  @override
  String get priceLowToHigh => 'Price: Low to High';

  @override
  String get priceHighToLow => 'Price: High to Low';

  @override
  String get categories => 'Categories';

  @override
  String get allCategories => 'All Categories';

  @override
  String get paymentTypes => 'Payment Types';

  @override
  String get whatAreYouLookingFor => 'What are you looking for?';

  @override
  String get buyItNow => 'Buy it Now';

  @override
  String get addToBag => 'Add to Bag';

  @override
  String get viewAll => 'View all';

  @override
  String get featuredProducts => 'Featured Products';

  @override
  String get searchProducts => 'Search Products';

  @override
  String get noResultFound => 'No results found';

  @override
  String get noResultFoundDesc => 'No results found. Please try again.';

  @override
  String get exploreCategories => 'Explore Categories';

  @override
  String get myDeliveryAddress => 'My Delivery Address';

  @override
  String get addNewAddress => 'Add New Address';

  @override
  String get deliveryChargesInfo =>
      'Delivery charges may vary depending on the farmer and your location.';

  @override
  String get noDeliveryAddress =>
      'You have not added any delivery address yet. Please add a new address to continue your order process.';

  @override
  String get updateAddress => 'Update Address';

  @override
  String get addressTitle => 'Address Title';

  @override
  String get enterAddressTitle => 'Please enter address title';

  @override
  String get city => 'City';

  @override
  String get enterCityName => 'Please enter name of your city';

  @override
  String get addressDescription => 'Address Description';

  @override
  String get addressDescriptionLandmark => 'Address Description/Landmark';

  @override
  String get enterAddressDescription => 'Please enter address description';

  @override
  String get setAsDefaultAddress => 'Set as default address';

  @override
  String get saveAddress => 'Save Address';

  @override
  String get addNewAddressButton => 'Add New Address';

  @override
  String get showingNewestResults => 'Showing Recently Added';

  @override
  String searchResultFor(Object name) {
    return 'Showing result for \'$name\'';
  }

  @override
  String get showingLowToHighResults => 'Showing Price: Low to High';

  @override
  String get showingHighToLowResults => 'Showing Price: High to Low';

  @override
  String get showingDefaultResults => 'Showing Default Results';

  @override
  String productResults(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$count Result$_temp0';
  }

  @override
  String filterTitle(Object title) {
    return 'Filter $title';
  }

  @override
  String get confirm => 'Confirm';

  @override
  String get searchHistory => 'Search History';

  @override
  String get currency => 'Nrs.';

  @override
  String get minimumOrder => 'Minimum Order';

  @override
  String get acceptedPaymentMethods => 'Accepted payment methods';

  @override
  String get deliveryLocations => 'Delivery Locations';

  @override
  String get additionalNotes => 'Additional Notes';

  @override
  String get total => 'Total';

  @override
  String get checkOut => 'Checkout';

  @override
  String cartItems(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return 'item$_temp0';
  }

  @override
  String get quantityShort => 'Qty.';

  @override
  String get deleteCartTitle => 'Delete Cart Item';

  @override
  String get deleteCartMessage =>
      'Are you sure you want to remove this product from your cart?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get selectDeliveryLocation => 'Select Delivery Location';

  @override
  String get confirmOrder => 'Confirm Order';

  @override
  String get deleteDeliveryAddressTitle => 'Delete Delivery Address';

  @override
  String get deleteDeliveryAddressMessage =>
      'Are you sure you want to delete this delivery address?';

  @override
  String get orderConfirmedTitle => 'Order Confirmed';

  @override
  String get orderConfirmedMessage =>
      'Your order has been placed successfully. You can track your orders from order history.';

  @override
  String get continueShopping => 'Continue Shopping';

  @override
  String get haveAnyQuestions => 'Have any questions?';

  @override
  String get connectToUs => 'Connect to us';

  @override
  String get deliveryLocation => 'Delivery Location';

  @override
  String get notSelected => 'Not Selected';

  @override
  String get myOrder => 'My Orders';

  @override
  String get activeOrders => 'Active Orders';

  @override
  String get inactiveOrders => 'Inactive Orders';

  @override
  String get rate => 'Rate';

  @override
  String get orderPlaced => 'Order Placed';

  @override
  String get orderReceived => 'We have received your order.';

  @override
  String get pending => 'Pending';

  @override
  String get confirmed => 'Confirmed';

  @override
  String get orderConfirmed => 'Your order has been confirmed.';

  @override
  String get shipped => 'Shipped';

  @override
  String get orderShipped => 'We are preparing your order.';

  @override
  String get delivered => 'Delivered';

  @override
  String get orderDelivered => 'Your order has been delivered.';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get orderCancelled => 'Your order has been cancelled.';

  @override
  String get cancelOrder => 'Cancel Order';

  @override
  String get vendorNotAvailable => 'Vendor Not Available';

  @override
  String get customerNotAvailable => 'Customer Not Available';

  @override
  String get productNotAvailable => 'Product Not Available';

  @override
  String get noActiveOrders => 'Your active orders list is empty';

  @override
  String get noOrdersMessage =>
      'You will see orders here once you place your order';

  @override
  String get seller => 'Seller';

  @override
  String get noPhoneAvailable => 'Phone number not available';

  @override
  String get quantity => 'Quantity';

  @override
  String get cancelOrderTitle => 'Cancel Order';

  @override
  String get cancelOrderMessage =>
      'Are you sure you want to cancel this order?';

  @override
  String get inactiveOrdersTitle => 'Your inactive orders list is empty';

  @override
  String get inactiveOrdersDescription =>
      'You will see orders here once your order completes or gets cancelled.';

  @override
  String get myProducts => 'My Products';

  @override
  String get myOrders => 'My Orders';

  @override
  String get thisMonth => 'This Month';

  @override
  String get grossSales => 'Gross Sales';

  @override
  String get averageSales => 'Average Sales';

  @override
  String get totalProducts => 'Total Products';

  @override
  String get totalOrders => 'Total Orders';

  @override
  String get recentOrders => 'Recent Orders';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get income => 'Income';

  @override
  String get jan => 'Jan';

  @override
  String get feb => 'Feb';

  @override
  String get mar => 'Mar';

  @override
  String get apr => 'Apr';

  @override
  String get may => 'May';

  @override
  String get jun => 'Jun';

  @override
  String get jul => 'Jul';

  @override
  String get aug => 'Aug';

  @override
  String get sep => 'Sep';

  @override
  String get oct => 'Oct';

  @override
  String get nov => 'Nov';

  @override
  String get dec => 'Dec';

  @override
  String get customerName => 'Customer Name';

  @override
  String get orderStatus => 'Order Status';

  @override
  String get buyersGroups => 'Buyers Groups';

  @override
  String get sellProduct => 'Sell Product';

  @override
  String get myProductsForSale => 'My Products';

  @override
  String get emptyProductList => 'Your current product list is empty.';

  @override
  String get addProductForSale => 'Add products for sale.';

  @override
  String get addSaleProduct => 'Add Product';

  @override
  String get inStock => 'In Stock';

  @override
  String get status => 'Status';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get vendorNewOrderMessage => 'A new order has been placed.';

  @override
  String get vendorProcessingMessage => 'You have confirmed the order.';

  @override
  String get vendorShippedMessage => 'You have shipped the order.';

  @override
  String get vendorDeliveredMessage => 'You have delivered the order.';

  @override
  String get vendorCancelledMessage => 'The order has been cancelled.';

  @override
  String get customer => 'ग्राहक';

  @override
  String get updateOrder => 'Update Order';

  @override
  String get updateOrderStatus => 'Update Order Status';

  @override
  String get chooseNewStatus => 'Choose a new status for this order.';

  @override
  String get recommendedVegetables => 'Recommended Vegetables';

  @override
  String get recommendedFruit => 'Recommended Fruits';

  @override
  String get inventory => 'Inventory';

  @override
  String get inventoryBroken => 'Inventory';

  @override
  String get activeVendorOrdersDescription =>
      'You will see orders here once you start receiving orders.';

  @override
  String get kalimatiPrice => 'Kalimati Price';

  @override
  String get subsidies => 'Government Subsidies';

  @override
  String get myApplications => 'My Applications';

  @override
  String get noSubsidies => 'No subsidies available at the moment!';

  @override
  String get refresh => 'Refresh';

  @override
  String get requestSubsidy => 'Request Subsidy';

  @override
  String get applied => 'Applied';

  @override
  String get applyNow => 'Apply Now';

  @override
  String get more => 'More';

  @override
  String get less => 'Less';

  @override
  String get deadline => 'Deadline';

  @override
  String get expired => 'Expired';

  @override
  String get eligibility => 'Eligibility Criteria';

  @override
  String get targetSector => 'Target Crop/Sector';

  @override
  String get locationLevel => 'Location Level';

  @override
  String get subsidyDetails => 'Subsidy Details';

  @override
  String get description => 'Description';

  @override
  String get fiscalYear => 'Fiscal Year';

  @override
  String get expectedBeneficiaries => 'Expected Beneficiaries';

  @override
  String get budgetPerBeneficiary => 'Budget Per Beneficiary';

  @override
  String get totalBudget => 'Total Budget';

  @override
  String get lastDate => 'Last Date';

  @override
  String get locationDetails => 'Location Details';

  @override
  String get province => 'Province';

  @override
  String get district => 'District';

  @override
  String get municipality => 'Municipality';

  @override
  String get ward => 'Ward';

  @override
  String get alreadyApplied => 'Already Applied';

  @override
  String get deadlinePassed => 'Deadline Passed';

  @override
  String get applyForSubsidy => 'Apply for Subsidy';

  @override
  String get applicationNotes => 'Application Notes';

  @override
  String get explainEligibility =>
      'Explain why you are eligible for this subsidy';

  @override
  String get enterNotes => 'Enter your application notes here...';

  @override
  String get submitApplication => 'Submit Application';

  @override
  String get noSubsidySelected => 'No subsidy selected';

  @override
  String get applicationSuccessful => 'Application submitted successfully';

  @override
  String get applicationFailed => 'Failed to submit the application';

  @override
  String get enterApplicationNotes => 'Please enter application notes';

  @override
  String get min10Characters => 'Please enter at least 10 characters';

  @override
  String get importantNote =>
      'Your application will be reviewed. Please provide correct information.';

  @override
  String get rateReview => 'Rate & Review';

  @override
  String get rateSubsidy => 'How would you rate this subsidy?';

  @override
  String get shareExperience => 'Share Your Experience';

  @override
  String get submitReview => 'Submit Review';

  @override
  String get poor => 'Poor';

  @override
  String get fair => 'Fair';

  @override
  String get good => 'Good';

  @override
  String get veryGood => 'Very Good';

  @override
  String get excellent => 'Excellent';

  @override
  String get reviewSubmitted => 'Review Submitted Successfully!';

  @override
  String get thankYou => 'Thank you for your feedback.';

  @override
  String get untitled => 'Untitled';

  @override
  String get noInfo => 'No information available';

  @override
  String get noDeadline => 'No deadline';

  @override
  String get fertilizer => 'Fertilizer';

  @override
  String get equipment => 'Equipment';

  @override
  String get training => 'Training';

  @override
  String get irrigation => 'Irrigation';

  @override
  String get livestock => 'Livestock';

  @override
  String get seeds => 'Seeds';

  @override
  String get insurance => 'Insurance';

  @override
  String get loan => 'Loan';

  @override
  String get organic => 'Organic';

  @override
  String get general => 'General';

  @override
  String get central => 'Central';

  @override
  String get provinceLevel => 'Province Level';

  @override
  String get districtLevel => 'District Level';

  @override
  String get municipalityLevel => 'Municipality Level';

  @override
  String get wardLevel => 'Ward Level';

  @override
  String get requestNewSubsidy => 'Request New Subsidy';

  @override
  String get subsidyTitle => 'Subsidy Title';

  @override
  String get category => 'Category';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get descriptionHint => 'Describe why this subsidy is needed...';

  @override
  String get submitRequest => 'Submit Request';

  @override
  String get subsidyRequestSubmitted =>
      'Subsidy request submitted successfully';

  @override
  String get tellOtherFarmers =>
      'Tell other farmers about your experience with this subsidy...';

  @override
  String get tipMention =>
      'Tip: Mention application process, approval time, or benefits received';

  @override
  String get reviewHelps =>
      'Your review helps other farmers make informed decisions.';

  @override
  String get noApplicationsYet =>
      'You have not submitted any applications yet!';

  @override
  String get withdrawApplication => 'Withdraw Application';

  @override
  String get withdrawConfirm =>
      'Are you sure you want to withdraw your application for';

  @override
  String get applicationWithdrawn => 'Application withdrawn successfully!';

  @override
  String get approved => 'Approved';

  @override
  String get rejected => 'Rejected';

  @override
  String get requiredDocumentsForApplication =>
      'Required Documents for Application';

  @override
  String get subsidyDetailDocuments => 'Subsidy Detail Documents';

  @override
  String get documentsUploadWarning =>
      'You will need to upload these documents when applying';

  @override
  String get required => 'REQUIRED';

  @override
  String get optional => 'Optional';

  @override
  String get document => 'Document';

  @override
  String get cannotOpenDocument => 'Cannot open document';

  @override
  String get page => 'Page';

  @override
  String get ofTxt => 'ofTxt';

  @override
  String get loading => 'Loading';

  @override
  String get errorLoadingPdf => 'Error loading PDF';

  @override
  String get applicationForm => 'Application Form';

  @override
  String get uploadFile => 'Upload File';

  @override
  String get changeFile => 'Change File';

  @override
  String get errorLoadingImage => 'Error loading image';

  @override
  String get success => 'Success';

  @override
  String get failed => 'Failed';

  @override
  String get validationErrorMessage => 'Validation Error';

  @override
  String get pleaseCheckAllFields => 'Please check all required fields';

  @override
  String get documentRequired => 'Document Required';

  @override
  String get invalidFileType => 'Invalid File Type';

  @override
  String pleaseUpload(Object types) {
    return 'Please upload a file of type: $types';
  }

  @override
  String get fileTooLarge => 'File size must be less than 5MB';

  @override
  String maximumFileSize(Object size) {
    return 'Maximum file size is $size MB';
  }

  @override
  String get uploaded => 'Uploaded';

  @override
  String get documentUploadedSuccessfully => 'Document uploaded successfully';

  @override
  String get error => 'Error';

  @override
  String get failedToPickFile => 'Failed to pick file';

  @override
  String get applicationWithdrawFailed => 'Failed to withdraw application';

  @override
  String get withdrawWarningMessage =>
      'Are you sure you want to withdraw your application?';

  @override
  String get withdraw => 'Withdraw';

  @override
  String get subsidyInformation => 'Subsidy Information';

  @override
  String get applicationTimeline => 'Application Timeline';

  @override
  String get appliedOn => 'Applied On';

  @override
  String get submittedInformation => 'Submitted Information';

  @override
  String get uploadedDocuments => 'Uploaded Documents';

  @override
  String get applicationId => 'Application ID';

  @override
  String get startApplyingMessage =>
      'Start applying for subsidies to see them here';

  @override
  String get exploreSubsidies => 'Explore Subsidies';

  @override
  String get viewDetails => 'View Details';

  @override
  String get congratulations => 'Congratulations!';

  @override
  String get applicationApprovedMessage =>
      'Your application has been approved. Further instructions will be provided soon.';

  @override
  String get applicationRejected => 'Application Rejected';

  @override
  String get applicationRejectedMessage =>
      'Unfortunately, your application was not approved. You may reapply if eligible.';

  @override
  String get underReview => 'Under Review';

  @override
  String get applicationPendingMessage =>
      'Your application is being reviewed. We will notify you once a decision is made.';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get applicationDetails => 'Application Details';

  @override
  String get submitted => 'Submitted';

  @override
  String get reviewed => 'Reviewed';

  @override
  String get title => 'Title';

  @override
  String get subsidyType => 'Type';

  @override
  String get fromReviewer => 'From Reviewer';

  @override
  String get notesDisclaimer =>
      'These notes are provided by the application reviewer with text notes.';

  @override
  String get updateReview => 'Update Review';

  @override
  String get ratingFailed => 'Failed to submit rating';

  @override
  String get deleteRating => 'Delete Rating';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get deleteRatingConfirm =>
      'Are you sure you want to delete your rating?';

  @override
  String get ratingDeleted => 'Rating deleted successfully';

  @override
  String get ratingDeleteFailed => 'Failed to delete rating';

  @override
  String get reviewUpdated => 'Review Updated';

  @override
  String get locationRequired => 'Location Required';

  @override
  String get locationRequiredDescription =>
      'To access subsidy features, please add your location information in your profile first.';

  @override
  String get whyLocationNeeded => 'Why is location needed?';

  @override
  String get locationReason1 => 'Show subsidies available for your area';

  @override
  String get locationReason2 => 'Apply for government subsidy programs';

  @override
  String get locationReason3 => 'Find local facilities near you';

  @override
  String get addLocation => 'Add Location';

  @override
  String get goBack => 'Go Back';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get notifications => 'Notifications';

  @override
  String get privacy => 'Privacy & Security';

  @override
  String get about => 'About';

  @override
  String get help => 'Help & Support';

  @override
  String get location => 'Location';

  @override
  String get selectLanguage => 'Select your preferred language';

  @override
  String get confirmLogout => 'Confirm Logout';

  @override
  String get logoutMessage => 'Are you sure you want to logout?';

  @override
  String get locationNotSet => 'Location not set';

  @override
  String get aboutUs => 'About Us';

  @override
  String get changePassword => 'Change Password';

  @override
  String get updateLocation => 'Update Location';

  @override
  String get fullName => 'Full Name';

  @override
  String get enterFullName => 'Enter full name';

  @override
  String get pleaseEnterName => 'Please enter name';

  @override
  String get nameTooShort => 'Name is too short';

  @override
  String get email => 'Email';

  @override
  String get enterEmail => 'Enter email';

  @override
  String get pleaseEnterEmail => 'Please enter email';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get enterPhoneNumber => 'Enter phone number';

  @override
  String get pleaseEnterPhone => 'Please enter phone number';

  @override
  String get updateProfile => 'Update Profile';

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully';

  @override
  String get profileUpdateFailed => 'Failed to update profile';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get enterCurrentPassword => 'Enter current password';

  @override
  String get pleaseEnterCurrentPassword => 'Please enter current password';

  @override
  String get newPassword => 'New Password';

  @override
  String get enterNewPassword => 'Enter new password';

  @override
  String get pleaseEnterNewPassword => 'Please enter new password';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get enterConfirmPassword => 'Confirm password';

  @override
  String get pleaseConfirmPassword => 'Please confirm password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get updatePassword => 'Update Password';

  @override
  String get passwordUpdatedSuccessfully => 'Password updated successfully';

  @override
  String get passwordUpdateFailed => 'Failed to update password';

  @override
  String get selectProvince => 'Select Province';

  @override
  String get selectDistrict => 'Select District';

  @override
  String get selectMunicipality => 'Select Municipality';

  @override
  String get selectWard => 'Select Ward';

  @override
  String get address => 'Address';

  @override
  String get enterAddress => 'Enter address';

  @override
  String get pleaseEnterAddress => 'Please enter address';

  @override
  String get pleaseSelectAllLocationFields =>
      'Please select all location fields';

  @override
  String get locationUpdatedSuccessfully => 'Location updated successfully';

  @override
  String get locationUpdateFailed => 'Failed to update location';

  @override
  String get accountInformation => 'Account Information';

  @override
  String get updateYourPersonalInformation =>
      'Update your personal information';

  @override
  String get updateYourAddress => 'Update your address';

  @override
  String get updateYourPassword => 'Update your password';

  @override
  String get myRequests => 'My Requests';

  @override
  String get noRequests => 'No Requests Yet';

  @override
  String get noRequestsDescription =>
      'You haven\'t submitted any subsidy requests';

  @override
  String get enterTitle => 'Enter subsidy title';

  @override
  String get pleaseEnterTitle => 'Please enter complaint title';

  @override
  String get targetCrop => 'Target Crop/Sector';

  @override
  String get enterTargetCrop => 'e.g., Rice, Wheat';

  @override
  String get pleaseEnterDescription => 'Please enter description';

  @override
  String get justification => 'Justification';

  @override
  String get justificationHint => 'Explain why you need this subsidy';

  @override
  String get pleaseEnterJustification => 'Please explain your need';

  @override
  String get requestTo => 'Request To';

  @override
  String get requestInfo =>
      'Your request will be reviewed by government officials';

  @override
  String get pleaseSelectAll => 'Please select all required fields';

  @override
  String get requestFailed => 'Failed to submit request';

  @override
  String get converted => 'Converted';

  @override
  String get rejectionReason => 'Rejection Reason';

  @override
  String get yesCancel => 'Yes, Cancel';

  @override
  String get confirmCancel => 'Cancel Request';

  @override
  String get cancelRequestMessage =>
      'Are you sure you want to cancel this request?';

  @override
  String get requestCancelled => 'Request cancelled successfully';

  @override
  String get cannotCancel => 'Cannot cancel request';

  @override
  String get noRequestSelected => 'No request selected';

  @override
  String get requestInformation => 'Request Information';

  @override
  String get requestId => 'Request ID';

  @override
  String get requestedTo => 'Requested To';

  @override
  String get submittedOn => 'Submitted On';

  @override
  String get reviewedOn => 'Reviewed On';

  @override
  String get subsidyId => 'Subsidy ID';

  @override
  String get adminNotes => 'Admin Notes';

  @override
  String get cancelRequest => 'Cancel Request';

  @override
  String get cancelRequestConfirm =>
      'Are you sure you want to cancel this request? This action cannot be undone.';

  @override
  String get requestConverted => 'Request Converted!';

  @override
  String get convertedToSubsidy => 'Your request has been converted to';

  @override
  String get viewSubsidy => 'View Subsidy';

  @override
  String get requestSubsidyHint => 'Request a subsidy from government';

  @override
  String get fileComplaint => 'File a Complaint';

  @override
  String get myComplaints => 'My Complaints';

  @override
  String get complaintDetails => 'Complaint Details';

  @override
  String get reportYourIssue => 'Report Your Issue';

  @override
  String get weAreHereToHelp => 'We\'re here to help resolve your concerns';

  @override
  String get reportIssues => 'Report Issues';

  @override
  String get fileComplaints => 'File Complaints';

  @override
  String get reportProblemsToGovernment => 'Report your problems to government';

  @override
  String get complaintCategory => 'Complaint Category';

  @override
  String get priorityLevel => 'Priority Level';

  @override
  String get complaintTitle => 'Complaint Title';

  @override
  String get detailedDescription => 'Detailed Description';

  @override
  String get specificLocation => 'Specific Location';

  @override
  String get submitTo => 'Submit To';

  @override
  String get locationDetailsOptional => 'Location Details (Optional)';

  @override
  String get locationHint => 'e.g., Near school, Main road, etc.';

  @override
  String get enterComplaintTitle => 'Enter a brief title for your complaint';

  @override
  String get describeComplaint => 'Describe your complaint in detail...';

  @override
  String get pleaseProvideDescription => 'Please provide complaint description';

  @override
  String get descriptionMinLength =>
      'Description must be at least 20 characters';

  @override
  String get pleaseSelectCategory => 'Please select a complaint category';

  @override
  String get pleaseSelectPriority => 'Please select priority level';

  @override
  String get pleaseSelectLevel => 'Please select government level';

  @override
  String get cropDisease => 'Crop Disease';

  @override
  String get pestInfestation => 'Pest Infestation';

  @override
  String get irrigationIssue => 'Irrigation';

  @override
  String get roadInfrastructure => 'Road';

  @override
  String get fertilizerQuality => 'Fertilizer';

  @override
  String get seedQuality => 'Seeds';

  @override
  String get equipmentIssue => 'Equipment';

  @override
  String get waterSupply => 'Water';

  @override
  String get marketAccess => 'Market';

  @override
  String get extensionService => 'Extension';

  @override
  String get subsidyRelated => 'Subsidy';

  @override
  String get electricity => 'Electricity';

  @override
  String get other => 'Other';

  @override
  String get urgent => 'Urgent';

  @override
  String get high => 'High';

  @override
  String get medium => 'Medium';

  @override
  String get low => 'Low';

  @override
  String get centralLevel => 'Central Level';

  @override
  String get acknowledged => 'Acknowledged';

  @override
  String get underInvestigation => 'Under Investigation';

  @override
  String get inProgress => 'In Progress';

  @override
  String get forwarded => 'Forwarded';

  @override
  String get resolved => 'Resolved';

  @override
  String get closed => 'Closed';

  @override
  String get submitComplaint => 'Submit Complaint';

  @override
  String get newComplaint => 'New Complaint';

  @override
  String get cancelComplaint => 'Cancel Complaint';

  @override
  String get complaintSubmitted => 'Complaint submitted successfully!';

  @override
  String get complaintCancelled => 'Complaint cancelled successfully';

  @override
  String get failedToSubmit => 'Failed to submit complaint. Please try again.';

  @override
  String get failedToCancel => 'Failed to cancel complaint';

  @override
  String get noComplaintsFound => 'No complaints found';

  @override
  String get fileComplaintToGetStarted => 'File a complaint to get started';

  @override
  String get confirmCancelComplaint =>
      'Are you sure you want to cancel this complaint? This action cannot be undone.';

  @override
  String get noKeepIt => 'No, Keep It';

  @override
  String get all => 'All';

  @override
  String get priority => 'Priority';

  @override
  String get assignedTo => 'Assigned To';

  @override
  String get resolution => 'Resolution';

  @override
  String get resolvedOn => 'Resolved on';

  @override
  String get coordinates => 'Coordinates';

  @override
  String get latitude => 'Latitude';

  @override
  String get longitude => 'Longitude';

  @override
  String get enterLatitude => 'Enter latitude';

  @override
  String get enterLongitude => 'Enter longitude';

  @override
  String get getMyLocation => 'Get My Location';

  @override
  String get locationFetched => 'Location fetched successfully';

  @override
  String get failedToGetLocation => 'Failed to get location';

  @override
  String get attachment => 'Attachment';

  @override
  String get attachmentDescription => 'Attach a file (PDF, JPG, PNG - Max 5MB)';

  @override
  String get chooseFile => 'Choose File';

  @override
  String get fileAttached => 'File attached successfully';

  @override
  String get preview => 'Preview';

  @override
  String get remove => 'Remove';

  @override
  String get attachmentPreview => 'Attachment Preview';

  @override
  String attachmentsCount(int count) {
    return 'Attachments ($count)';
  }

  @override
  String get comments => 'Comments';

  @override
  String commentsCount(int count) {
    return 'Comments ($count)';
  }

  @override
  String get addComment => 'Add a comment...';

  @override
  String get pleaseEnterComment => 'Please enter a comment';

  @override
  String get commentMinLength => 'Comment must be at least 3 characters';

  @override
  String get commentAddedSuccessfully => 'Comment added successfully';

  @override
  String get failedToAddComment => 'Failed to add comment';

  @override
  String get send => 'Send';

  @override
  String get surveys => 'Surveys';

  @override
  String get survey => 'Survey';

  @override
  String get available => 'Available';

  @override
  String get completed => 'Completed';

  @override
  String get startSurvey => 'Start Survey';

  @override
  String get takeAgain => 'Take Again';

  @override
  String get canRetake => 'Can Retake';

  @override
  String questionsCount(String count) {
    return '$count Questions';
  }

  @override
  String respondedTimes(String count) {
    return 'Responded ${count}x';
  }

  @override
  String estimatedMinutes(String min) {
    return '~$min min';
  }

  @override
  String endsOn(String date) {
    return 'Ends: $date';
  }

  @override
  String get noAvailableSurveys => 'No Available Surveys';

  @override
  String get checkBackLater => 'Check back later for new surveys';

  @override
  String get noCompletedSurveys => 'No Completed Surveys';

  @override
  String get completeSurveysToSee => 'Complete surveys to see them here';

  @override
  String get noSurveysAvailable => 'No Surveys Available';

  @override
  String get noSurveysAvailableDesc =>
      'There are no surveys available for you at the moment';

  @override
  String get pullDownToRefresh => 'Pull down to refresh';

  @override
  String get surveyTypeCropProduction => 'Crop Production';

  @override
  String get surveyTypeLivestockCensus => 'Livestock Census';

  @override
  String get surveyTypeLandUsage => 'Land Usage';

  @override
  String get surveyTypeFarmerSatisfaction => 'Farmer Satisfaction';

  @override
  String get surveyTypeSubsidyImpact => 'Subsidy Impact';

  @override
  String get surveyTypeTrainingNeeds => 'Training Needs';

  @override
  String get surveyTypeMarketAccess => 'Market Access';

  @override
  String get surveyTypeGeneral => 'General Survey';

  @override
  String get noQuestionsFound => 'No questions found in this survey';

  @override
  String get answerAllRequired => 'Please answer all required questions';

  @override
  String get surveySubmittedSuccess => 'Survey submitted successfully';

  @override
  String get surveySubmitFailed => 'Failed to submit survey';

  @override
  String get validationError => 'Validation Error';

  @override
  String get checkRequiredFields => 'Please check all required fields';

  @override
  String get requiredQuestion => 'Required Question';

  @override
  String get noSurveySelected => 'No survey selected';

  @override
  String get loadingSurveyQuestions => 'Loading survey questions...';

  @override
  String get noQuestionsAvailable => 'No questions available for this survey';

  @override
  String get fileUploads => 'File Uploads';

  @override
  String get locationInformation => 'Location Information';

  @override
  String get instruction => 'Instruction';

  @override
  String get requiredLabel => 'Required';

  @override
  String get defaultEligibility =>
      'Small and marginal farmers with up to 2 hectares of cultivated land';

  @override
  String get fileUploaded => 'File uploaded successfully';

  @override
  String get enterYourAnswer => 'Enter your answer';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String minCharactersRequired(String count) {
    return 'Minimum $count characters required';
  }

  @override
  String get enterNumber => 'Enter a number';

  @override
  String get enterValidNumber => 'Please enter a valid number';

  @override
  String minValueIs(String value) {
    return 'Minimum value is $value';
  }

  @override
  String maxValueIs(String value) {
    return 'Maximum value is $value';
  }

  @override
  String get selectOption => 'Select an option';

  @override
  String get pleaseSelectOption => 'Please select an option';

  @override
  String get selectDate => 'Select a date';

  @override
  String ratingOutOf(String rating, String max) {
    return '$rating out of $max';
  }

  @override
  String get allowedFileFormats => 'PDF, JPG, PNG, DOC';

  @override
  String get maxFileSizeLabel => 'Max 5 MB';

  @override
  String get currentLocation => 'Current Location';

  @override
  String get currentLocationSet => 'Current location has been set';

  @override
  String get locationSet => 'Location Set';

  @override
  String get chooseOnMap => 'Choose on Map';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get mapPickerComingSoon => 'Map picker feature coming soon';

  @override
  String latLngLabel(String lat, String lng) {
    return 'Lat: $lat, Lng: $lng';
  }

  @override
  String get importantNoteLabel => 'Important Note';

  @override
  String get surveyImportantNote =>
      'All required questions must be answered before submission. Your responses will help improve agricultural services.';

  @override
  String get submitting => 'Submitting...';

  @override
  String get submitSurvey => 'Submit Survey';
}
