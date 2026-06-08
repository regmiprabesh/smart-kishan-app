import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ne.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ne')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Kishan'**
  String get appTitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguageMsg.
  ///
  /// In en, this message translates to:
  /// **'Please select your preferred language'**
  String get selectLanguageMsg;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @loginMsg.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to continue.'**
  String get loginMsg;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneNumber;

  /// No description provided for @inputPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter Phone Number'**
  String get inputPhone;

  /// No description provided for @inputPhoneMsg.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get inputPhoneMsg;

  /// No description provided for @enterValidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid phone number!'**
  String get enterValidPhone;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @inputPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Password'**
  String get inputPassword;

  /// No description provided for @inputPasswordMsg.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get inputPasswordMsg;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account'**
  String get noAccount;

  /// No description provided for @registerNow.
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get registerNow;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @navigateForgotPwdMsgBefore.
  ///
  /// In en, this message translates to:
  /// **'Forgot Your '**
  String get navigateForgotPwdMsgBefore;

  /// No description provided for @navigateForgotPwdMsgAfter.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get navigateForgotPwdMsgAfter;

  /// No description provided for @nextPage.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextPage;

  /// No description provided for @story1Title.
  ///
  /// In en, this message translates to:
  /// **'Farming Made Easier'**
  String get story1Title;

  /// No description provided for @story2Title.
  ///
  /// In en, this message translates to:
  /// **'Manage Multiple Farmlands'**
  String get story2Title;

  /// No description provided for @story3Title.
  ///
  /// In en, this message translates to:
  /// **'Organize Farm Stock Efficiently'**
  String get story3Title;

  /// No description provided for @story4Title.
  ///
  /// In en, this message translates to:
  /// **'Quick Notes for Fast Reminders'**
  String get story4Title;

  /// No description provided for @story1Desc.
  ///
  /// In en, this message translates to:
  /// **'Simplify farm management with tools designed to help you grow and succeed effortlessly.'**
  String get story1Desc;

  /// No description provided for @story2Desc.
  ///
  /// In en, this message translates to:
  /// **'Store and track data from different farmlands, customized for each plot.'**
  String get story2Desc;

  /// No description provided for @story3Desc.
  ///
  /// In en, this message translates to:
  /// **'Keep a clear record of all farm supplies and stock levels in one place.'**
  String get story3Desc;

  /// No description provided for @story4Desc.
  ///
  /// In en, this message translates to:
  /// **'Note down important tasks or ideas instantly to stay organized and on top of your farm\'s needs.'**
  String get story4Desc;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get createAccountTitle;

  /// No description provided for @createAccountDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number to continue, we will send you OTP to verify'**
  String get createAccountDesc;

  /// No description provided for @requestOTP.
  ///
  /// In en, this message translates to:
  /// **'Request OTP'**
  String get requestOTP;

  /// No description provided for @wrongPhonePassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong phone / password'**
  String get wrongPhonePassword;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Your account has been created successfully!'**
  String get accountCreated;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully. Please sign in.'**
  String get passwordResetSuccess;

  /// No description provided for @passwordResetFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not change password.'**
  String get passwordResetFailed;

  /// No description provided for @logoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong! Please try again.'**
  String get logoutFailed;

  /// No description provided for @otpSent.
  ///
  /// In en, this message translates to:
  /// **'A verification code has been sent to your phone.'**
  String get otpSent;

  /// No description provided for @otpResent.
  ///
  /// In en, this message translates to:
  /// **'A new verification code has been sent to your phone.'**
  String get otpResent;

  /// No description provided for @phoneAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'This phone number is already registered.'**
  String get phoneAlreadyRegistered;

  /// No description provided for @phoneNotRegistered.
  ///
  /// In en, this message translates to:
  /// **'This phone number is not registered.'**
  String get phoneNotRegistered;

  /// No description provided for @otpThrottled.
  ///
  /// In en, this message translates to:
  /// **'Please wait {seconds} seconds before requesting another code.'**
  String otpThrottled(String seconds);

  /// No description provided for @otpSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not send the verification code.'**
  String get otpSendFailed;

  /// No description provided for @otpInvalid.
  ///
  /// In en, this message translates to:
  /// **'The verification code is incorrect.'**
  String get otpInvalid;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get genericError;

  /// No description provided for @loginThrottled.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait {seconds} seconds and try again.'**
  String loginThrottled(String seconds);

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please log in again.'**
  String get sessionExpired;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t connect. Please check your internet connection and try again.'**
  String get noInternet;

  /// No description provided for @alreadyAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyAccount;

  /// No description provided for @signInNav.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get signInNav;

  /// No description provided for @forgotPwdTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Your Password?'**
  String get forgotPwdTitle;

  /// No description provided for @forgotPwdDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number to continue, we will send you verification code to reset your password.'**
  String get forgotPwdDesc;

  /// No description provided for @noForget.
  ///
  /// In en, this message translates to:
  /// **'Back to '**
  String get noForget;

  /// No description provided for @knowAboutCrops.
  ///
  /// In en, this message translates to:
  /// **'Want to know about different crops?'**
  String get knowAboutCrops;

  /// No description provided for @crops.
  ///
  /// In en, this message translates to:
  /// **'Crops'**
  String get crops;

  /// No description provided for @clickHere.
  ///
  /// In en, this message translates to:
  /// **'Click Here!'**
  String get clickHere;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @chart.
  ///
  /// In en, this message translates to:
  /// **'Chart'**
  String get chart;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @dailyActivities.
  ///
  /// In en, this message translates to:
  /// **'Daily \n Activity'**
  String get dailyActivities;

  /// No description provided for @dailyActivity.
  ///
  /// In en, this message translates to:
  /// **'Daily Activity'**
  String get dailyActivity;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @sales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get sales;

  /// No description provided for @farmlands.
  ///
  /// In en, this message translates to:
  /// **'Farmlands'**
  String get farmlands;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @noNotesMsg.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any notes yet!'**
  String get noNotesMsg;

  /// No description provided for @c.
  ///
  /// In en, this message translates to:
  /// **'C'**
  String get c;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchHint;

  /// No description provided for @sellerMode.
  ///
  /// In en, this message translates to:
  /// **'Seller Mode'**
  String get sellerMode;

  /// No description provided for @buyerMode.
  ///
  /// In en, this message translates to:
  /// **'Buyer Mode'**
  String get buyerMode;

  /// No description provided for @farmerMode.
  ///
  /// In en, this message translates to:
  /// **'Farmer Mode'**
  String get farmerMode;

  /// No description provided for @myDeliveryLocations.
  ///
  /// In en, this message translates to:
  /// **'My Delivery Address'**
  String get myDeliveryLocations;

  /// No description provided for @myCart.
  ///
  /// In en, this message translates to:
  /// **'My Cart'**
  String get myCart;

  /// No description provided for @myProductOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myProductOrders;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @market.
  ///
  /// In en, this message translates to:
  /// **'MarketPlace'**
  String get market;

  /// No description provided for @noItems.
  ///
  /// In en, this message translates to:
  /// **'No Items'**
  String get noItems;

  /// No description provided for @yourCart.
  ///
  /// In en, this message translates to:
  /// **'Your Cart'**
  String get yourCart;

  /// No description provided for @buyProducts.
  ///
  /// In en, this message translates to:
  /// **'Buy Products'**
  String get buyProducts;

  /// No description provided for @yourCartIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your Cart is Empty!'**
  String get yourCartIsEmpty;

  /// No description provided for @cartMessage.
  ///
  /// In en, this message translates to:
  /// **'You will see products here once you start adding to your cart!'**
  String get cartMessage;

  /// No description provided for @shoppingCart.
  ///
  /// In en, this message translates to:
  /// **'Shopping Cart'**
  String get shoppingCart;

  /// No description provided for @results.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get results;

  /// No description provided for @showingDefaultProducts.
  ///
  /// In en, this message translates to:
  /// **'Showing Default Results'**
  String get showingDefaultProducts;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// No description provided for @defaultResults.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultResults;

  /// No description provided for @recentlyAdded.
  ///
  /// In en, this message translates to:
  /// **'Recently Added'**
  String get recentlyAdded;

  /// No description provided for @priceLowToHigh.
  ///
  /// In en, this message translates to:
  /// **'Price: Low to High'**
  String get priceLowToHigh;

  /// No description provided for @priceHighToLow.
  ///
  /// In en, this message translates to:
  /// **'Price: High to Low'**
  String get priceHighToLow;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get allCategories;

  /// No description provided for @paymentTypes.
  ///
  /// In en, this message translates to:
  /// **'Payment Types'**
  String get paymentTypes;

  /// No description provided for @whatAreYouLookingFor.
  ///
  /// In en, this message translates to:
  /// **'What are you looking for?'**
  String get whatAreYouLookingFor;

  /// No description provided for @buyItNow.
  ///
  /// In en, this message translates to:
  /// **'Buy it Now'**
  String get buyItNow;

  /// No description provided for @addToBag.
  ///
  /// In en, this message translates to:
  /// **'Add to Bag'**
  String get addToBag;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @featuredProducts.
  ///
  /// In en, this message translates to:
  /// **'Featured Products'**
  String get featuredProducts;

  /// No description provided for @searchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search Products'**
  String get searchProducts;

  /// No description provided for @noResultFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultFound;

  /// No description provided for @noResultFoundDesc.
  ///
  /// In en, this message translates to:
  /// **'No results found. Please try again.'**
  String get noResultFoundDesc;

  /// No description provided for @exploreCategories.
  ///
  /// In en, this message translates to:
  /// **'Explore Categories'**
  String get exploreCategories;

  /// No description provided for @myDeliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'My Delivery Address'**
  String get myDeliveryAddress;

  /// No description provided for @addNewAddress.
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get addNewAddress;

  /// No description provided for @deliveryChargesInfo.
  ///
  /// In en, this message translates to:
  /// **'Delivery charges may vary depending on the farmer and your location.'**
  String get deliveryChargesInfo;

  /// No description provided for @noDeliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'You have not added any delivery address yet. Please add a new address to continue your order process.'**
  String get noDeliveryAddress;

  /// No description provided for @updateAddress.
  ///
  /// In en, this message translates to:
  /// **'Update Address'**
  String get updateAddress;

  /// No description provided for @addressTitle.
  ///
  /// In en, this message translates to:
  /// **'Address Title'**
  String get addressTitle;

  /// No description provided for @enterAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter address title'**
  String get enterAddressTitle;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @enterCityName.
  ///
  /// In en, this message translates to:
  /// **'Please enter name of your city'**
  String get enterCityName;

  /// No description provided for @addressDescription.
  ///
  /// In en, this message translates to:
  /// **'Address Description'**
  String get addressDescription;

  /// No description provided for @addressDescriptionLandmark.
  ///
  /// In en, this message translates to:
  /// **'Address Description/Landmark'**
  String get addressDescriptionLandmark;

  /// No description provided for @enterAddressDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter address description'**
  String get enterAddressDescription;

  /// No description provided for @setAsDefaultAddress.
  ///
  /// In en, this message translates to:
  /// **'Set as default address'**
  String get setAsDefaultAddress;

  /// No description provided for @saveAddress.
  ///
  /// In en, this message translates to:
  /// **'Save Address'**
  String get saveAddress;

  /// No description provided for @addNewAddressButton.
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get addNewAddressButton;

  /// No description provided for @showingNewestResults.
  ///
  /// In en, this message translates to:
  /// **'Showing Recently Added'**
  String get showingNewestResults;

  /// No description provided for @searchResultFor.
  ///
  /// In en, this message translates to:
  /// **'Showing result for \'{name}\''**
  String searchResultFor(Object name);

  /// No description provided for @showingLowToHighResults.
  ///
  /// In en, this message translates to:
  /// **'Showing Price: Low to High'**
  String get showingLowToHighResults;

  /// No description provided for @showingHighToLowResults.
  ///
  /// In en, this message translates to:
  /// **'Showing Price: High to Low'**
  String get showingHighToLowResults;

  /// No description provided for @showingDefaultResults.
  ///
  /// In en, this message translates to:
  /// **'Showing Default Results'**
  String get showingDefaultResults;

  /// No description provided for @productResults.
  ///
  /// In en, this message translates to:
  /// **'{count} Result{count, plural, one {} other {s}}'**
  String productResults(num count);

  /// No description provided for @filterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter {title}'**
  String filterTitle(Object title);

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @searchHistory.
  ///
  /// In en, this message translates to:
  /// **'Search History'**
  String get searchHistory;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Nrs.'**
  String get currency;

  /// No description provided for @minimumOrder.
  ///
  /// In en, this message translates to:
  /// **'Minimum Order'**
  String get minimumOrder;

  /// No description provided for @acceptedPaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Accepted payment methods'**
  String get acceptedPaymentMethods;

  /// No description provided for @deliveryLocations.
  ///
  /// In en, this message translates to:
  /// **'Delivery Locations'**
  String get deliveryLocations;

  /// No description provided for @additionalNotes.
  ///
  /// In en, this message translates to:
  /// **'Additional Notes'**
  String get additionalNotes;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @checkOut.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkOut;

  /// No description provided for @cartItems.
  ///
  /// In en, this message translates to:
  /// **'item{count, plural, =1{} other{s}}'**
  String cartItems(num count);

  /// No description provided for @quantityShort.
  ///
  /// In en, this message translates to:
  /// **'Qty.'**
  String get quantityShort;

  /// No description provided for @deleteCartTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Cart Item'**
  String get deleteCartTitle;

  /// No description provided for @deleteCartMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this product from your cart?'**
  String get deleteCartMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @selectDeliveryLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Delivery Location'**
  String get selectDeliveryLocation;

  /// No description provided for @confirmOrder.
  ///
  /// In en, this message translates to:
  /// **'Confirm Order'**
  String get confirmOrder;

  /// No description provided for @deleteDeliveryAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Delivery Address'**
  String get deleteDeliveryAddressTitle;

  /// No description provided for @deleteDeliveryAddressMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this delivery address?'**
  String get deleteDeliveryAddressMessage;

  /// No description provided for @orderConfirmedTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Confirmed'**
  String get orderConfirmedTitle;

  /// No description provided for @orderConfirmedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your order has been placed successfully. You can track your orders from order history.'**
  String get orderConfirmedMessage;

  /// No description provided for @continueShopping.
  ///
  /// In en, this message translates to:
  /// **'Continue Shopping'**
  String get continueShopping;

  /// No description provided for @haveAnyQuestions.
  ///
  /// In en, this message translates to:
  /// **'Have any questions?'**
  String get haveAnyQuestions;

  /// No description provided for @connectToUs.
  ///
  /// In en, this message translates to:
  /// **'Connect to us'**
  String get connectToUs;

  /// No description provided for @deliveryLocation.
  ///
  /// In en, this message translates to:
  /// **'Delivery Location'**
  String get deliveryLocation;

  /// No description provided for @notSelected.
  ///
  /// In en, this message translates to:
  /// **'Not Selected'**
  String get notSelected;

  /// No description provided for @myOrder.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrder;

  /// No description provided for @activeOrders.
  ///
  /// In en, this message translates to:
  /// **'Active Orders'**
  String get activeOrders;

  /// No description provided for @inactiveOrders.
  ///
  /// In en, this message translates to:
  /// **'Inactive Orders'**
  String get inactiveOrders;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @orderPlaced.
  ///
  /// In en, this message translates to:
  /// **'Order Placed'**
  String get orderPlaced;

  /// No description provided for @orderReceived.
  ///
  /// In en, this message translates to:
  /// **'We have received your order.'**
  String get orderReceived;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @orderConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Your order has been confirmed.'**
  String get orderConfirmed;

  /// No description provided for @shipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get shipped;

  /// No description provided for @orderShipped.
  ///
  /// In en, this message translates to:
  /// **'We are preparing your order.'**
  String get orderShipped;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @orderDelivered.
  ///
  /// In en, this message translates to:
  /// **'Your order has been delivered.'**
  String get orderDelivered;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @orderCancelled.
  ///
  /// In en, this message translates to:
  /// **'Your order has been cancelled.'**
  String get orderCancelled;

  /// No description provided for @cancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get cancelOrder;

  /// No description provided for @vendorNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Vendor Not Available'**
  String get vendorNotAvailable;

  /// No description provided for @customerNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Customer Not Available'**
  String get customerNotAvailable;

  /// No description provided for @productNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Product Not Available'**
  String get productNotAvailable;

  /// No description provided for @noActiveOrders.
  ///
  /// In en, this message translates to:
  /// **'Your active orders list is empty'**
  String get noActiveOrders;

  /// No description provided for @noOrdersMessage.
  ///
  /// In en, this message translates to:
  /// **'You will see orders here once you place your order'**
  String get noOrdersMessage;

  /// No description provided for @seller.
  ///
  /// In en, this message translates to:
  /// **'Seller'**
  String get seller;

  /// No description provided for @noPhoneAvailable.
  ///
  /// In en, this message translates to:
  /// **'Phone number not available'**
  String get noPhoneAvailable;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @cancelOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get cancelOrderTitle;

  /// No description provided for @cancelOrderMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this order?'**
  String get cancelOrderMessage;

  /// No description provided for @inactiveOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'Your inactive orders list is empty'**
  String get inactiveOrdersTitle;

  /// No description provided for @inactiveOrdersDescription.
  ///
  /// In en, this message translates to:
  /// **'You will see orders here once your order completes or gets cancelled.'**
  String get inactiveOrdersDescription;

  /// No description provided for @myProducts.
  ///
  /// In en, this message translates to:
  /// **'My Products'**
  String get myProducts;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @grossSales.
  ///
  /// In en, this message translates to:
  /// **'Gross Sales'**
  String get grossSales;

  /// No description provided for @averageSales.
  ///
  /// In en, this message translates to:
  /// **'Average Sales'**
  String get averageSales;

  /// No description provided for @totalProducts.
  ///
  /// In en, this message translates to:
  /// **'Total Products'**
  String get totalProducts;

  /// No description provided for @totalOrders.
  ///
  /// In en, this message translates to:
  /// **'Total Orders'**
  String get totalOrders;

  /// No description provided for @recentOrders.
  ///
  /// In en, this message translates to:
  /// **'Recent Orders'**
  String get recentOrders;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @jan.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get jan;

  /// No description provided for @feb.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get feb;

  /// No description provided for @mar.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get mar;

  /// No description provided for @apr.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get apr;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @jun.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get jun;

  /// No description provided for @jul.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get jul;

  /// No description provided for @aug.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get aug;

  /// No description provided for @sep.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get sep;

  /// No description provided for @oct.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get oct;

  /// No description provided for @nov.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get nov;

  /// No description provided for @dec.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get dec;

  /// No description provided for @customerName.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customerName;

  /// No description provided for @orderStatus.
  ///
  /// In en, this message translates to:
  /// **'Order Status'**
  String get orderStatus;

  /// No description provided for @buyersGroups.
  ///
  /// In en, this message translates to:
  /// **'Buyers Groups'**
  String get buyersGroups;

  /// No description provided for @sellProduct.
  ///
  /// In en, this message translates to:
  /// **'Sell Product'**
  String get sellProduct;

  /// No description provided for @myProductsForSale.
  ///
  /// In en, this message translates to:
  /// **'My Products'**
  String get myProductsForSale;

  /// No description provided for @emptyProductList.
  ///
  /// In en, this message translates to:
  /// **'Your current product list is empty.'**
  String get emptyProductList;

  /// No description provided for @addProductForSale.
  ///
  /// In en, this message translates to:
  /// **'Add products for sale.'**
  String get addProductForSale;

  /// No description provided for @addSaleProduct.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addSaleProduct;

  /// No description provided for @inStock.
  ///
  /// In en, this message translates to:
  /// **'In Stock'**
  String get inStock;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @vendorNewOrderMessage.
  ///
  /// In en, this message translates to:
  /// **'A new order has been placed.'**
  String get vendorNewOrderMessage;

  /// No description provided for @vendorProcessingMessage.
  ///
  /// In en, this message translates to:
  /// **'You have confirmed the order.'**
  String get vendorProcessingMessage;

  /// No description provided for @vendorShippedMessage.
  ///
  /// In en, this message translates to:
  /// **'You have shipped the order.'**
  String get vendorShippedMessage;

  /// No description provided for @vendorDeliveredMessage.
  ///
  /// In en, this message translates to:
  /// **'You have delivered the order.'**
  String get vendorDeliveredMessage;

  /// No description provided for @vendorCancelledMessage.
  ///
  /// In en, this message translates to:
  /// **'The order has been cancelled.'**
  String get vendorCancelledMessage;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'ग्राहक'**
  String get customer;

  /// No description provided for @updateOrder.
  ///
  /// In en, this message translates to:
  /// **'Update Order'**
  String get updateOrder;

  /// No description provided for @updateOrderStatus.
  ///
  /// In en, this message translates to:
  /// **'Update Order Status'**
  String get updateOrderStatus;

  /// No description provided for @chooseNewStatus.
  ///
  /// In en, this message translates to:
  /// **'Choose a new status for this order.'**
  String get chooseNewStatus;

  /// No description provided for @recommendedVegetables.
  ///
  /// In en, this message translates to:
  /// **'Recommended Vegetables'**
  String get recommendedVegetables;

  /// No description provided for @recommendedFruit.
  ///
  /// In en, this message translates to:
  /// **'Recommended Fruits'**
  String get recommendedFruit;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// No description provided for @inventoryBroken.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventoryBroken;

  /// No description provided for @activeVendorOrdersDescription.
  ///
  /// In en, this message translates to:
  /// **'You will see orders here once you start receiving orders.'**
  String get activeVendorOrdersDescription;

  /// No description provided for @kalimatiPrice.
  ///
  /// In en, this message translates to:
  /// **'Kalimati Price'**
  String get kalimatiPrice;

  /// No description provided for @subsidies.
  ///
  /// In en, this message translates to:
  /// **'Government Subsidies'**
  String get subsidies;

  /// No description provided for @myApplications.
  ///
  /// In en, this message translates to:
  /// **'My Applications'**
  String get myApplications;

  /// No description provided for @noSubsidies.
  ///
  /// In en, this message translates to:
  /// **'No subsidies available at the moment!'**
  String get noSubsidies;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @requestSubsidy.
  ///
  /// In en, this message translates to:
  /// **'Request Subsidy'**
  String get requestSubsidy;

  /// No description provided for @applied.
  ///
  /// In en, this message translates to:
  /// **'Applied'**
  String get applied;

  /// No description provided for @applyNow.
  ///
  /// In en, this message translates to:
  /// **'Apply Now'**
  String get applyNow;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @less.
  ///
  /// In en, this message translates to:
  /// **'Less'**
  String get less;

  /// No description provided for @deadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get deadline;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @eligibility.
  ///
  /// In en, this message translates to:
  /// **'Eligibility Criteria'**
  String get eligibility;

  /// No description provided for @targetSector.
  ///
  /// In en, this message translates to:
  /// **'Target Crop/Sector'**
  String get targetSector;

  /// No description provided for @locationLevel.
  ///
  /// In en, this message translates to:
  /// **'Location Level'**
  String get locationLevel;

  /// No description provided for @subsidyDetails.
  ///
  /// In en, this message translates to:
  /// **'Subsidy Details'**
  String get subsidyDetails;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @fiscalYear.
  ///
  /// In en, this message translates to:
  /// **'Fiscal Year'**
  String get fiscalYear;

  /// No description provided for @expectedBeneficiaries.
  ///
  /// In en, this message translates to:
  /// **'Expected Beneficiaries'**
  String get expectedBeneficiaries;

  /// No description provided for @budgetPerBeneficiary.
  ///
  /// In en, this message translates to:
  /// **'Budget Per Beneficiary'**
  String get budgetPerBeneficiary;

  /// No description provided for @totalBudget.
  ///
  /// In en, this message translates to:
  /// **'Total Budget'**
  String get totalBudget;

  /// No description provided for @lastDate.
  ///
  /// In en, this message translates to:
  /// **'Last Date'**
  String get lastDate;

  /// No description provided for @locationDetails.
  ///
  /// In en, this message translates to:
  /// **'Location Details'**
  String get locationDetails;

  /// No description provided for @province.
  ///
  /// In en, this message translates to:
  /// **'Province'**
  String get province;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @municipality.
  ///
  /// In en, this message translates to:
  /// **'Municipality'**
  String get municipality;

  /// No description provided for @ward.
  ///
  /// In en, this message translates to:
  /// **'Ward'**
  String get ward;

  /// No description provided for @alreadyApplied.
  ///
  /// In en, this message translates to:
  /// **'Already Applied'**
  String get alreadyApplied;

  /// No description provided for @deadlinePassed.
  ///
  /// In en, this message translates to:
  /// **'Deadline Passed'**
  String get deadlinePassed;

  /// No description provided for @applyForSubsidy.
  ///
  /// In en, this message translates to:
  /// **'Apply for Subsidy'**
  String get applyForSubsidy;

  /// No description provided for @applicationNotes.
  ///
  /// In en, this message translates to:
  /// **'Application Notes'**
  String get applicationNotes;

  /// No description provided for @explainEligibility.
  ///
  /// In en, this message translates to:
  /// **'Explain why you are eligible for this subsidy'**
  String get explainEligibility;

  /// No description provided for @enterNotes.
  ///
  /// In en, this message translates to:
  /// **'Enter your application notes here...'**
  String get enterNotes;

  /// No description provided for @submitApplication.
  ///
  /// In en, this message translates to:
  /// **'Submit Application'**
  String get submitApplication;

  /// No description provided for @noSubsidySelected.
  ///
  /// In en, this message translates to:
  /// **'No subsidy selected'**
  String get noSubsidySelected;

  /// No description provided for @applicationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Application submitted successfully'**
  String get applicationSuccessful;

  /// No description provided for @applicationFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit the application'**
  String get applicationFailed;

  /// No description provided for @enterApplicationNotes.
  ///
  /// In en, this message translates to:
  /// **'Please enter application notes'**
  String get enterApplicationNotes;

  /// No description provided for @min10Characters.
  ///
  /// In en, this message translates to:
  /// **'Please enter at least 10 characters'**
  String get min10Characters;

  /// No description provided for @importantNote.
  ///
  /// In en, this message translates to:
  /// **'Your application will be reviewed. Please provide correct information.'**
  String get importantNote;

  /// No description provided for @rateReview.
  ///
  /// In en, this message translates to:
  /// **'Rate & Review'**
  String get rateReview;

  /// No description provided for @rateSubsidy.
  ///
  /// In en, this message translates to:
  /// **'How would you rate this subsidy?'**
  String get rateSubsidy;

  /// No description provided for @shareExperience.
  ///
  /// In en, this message translates to:
  /// **'Share Your Experience'**
  String get shareExperience;

  /// No description provided for @submitReview.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submitReview;

  /// No description provided for @poor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get poor;

  /// No description provided for @fair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get fair;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @veryGood.
  ///
  /// In en, this message translates to:
  /// **'Very Good'**
  String get veryGood;

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellent;

  /// No description provided for @reviewSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Review Submitted Successfully!'**
  String get reviewSubmitted;

  /// No description provided for @thankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback.'**
  String get thankYou;

  /// No description provided for @untitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get untitled;

  /// No description provided for @noInfo.
  ///
  /// In en, this message translates to:
  /// **'No information available'**
  String get noInfo;

  /// No description provided for @noDeadline.
  ///
  /// In en, this message translates to:
  /// **'No deadline'**
  String get noDeadline;

  /// No description provided for @fertilizer.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer'**
  String get fertilizer;

  /// No description provided for @equipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get equipment;

  /// No description provided for @training.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get training;

  /// No description provided for @irrigation.
  ///
  /// In en, this message translates to:
  /// **'Irrigation'**
  String get irrigation;

  /// No description provided for @livestock.
  ///
  /// In en, this message translates to:
  /// **'Livestock'**
  String get livestock;

  /// No description provided for @seeds.
  ///
  /// In en, this message translates to:
  /// **'Seeds'**
  String get seeds;

  /// No description provided for @insurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get insurance;

  /// No description provided for @loan.
  ///
  /// In en, this message translates to:
  /// **'Loan'**
  String get loan;

  /// No description provided for @organic.
  ///
  /// In en, this message translates to:
  /// **'Organic'**
  String get organic;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @central.
  ///
  /// In en, this message translates to:
  /// **'Central'**
  String get central;

  /// No description provided for @provinceLevel.
  ///
  /// In en, this message translates to:
  /// **'Province Level'**
  String get provinceLevel;

  /// No description provided for @districtLevel.
  ///
  /// In en, this message translates to:
  /// **'District Level'**
  String get districtLevel;

  /// No description provided for @municipalityLevel.
  ///
  /// In en, this message translates to:
  /// **'Municipality Level'**
  String get municipalityLevel;

  /// No description provided for @wardLevel.
  ///
  /// In en, this message translates to:
  /// **'Ward Level'**
  String get wardLevel;

  /// No description provided for @requestNewSubsidy.
  ///
  /// In en, this message translates to:
  /// **'Request New Subsidy'**
  String get requestNewSubsidy;

  /// No description provided for @subsidyTitle.
  ///
  /// In en, this message translates to:
  /// **'Subsidy Title'**
  String get subsidyTitle;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe why this subsidy is needed...'**
  String get descriptionHint;

  /// No description provided for @submitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get submitRequest;

  /// No description provided for @subsidyRequestSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Subsidy request submitted successfully'**
  String get subsidyRequestSubmitted;

  /// No description provided for @tellOtherFarmers.
  ///
  /// In en, this message translates to:
  /// **'Tell other farmers about your experience with this subsidy...'**
  String get tellOtherFarmers;

  /// No description provided for @tipMention.
  ///
  /// In en, this message translates to:
  /// **'Tip: Mention application process, approval time, or benefits received'**
  String get tipMention;

  /// No description provided for @reviewHelps.
  ///
  /// In en, this message translates to:
  /// **'Your review helps other farmers make informed decisions.'**
  String get reviewHelps;

  /// No description provided for @noApplicationsYet.
  ///
  /// In en, this message translates to:
  /// **'You have not submitted any applications yet!'**
  String get noApplicationsYet;

  /// No description provided for @withdrawApplication.
  ///
  /// In en, this message translates to:
  /// **'Withdraw Application'**
  String get withdrawApplication;

  /// No description provided for @withdrawConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to withdraw your application for'**
  String get withdrawConfirm;

  /// No description provided for @applicationWithdrawn.
  ///
  /// In en, this message translates to:
  /// **'Application withdrawn successfully!'**
  String get applicationWithdrawn;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @requiredDocumentsForApplication.
  ///
  /// In en, this message translates to:
  /// **'Required Documents for Application'**
  String get requiredDocumentsForApplication;

  /// No description provided for @subsidyDetailDocuments.
  ///
  /// In en, this message translates to:
  /// **'Subsidy Detail Documents'**
  String get subsidyDetailDocuments;

  /// No description provided for @documentsUploadWarning.
  ///
  /// In en, this message translates to:
  /// **'You will need to upload these documents when applying'**
  String get documentsUploadWarning;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'REQUIRED'**
  String get required;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @document.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get document;

  /// No description provided for @cannotOpenDocument.
  ///
  /// In en, this message translates to:
  /// **'Cannot open document'**
  String get cannotOpenDocument;

  /// No description provided for @page.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get page;

  /// No description provided for @ofTxt.
  ///
  /// In en, this message translates to:
  /// **'ofTxt'**
  String get ofTxt;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @errorLoadingPdf.
  ///
  /// In en, this message translates to:
  /// **'Error loading PDF'**
  String get errorLoadingPdf;

  /// No description provided for @applicationForm.
  ///
  /// In en, this message translates to:
  /// **'Application Form'**
  String get applicationForm;

  /// No description provided for @uploadFile.
  ///
  /// In en, this message translates to:
  /// **'Upload File'**
  String get uploadFile;

  /// No description provided for @changeFile.
  ///
  /// In en, this message translates to:
  /// **'Change File'**
  String get changeFile;

  /// No description provided for @errorLoadingImage.
  ///
  /// In en, this message translates to:
  /// **'Error loading image'**
  String get errorLoadingImage;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @validationErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Validation Error'**
  String get validationErrorMessage;

  /// No description provided for @pleaseCheckAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please check all required fields'**
  String get pleaseCheckAllFields;

  /// No description provided for @documentRequired.
  ///
  /// In en, this message translates to:
  /// **'Document Required'**
  String get documentRequired;

  /// No description provided for @invalidFileType.
  ///
  /// In en, this message translates to:
  /// **'Invalid File Type'**
  String get invalidFileType;

  /// No description provided for @pleaseUpload.
  ///
  /// In en, this message translates to:
  /// **'Please upload a file of type: {types}'**
  String pleaseUpload(Object types);

  /// No description provided for @fileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'File size must be less than 5MB'**
  String get fileTooLarge;

  /// No description provided for @maximumFileSize.
  ///
  /// In en, this message translates to:
  /// **'Maximum file size is {size} MB'**
  String maximumFileSize(Object size);

  /// No description provided for @uploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get uploaded;

  /// No description provided for @documentUploadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Document uploaded successfully'**
  String get documentUploadedSuccessfully;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @failedToPickFile.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick file'**
  String get failedToPickFile;

  /// No description provided for @applicationWithdrawFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to withdraw application'**
  String get applicationWithdrawFailed;

  /// No description provided for @withdrawWarningMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to withdraw your application?'**
  String get withdrawWarningMessage;

  /// No description provided for @withdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdraw;

  /// No description provided for @subsidyInformation.
  ///
  /// In en, this message translates to:
  /// **'Subsidy Information'**
  String get subsidyInformation;

  /// No description provided for @applicationTimeline.
  ///
  /// In en, this message translates to:
  /// **'Application Timeline'**
  String get applicationTimeline;

  /// No description provided for @appliedOn.
  ///
  /// In en, this message translates to:
  /// **'Applied On'**
  String get appliedOn;

  /// No description provided for @submittedInformation.
  ///
  /// In en, this message translates to:
  /// **'Submitted Information'**
  String get submittedInformation;

  /// No description provided for @uploadedDocuments.
  ///
  /// In en, this message translates to:
  /// **'Uploaded Documents'**
  String get uploadedDocuments;

  /// No description provided for @applicationId.
  ///
  /// In en, this message translates to:
  /// **'Application ID'**
  String get applicationId;

  /// No description provided for @startApplyingMessage.
  ///
  /// In en, this message translates to:
  /// **'Start applying for subsidies to see them here'**
  String get startApplyingMessage;

  /// No description provided for @exploreSubsidies.
  ///
  /// In en, this message translates to:
  /// **'Explore Subsidies'**
  String get exploreSubsidies;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @congratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get congratulations;

  /// No description provided for @applicationApprovedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your application has been approved. Further instructions will be provided soon.'**
  String get applicationApprovedMessage;

  /// No description provided for @applicationRejected.
  ///
  /// In en, this message translates to:
  /// **'Application Rejected'**
  String get applicationRejected;

  /// No description provided for @applicationRejectedMessage.
  ///
  /// In en, this message translates to:
  /// **'Unfortunately, your application was not approved. You may reapply if eligible.'**
  String get applicationRejectedMessage;

  /// No description provided for @underReview.
  ///
  /// In en, this message translates to:
  /// **'Under Review'**
  String get underReview;

  /// No description provided for @applicationPendingMessage.
  ///
  /// In en, this message translates to:
  /// **'Your application is being reviewed. We will notify you once a decision is made.'**
  String get applicationPendingMessage;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @applicationDetails.
  ///
  /// In en, this message translates to:
  /// **'Application Details'**
  String get applicationDetails;

  /// No description provided for @submitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get submitted;

  /// No description provided for @reviewed.
  ///
  /// In en, this message translates to:
  /// **'Reviewed'**
  String get reviewed;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @subsidyType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get subsidyType;

  /// No description provided for @fromReviewer.
  ///
  /// In en, this message translates to:
  /// **'From Reviewer'**
  String get fromReviewer;

  /// No description provided for @notesDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'These notes are provided by the application reviewer with text notes.'**
  String get notesDisclaimer;

  /// No description provided for @updateReview.
  ///
  /// In en, this message translates to:
  /// **'Update Review'**
  String get updateReview;

  /// No description provided for @ratingFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit rating'**
  String get ratingFailed;

  /// No description provided for @deleteRating.
  ///
  /// In en, this message translates to:
  /// **'Delete Rating'**
  String get deleteRating;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @deleteRatingConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your rating?'**
  String get deleteRatingConfirm;

  /// No description provided for @ratingDeleted.
  ///
  /// In en, this message translates to:
  /// **'Rating deleted successfully'**
  String get ratingDeleted;

  /// No description provided for @ratingDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete rating'**
  String get ratingDeleteFailed;

  /// No description provided for @reviewUpdated.
  ///
  /// In en, this message translates to:
  /// **'Review Updated'**
  String get reviewUpdated;

  /// No description provided for @locationRequired.
  ///
  /// In en, this message translates to:
  /// **'Location Required'**
  String get locationRequired;

  /// No description provided for @locationRequiredDescription.
  ///
  /// In en, this message translates to:
  /// **'To access subsidy features, please add your location information in your profile first.'**
  String get locationRequiredDescription;

  /// No description provided for @whyLocationNeeded.
  ///
  /// In en, this message translates to:
  /// **'Why is location needed?'**
  String get whyLocationNeeded;

  /// No description provided for @locationReason1.
  ///
  /// In en, this message translates to:
  /// **'Show subsidies available for your area'**
  String get locationReason1;

  /// No description provided for @locationReason2.
  ///
  /// In en, this message translates to:
  /// **'Apply for government subsidy programs'**
  String get locationReason2;

  /// No description provided for @locationReason3.
  ///
  /// In en, this message translates to:
  /// **'Find local facilities near you'**
  String get locationReason3;

  /// No description provided for @addLocation.
  ///
  /// In en, this message translates to:
  /// **'Add Location'**
  String get addLocation;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacy;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get help;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language'**
  String get selectLanguage;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get confirmLogout;

  /// No description provided for @logoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutMessage;

  /// No description provided for @locationNotSet.
  ///
  /// In en, this message translates to:
  /// **'Location not set'**
  String get locationNotSet;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @updateLocation.
  ///
  /// In en, this message translates to:
  /// **'Update Location'**
  String get updateLocation;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get enterFullName;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter name'**
  String get pleaseEnterName;

  /// No description provided for @nameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name is too short'**
  String get nameTooShort;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get enterEmail;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter email'**
  String get pleaseEnterEmail;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enterPhoneNumber;

  /// No description provided for @pleaseEnterPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter phone number'**
  String get pleaseEnterPhone;

  /// No description provided for @updateProfile.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get updateProfile;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @profileUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get profileUpdateFailed;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @enterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter current password'**
  String get enterCurrentPassword;

  /// No description provided for @pleaseEnterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter current password'**
  String get pleaseEnterCurrentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get enterNewPassword;

  /// No description provided for @pleaseEnterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter new password'**
  String get pleaseEnterNewPassword;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @enterConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get enterConfirmPassword;

  /// No description provided for @pleaseConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm password'**
  String get pleaseConfirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePassword;

  /// No description provided for @passwordUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get passwordUpdatedSuccessfully;

  /// No description provided for @passwordUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update password'**
  String get passwordUpdateFailed;

  /// No description provided for @selectProvince.
  ///
  /// In en, this message translates to:
  /// **'Select Province'**
  String get selectProvince;

  /// No description provided for @selectDistrict.
  ///
  /// In en, this message translates to:
  /// **'Select District'**
  String get selectDistrict;

  /// No description provided for @selectMunicipality.
  ///
  /// In en, this message translates to:
  /// **'Select Municipality'**
  String get selectMunicipality;

  /// No description provided for @selectWard.
  ///
  /// In en, this message translates to:
  /// **'Select Ward'**
  String get selectWard;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @enterAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter address'**
  String get enterAddress;

  /// No description provided for @pleaseEnterAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter address'**
  String get pleaseEnterAddress;

  /// No description provided for @pleaseSelectAllLocationFields.
  ///
  /// In en, this message translates to:
  /// **'Please select all location fields'**
  String get pleaseSelectAllLocationFields;

  /// No description provided for @locationUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Location updated successfully'**
  String get locationUpdatedSuccessfully;

  /// No description provided for @locationUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update location'**
  String get locationUpdateFailed;

  /// No description provided for @accountInformation.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInformation;

  /// No description provided for @updateYourPersonalInformation.
  ///
  /// In en, this message translates to:
  /// **'Update your personal information'**
  String get updateYourPersonalInformation;

  /// No description provided for @updateYourAddress.
  ///
  /// In en, this message translates to:
  /// **'Update your address'**
  String get updateYourAddress;

  /// No description provided for @updateYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Update your password'**
  String get updateYourPassword;

  /// No description provided for @myRequests.
  ///
  /// In en, this message translates to:
  /// **'My Requests'**
  String get myRequests;

  /// No description provided for @requestDetails.
  ///
  /// In en, this message translates to:
  /// **'Request Details'**
  String get requestDetails;

  /// No description provided for @noRequests.
  ///
  /// In en, this message translates to:
  /// **'No Requests Yet'**
  String get noRequests;

  /// No description provided for @noRequestsDescription.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t submitted any subsidy requests'**
  String get noRequestsDescription;

  /// No description provided for @enterTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter subsidy title'**
  String get enterTitle;

  /// No description provided for @pleaseEnterTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter complaint title'**
  String get pleaseEnterTitle;

  /// No description provided for @targetCrop.
  ///
  /// In en, this message translates to:
  /// **'Target Crop/Sector'**
  String get targetCrop;

  /// No description provided for @enterTargetCrop.
  ///
  /// In en, this message translates to:
  /// **'e.g., Rice, Wheat'**
  String get enterTargetCrop;

  /// No description provided for @pleaseEnterDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter description'**
  String get pleaseEnterDescription;

  /// No description provided for @justification.
  ///
  /// In en, this message translates to:
  /// **'Justification'**
  String get justification;

  /// No description provided for @justificationHint.
  ///
  /// In en, this message translates to:
  /// **'Explain why you need this subsidy'**
  String get justificationHint;

  /// No description provided for @pleaseEnterJustification.
  ///
  /// In en, this message translates to:
  /// **'Please explain your need'**
  String get pleaseEnterJustification;

  /// No description provided for @requestTo.
  ///
  /// In en, this message translates to:
  /// **'Request To'**
  String get requestTo;

  /// No description provided for @requestInfo.
  ///
  /// In en, this message translates to:
  /// **'Your request will be reviewed by government officials'**
  String get requestInfo;

  /// No description provided for @pleaseSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Please select all required fields'**
  String get pleaseSelectAll;

  /// No description provided for @requestFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit request'**
  String get requestFailed;

  /// No description provided for @converted.
  ///
  /// In en, this message translates to:
  /// **'Converted'**
  String get converted;

  /// No description provided for @rejectionReason.
  ///
  /// In en, this message translates to:
  /// **'Rejection Reason'**
  String get rejectionReason;

  /// No description provided for @yesCancel.
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get yesCancel;

  /// No description provided for @confirmCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel Request'**
  String get confirmCancel;

  /// No description provided for @cancelRequestMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this request?'**
  String get cancelRequestMessage;

  /// No description provided for @requestCancelled.
  ///
  /// In en, this message translates to:
  /// **'Request cancelled successfully'**
  String get requestCancelled;

  /// No description provided for @cannotCancel.
  ///
  /// In en, this message translates to:
  /// **'Cannot cancel request'**
  String get cannotCancel;

  /// No description provided for @noRequestSelected.
  ///
  /// In en, this message translates to:
  /// **'No request selected'**
  String get noRequestSelected;

  /// No description provided for @requestInformation.
  ///
  /// In en, this message translates to:
  /// **'Request Information'**
  String get requestInformation;

  /// No description provided for @requestId.
  ///
  /// In en, this message translates to:
  /// **'Request ID'**
  String get requestId;

  /// No description provided for @requestedTo.
  ///
  /// In en, this message translates to:
  /// **'Requested To'**
  String get requestedTo;

  /// No description provided for @submittedOn.
  ///
  /// In en, this message translates to:
  /// **'Submitted On'**
  String get submittedOn;

  /// No description provided for @reviewedOn.
  ///
  /// In en, this message translates to:
  /// **'Reviewed On'**
  String get reviewedOn;

  /// No description provided for @subsidyId.
  ///
  /// In en, this message translates to:
  /// **'Subsidy ID'**
  String get subsidyId;

  /// No description provided for @adminNotes.
  ///
  /// In en, this message translates to:
  /// **'Admin Notes'**
  String get adminNotes;

  /// No description provided for @cancelRequest.
  ///
  /// In en, this message translates to:
  /// **'Cancel Request'**
  String get cancelRequest;

  /// No description provided for @cancelRequestConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this request? This action cannot be undone.'**
  String get cancelRequestConfirm;

  /// No description provided for @requestConverted.
  ///
  /// In en, this message translates to:
  /// **'Request Converted!'**
  String get requestConverted;

  /// No description provided for @convertedToSubsidy.
  ///
  /// In en, this message translates to:
  /// **'Your request has been converted to'**
  String get convertedToSubsidy;

  /// No description provided for @viewSubsidy.
  ///
  /// In en, this message translates to:
  /// **'View Subsidy'**
  String get viewSubsidy;

  /// No description provided for @requestSubsidyHint.
  ///
  /// In en, this message translates to:
  /// **'Request a subsidy from government'**
  String get requestSubsidyHint;

  /// No description provided for @fileComplaint.
  ///
  /// In en, this message translates to:
  /// **'File a Complaint'**
  String get fileComplaint;

  /// No description provided for @myComplaints.
  ///
  /// In en, this message translates to:
  /// **'My Complaints'**
  String get myComplaints;

  /// No description provided for @complaintDetails.
  ///
  /// In en, this message translates to:
  /// **'Complaint Details'**
  String get complaintDetails;

  /// No description provided for @reportYourIssue.
  ///
  /// In en, this message translates to:
  /// **'Report Your Issue'**
  String get reportYourIssue;

  /// No description provided for @weAreHereToHelp.
  ///
  /// In en, this message translates to:
  /// **'We\'re here to help resolve your concerns'**
  String get weAreHereToHelp;

  /// No description provided for @reportIssues.
  ///
  /// In en, this message translates to:
  /// **'Report Issues'**
  String get reportIssues;

  /// No description provided for @fileComplaints.
  ///
  /// In en, this message translates to:
  /// **'File Complaints'**
  String get fileComplaints;

  /// No description provided for @reportProblemsToGovernment.
  ///
  /// In en, this message translates to:
  /// **'Report your problems to government'**
  String get reportProblemsToGovernment;

  /// No description provided for @complaintCategory.
  ///
  /// In en, this message translates to:
  /// **'Complaint Category'**
  String get complaintCategory;

  /// No description provided for @priorityLevel.
  ///
  /// In en, this message translates to:
  /// **'Priority Level'**
  String get priorityLevel;

  /// No description provided for @complaintTitle.
  ///
  /// In en, this message translates to:
  /// **'Complaint Title'**
  String get complaintTitle;

  /// No description provided for @detailedDescription.
  ///
  /// In en, this message translates to:
  /// **'Detailed Description'**
  String get detailedDescription;

  /// No description provided for @specificLocation.
  ///
  /// In en, this message translates to:
  /// **'Specific Location'**
  String get specificLocation;

  /// No description provided for @submitTo.
  ///
  /// In en, this message translates to:
  /// **'Submit To'**
  String get submitTo;

  /// No description provided for @locationDetailsOptional.
  ///
  /// In en, this message translates to:
  /// **'Location Details (Optional)'**
  String get locationDetailsOptional;

  /// No description provided for @locationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Near school, Main road, etc.'**
  String get locationHint;

  /// No description provided for @enterComplaintTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter a brief title for your complaint'**
  String get enterComplaintTitle;

  /// No description provided for @describeComplaint.
  ///
  /// In en, this message translates to:
  /// **'Describe your complaint in detail...'**
  String get describeComplaint;

  /// No description provided for @pleaseProvideDescription.
  ///
  /// In en, this message translates to:
  /// **'Please provide complaint description'**
  String get pleaseProvideDescription;

  /// No description provided for @descriptionMinLength.
  ///
  /// In en, this message translates to:
  /// **'Description must be at least 20 characters'**
  String get descriptionMinLength;

  /// No description provided for @pleaseSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select a complaint category'**
  String get pleaseSelectCategory;

  /// No description provided for @pleaseSelectPriority.
  ///
  /// In en, this message translates to:
  /// **'Please select priority level'**
  String get pleaseSelectPriority;

  /// No description provided for @pleaseSelectLevel.
  ///
  /// In en, this message translates to:
  /// **'Please select government level'**
  String get pleaseSelectLevel;

  /// No description provided for @cropDisease.
  ///
  /// In en, this message translates to:
  /// **'Crop Disease'**
  String get cropDisease;

  /// No description provided for @pestInfestation.
  ///
  /// In en, this message translates to:
  /// **'Pest Infestation'**
  String get pestInfestation;

  /// No description provided for @irrigationIssue.
  ///
  /// In en, this message translates to:
  /// **'Irrigation'**
  String get irrigationIssue;

  /// No description provided for @roadInfrastructure.
  ///
  /// In en, this message translates to:
  /// **'Road'**
  String get roadInfrastructure;

  /// No description provided for @fertilizerQuality.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer'**
  String get fertilizerQuality;

  /// No description provided for @seedQuality.
  ///
  /// In en, this message translates to:
  /// **'Seeds'**
  String get seedQuality;

  /// No description provided for @equipmentIssue.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get equipmentIssue;

  /// No description provided for @waterSupply.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get waterSupply;

  /// No description provided for @marketAccess.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get marketAccess;

  /// No description provided for @extensionService.
  ///
  /// In en, this message translates to:
  /// **'Extension'**
  String get extensionService;

  /// No description provided for @subsidyRelated.
  ///
  /// In en, this message translates to:
  /// **'Subsidy'**
  String get subsidyRelated;

  /// No description provided for @electricity.
  ///
  /// In en, this message translates to:
  /// **'Electricity'**
  String get electricity;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @urgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get urgent;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @centralLevel.
  ///
  /// In en, this message translates to:
  /// **'Central Level'**
  String get centralLevel;

  /// No description provided for @acknowledged.
  ///
  /// In en, this message translates to:
  /// **'Acknowledged'**
  String get acknowledged;

  /// No description provided for @underInvestigation.
  ///
  /// In en, this message translates to:
  /// **'Under Investigation'**
  String get underInvestigation;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @forwarded.
  ///
  /// In en, this message translates to:
  /// **'Forwarded'**
  String get forwarded;

  /// No description provided for @resolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get resolved;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @submitComplaint.
  ///
  /// In en, this message translates to:
  /// **'Submit Complaint'**
  String get submitComplaint;

  /// No description provided for @newComplaint.
  ///
  /// In en, this message translates to:
  /// **'New Complaint'**
  String get newComplaint;

  /// No description provided for @cancelComplaint.
  ///
  /// In en, this message translates to:
  /// **'Cancel Complaint'**
  String get cancelComplaint;

  /// No description provided for @complaintSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Complaint submitted successfully!'**
  String get complaintSubmitted;

  /// No description provided for @complaintCancelled.
  ///
  /// In en, this message translates to:
  /// **'Complaint cancelled successfully'**
  String get complaintCancelled;

  /// No description provided for @failedToSubmit.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit complaint. Please try again.'**
  String get failedToSubmit;

  /// No description provided for @failedToCancel.
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel complaint'**
  String get failedToCancel;

  /// No description provided for @noComplaintsFound.
  ///
  /// In en, this message translates to:
  /// **'No complaints found'**
  String get noComplaintsFound;

  /// No description provided for @fileComplaintToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'File a complaint to get started'**
  String get fileComplaintToGetStarted;

  /// No description provided for @confirmCancelComplaint.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this complaint? This action cannot be undone.'**
  String get confirmCancelComplaint;

  /// No description provided for @noKeepIt.
  ///
  /// In en, this message translates to:
  /// **'No, Keep It'**
  String get noKeepIt;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @assignedTo.
  ///
  /// In en, this message translates to:
  /// **'Assigned To'**
  String get assignedTo;

  /// No description provided for @resolution.
  ///
  /// In en, this message translates to:
  /// **'Resolution'**
  String get resolution;

  /// No description provided for @resolvedOn.
  ///
  /// In en, this message translates to:
  /// **'Resolved on'**
  String get resolvedOn;

  /// No description provided for @coordinates.
  ///
  /// In en, this message translates to:
  /// **'Coordinates'**
  String get coordinates;

  /// No description provided for @latitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitude;

  /// No description provided for @longitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get longitude;

  /// No description provided for @enterLatitude.
  ///
  /// In en, this message translates to:
  /// **'Enter latitude'**
  String get enterLatitude;

  /// No description provided for @enterLongitude.
  ///
  /// In en, this message translates to:
  /// **'Enter longitude'**
  String get enterLongitude;

  /// No description provided for @getMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Get My Location'**
  String get getMyLocation;

  /// No description provided for @locationFetched.
  ///
  /// In en, this message translates to:
  /// **'Location fetched successfully'**
  String get locationFetched;

  /// No description provided for @failedToGetLocation.
  ///
  /// In en, this message translates to:
  /// **'Failed to get location'**
  String get failedToGetLocation;

  /// No description provided for @attachment.
  ///
  /// In en, this message translates to:
  /// **'Attachment'**
  String get attachment;

  /// No description provided for @attachmentDescription.
  ///
  /// In en, this message translates to:
  /// **'Attach a file (PDF, JPG, PNG - Max 5MB)'**
  String get attachmentDescription;

  /// No description provided for @chooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose File'**
  String get chooseFile;

  /// No description provided for @fileAttached.
  ///
  /// In en, this message translates to:
  /// **'File attached successfully'**
  String get fileAttached;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @attachmentPreview.
  ///
  /// In en, this message translates to:
  /// **'Attachment Preview'**
  String get attachmentPreview;

  /// No description provided for @attachmentsCount.
  ///
  /// In en, this message translates to:
  /// **'Attachments ({count})'**
  String attachmentsCount(int count);

  /// No description provided for @commentsCount.
  ///
  /// In en, this message translates to:
  /// **'Comments ({count})'**
  String commentsCount(int count);

  /// No description provided for @addComment.
  ///
  /// In en, this message translates to:
  /// **'Add a comment...'**
  String get addComment;

  /// No description provided for @pleaseEnterComment.
  ///
  /// In en, this message translates to:
  /// **'Please enter a comment'**
  String get pleaseEnterComment;

  /// No description provided for @commentMinLength.
  ///
  /// In en, this message translates to:
  /// **'Comment must be at least 3 characters'**
  String get commentMinLength;

  /// No description provided for @commentAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Comment added successfully'**
  String get commentAddedSuccessfully;

  /// No description provided for @failedToAddComment.
  ///
  /// In en, this message translates to:
  /// **'Failed to add comment'**
  String get failedToAddComment;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ne'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ne':
      return AppLocalizationsNe();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
