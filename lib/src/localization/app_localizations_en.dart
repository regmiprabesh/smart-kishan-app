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
  String get farmlands => 'Farmlands';

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
  String get requestDetails => 'Request Details';

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
}
