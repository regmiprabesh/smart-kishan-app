// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Nepali (`ne`).
class AppLocalizationsNe extends AppLocalizations {
  AppLocalizationsNe([String locale = 'ne']) : super(locale);

  @override
  String get appTitle => 'Smart Kishan';

  @override
  String get language => 'भाषा';

  @override
  String get selectLanguageMsg => 'कृपया आफुलाई उप्युक्त हुने भाषा छान्नुहोस !';

  @override
  String get welcomeBack => 'स्वागत छ!';

  @override
  String get loginMsg => 'जारी राख्न कृपया साइन इन गर्नुहोस्';

  @override
  String get phoneNumber => 'फोन नम्बर';

  @override
  String get inputPhone => 'आफ्नो फोन नम्बर प्रविष्ट गर्नुहोस्';

  @override
  String get inputPhoneMsg => 'कृपया आफ्नो फोन नम्बर प्रविष्ट गर्नुहोस्';

  @override
  String get enterValidPhone => 'कृपया आफ्नो सही फोन नम्बर प्रविष्ट गर्नुहोस्!';

  @override
  String get password => 'पासवर्ड';

  @override
  String get inputPassword => 'आफ्नो पासवर्ड प्रविष्ट गर्नुहोस्';

  @override
  String get inputPasswordMsg => 'कृपया आफ्नो पासवर्ड प्रविष्ट गर्नुहोस्';

  @override
  String get login => 'लगइन गर्नुहोस्';

  @override
  String get noAccount => 'खाता छैन';

  @override
  String get registerNow => 'नयाँ खाता खोल्नुहोस्';

  @override
  String get or => 'अथवा';

  @override
  String get navigateForgotPwdMsgBefore => 'आफ्नो ';

  @override
  String get navigateForgotPwdMsgAfter => 'पासवर्ड बिर्सनुभयो';

  @override
  String get nextPage => 'अर्को पृष्ठ';

  @override
  String get story1Title => 'अब कृषि अझ सजिलो';

  @override
  String get story2Title => 'विभिन्न खेतबारी व्यवस्थित गर्नुहोस्';

  @override
  String get story3Title => 'फार्म स्टक कुशलतापूर्वक व्यवस्थित गर्नुहोस्';

  @override
  String get story4Title => 'छिटो सम्झनका लागि नोटहरू';

  @override
  String get story1Desc =>
      'तपाईंको कृषि व्यवस्थापनलाई सजिलो बनाउनको लागि डिजाइन गरिएको टूलहरूको प्रयोग गरेर सजिलै सफल हुनुहोस्।';

  @override
  String get story2Desc =>
      'विभिन्न फर्मल्यान्डहरूका डेटा ट्र्याक गर्नुहोस् र हरेक प्लटको लागि अनुकूलित गर्नुहोस्।';

  @override
  String get story3Desc =>
      'सबै फार्म सामग्री र स्टक स्तरहरूको स्पष्ट रेकर्ड राख्नुहोस्।';

  @override
  String get story4Desc =>
      'महत्वपूर्ण कार्यहरू वा विचारहरू तुरुन्त नोट गर्नुहोस् र तपाईंको फार्मको आवश्यकताहरूलाई व्यवस्थित राख्नुहोस्।';

  @override
  String get getStarted => 'सुरु गर्नुहोस्';

  @override
  String get createAccountTitle => 'नयाँ खाता सिर्जना';

  @override
  String get createAccountDesc =>
      'कृपया  जारी राख्न आफ्नो फोन नम्बर प्रविष्ट गर्नुहोस्, हामी तपाइँको पासवर्ड रिसेट गर्न प्रमाणिकरण कोड पठाउनेछौं।';

  @override
  String get requestOTP => 'OTP अनुरोध गर्नुहोस्';

  @override
  String get wrongPhonePassword => 'गलत फोन / पासवर्ड';

  @override
  String get accountCreated => 'तपाईंको खाता सफलतापूर्वक सिर्जना गरिएको छ!';

  @override
  String get passwordResetSuccess =>
      'पासवर्ड सफलतापूर्वक परिवर्तन भयो । कृपया लगइन गर्नुहोस् ।';

  @override
  String get passwordResetFailed => 'पासवर्ड परिवर्तन गर्न सकिएन ।';

  @override
  String get logoutFailed => 'केहि गलत भयो ! फेरि प्रयास गर्नुहोस';

  @override
  String get otpSent => 'OTP कोड तपाईंको फोन नम्बरमा पठाइएको छ।';

  @override
  String get otpResent => 'OTP कोड पुन: तपाईंको फोन नम्बरमा पठाइएको छ।';

  @override
  String get phoneAlreadyRegistered => 'यो फोन नम्बर पहिलेनै दर्ता भएको छ।';

  @override
  String get phoneNotRegistered => 'यो फोन नम्बर दर्ता भएको छैन।';

  @override
  String otpThrottled(String seconds) {
    return 'पुन: कोड पठाउनु अघि कृपया $seconds सेकेन्ड पर्खनुहोस्।';
  }

  @override
  String get otpSendFailed => 'OTP पठाउन सकिएन।';

  @override
  String get otpInvalid => 'प्रमाणीकरण कोड गलत भएको छ।';

  @override
  String get genericError => 'केही समस्या भयो। कृपया फेरि प्रयास गर्नुहोस्।';

  @override
  String loginThrottled(String seconds) {
    return 'धेरै पटक प्रयास गरियो। कृपया $seconds सेकेन्ड पर्खेर पुन: प्रयास गर्नुहोस्।';
  }

  @override
  String get sessionExpired =>
      'तपाईंको सत्र समाप्त भयो। कृपया पुन: लगइन गर्नुहोस्।';

  @override
  String get noInternet =>
      'जडान गर्न सकिएन। कृपया आफ्नो इन्टरनेट जाँच गरी पुन: प्रयास गर्नुहोस्।';

  @override
  String get alreadyAccount => 'पहिले नै एउटा खाता छ ? ';

  @override
  String get signInNav => 'लगइन गर्नुहोस्';

  @override
  String get forgotPwdTitle => 'आफ्नो पासवर्ड बिर्सनुभयो ?';

  @override
  String get forgotPwdDesc =>
      'जारी राख्न आफ्नो फोन नम्बर प्रविष्ट गर्नुहोस्, हामी तपाइँको पासवर्ड रिसेट गर्न प्रमाणिकरण कोड पठाउनेछौं।';

  @override
  String get noForget => 'बिर्सिनुभएको छैन ? ';

  @override
  String get knowAboutCrops => 'विभिन्न बाली बारे जान्न चाहनुहुन्छ ?';

  @override
  String get crops => 'बालीहरू';

  @override
  String get clickHere => 'यहाँ क्लिक गर्नुहोस्';

  @override
  String get logout => 'लग आउट';

  @override
  String get home => 'गृह पृष्ठ';

  @override
  String get chart => 'लेखा चित्र';

  @override
  String get incomeAnalysis => 'आम्दानी विश्लेषण';

  @override
  String get incomeChartDaily => 'दैनिक आमदानी चार्ट';

  @override
  String get incomeChartMonthly => 'मासिक आमदानी चार्ट';

  @override
  String get incomeChartYearly => 'वार्षिक आमदानी चार्ट';

  @override
  String get last7Days => 'पछिल्लो ७ दिन';

  @override
  String get last7Months => 'पछिल्लो ७ महिना';

  @override
  String get last5Years => 'पछिल्लो ५ वर्ष';

  @override
  String get expenseAnalysis => 'खर्च विश्लेषण';

  @override
  String get expenseChartDaily => 'दैनिक खर्च चार्ट';

  @override
  String get expenseChartMonthly => 'मासिक खर्च चार्ट';

  @override
  String get expenseChartYearly => 'वार्षिक खर्च चार्ट';

  @override
  String get chartScreenTitle => 'लेखा चित्र';

  @override
  String get chartTitleDaily => 'दैनिक आय/व्यय लेखा चित्र';

  @override
  String get chartTitleMonthly => 'मासिक आय/व्यय लेखा चित्र';

  @override
  String get chartTitleYearly => 'वार्षिक आय/व्यय लेखा चित्र';

  @override
  String get currencySymbol => 'रू.';

  @override
  String get filterDaily => 'दैनिक';

  @override
  String get filterMonthly => 'मासिक';

  @override
  String get filterYearly => 'वार्षिक';

  @override
  String get productListTitle => 'जिन्सी समान';

  @override
  String get stockLabel => 'स्टक';

  @override
  String get noProductsFound => 'तपाईंसँग हाल कुनै उत्पादन छैन !';

  @override
  String get noDateFound => 'मिति फेला परेन';

  @override
  String get loadingCity => 'सहर लोड हुँदैछ...';

  @override
  String get goodDayForPesticide => 'कीटनाशक प्रयोग गर्न आजको दिन राम्रो छ।';

  @override
  String get badDayForPesticide => 'कीटनाशक प्रयोग गर्न आजको दिन राम्रो छैन।';

  @override
  String get weatherThunderstorm => 'चट्याङसहितको वर्षा';

  @override
  String get weatherDrizzle => 'सिमसिम पानी';

  @override
  String get weatherRain => 'वर्षा';

  @override
  String get weatherSnow => 'हिमपात';

  @override
  String get weatherClear => 'सफा आकाश';

  @override
  String get weatherClouds => 'बदली';

  @override
  String get weatherMist => 'तुवाँलो';

  @override
  String get weatherHaze => 'धुम्म';

  @override
  String get weatherFog => 'कुहिरो';

  @override
  String get newNote => 'नयाँ नोट';

  @override
  String get addNote => 'नोट थप्नुहोस्';

  @override
  String get updateNote => 'नोट अपडेट गर्नुहोस्';

  @override
  String get add => 'थप्नुहोस्';

  @override
  String get update => 'अपडेट गर्नुहोस्';

  @override
  String get edit => 'सम्पादन गर्नुहोस्';

  @override
  String get notesEmptyDescription =>
      'आफ्ना महत्त्वपूर्ण विचार र जानकारी सुरक्षित राख्न नोट थप्नुहोस्';

  @override
  String get deleteNoteConfirm =>
      'तपाईं यो नोट मेटाउन निश्चित हुनुहुन्छ? यो कार्य पूर्ववत गर्न सकिँदैन।';

  @override
  String get today => 'आज';

  @override
  String get yesterday => 'हिजो';

  @override
  String daysAgo(String count) {
    return '$count दिन अघि';
  }

  @override
  String get noteTitle => 'नोटको शीर्षक';

  @override
  String get enterNoteTitle => 'नोटको शीर्षक प्रविष्ट गर्नुहोस्';

  @override
  String get pleaseEnterNoteTitle =>
      'कृपया आफ्नो नोटको शीर्षक प्रविष्ट गर्नुहोस्';

  @override
  String get noteTitleMinLength => 'नोटको शीर्षक कम्तिमा ३ अक्षरको हुनुपर्छ';

  @override
  String get noteDescription => 'नोटको विवरण';

  @override
  String get enterNoteDescription => 'नोटको विवरण प्रविष्ट गर्नुहोस्';

  @override
  String get notePriority => 'नोटको प्राथमिकता';

  @override
  String get enterNotePriority => 'नोटको प्राथमिकता प्रविष्ट गर्नुहोस्';

  @override
  String get governmentServices => 'सरकारी सेवाहरू';

  @override
  String get quickActions => 'द्रुत कार्यहरू';

  @override
  String get homeGovOfficesTitle => 'सरकारी कार्यालयहरू';

  @override
  String get homeGovOfficesSubtitle =>
      'नजिकका कृषि कार्यालय र प्रयोगशाला खोज्नुहोस्';

  @override
  String get homeGovOfficesBadge => 'स्थानहरू';

  @override
  String get homeSubsidiesTitle => 'अनुदान तथा\nसुविधाहरू';

  @override
  String get homeSubsidiesSubtitle => 'सरकारी अनुदानहरू अन्वेषण गर्नुहोस्';

  @override
  String get homeSubsidiesBadge => 'सरकारी सहयोग';

  @override
  String get homeComplaintsTitle => 'गुनासो\nदर्ता गर्नुहोस्';

  @override
  String get homeComplaintsSubtitle => 'आफ्ना समस्याहरू रिपोर्ट गर्नुहोस्';

  @override
  String get homeComplaintsBadge => 'समस्या रिपोर्ट';

  @override
  String get homeSurveysTitle => 'सर्वेक्षणहरू';

  @override
  String get homeSurveysSubtitle => 'आफ्नो प्रतिक्रिया साझा गर्नुहोस्';

  @override
  String get homeSurveysBadge => 'प्रतिक्रिया';

  @override
  String get serviceCenters => 'सेवा केन्द्रहरू';

  @override
  String get listView => 'सूची दृश्य';

  @override
  String get mapView => 'नक्सा दृश्य';

  @override
  String get filters => 'फिल्टरहरू';

  @override
  String get currentLocationNotAvailable => 'हालको स्थान उपलब्ध छैन';

  @override
  String get searchServiceCentersHint => 'सेवा केन्द्र खोज्नुहोस्...';

  @override
  String get loadingRoute => 'मार्ग लोड हुँदैछ...';

  @override
  String get nearestServiceCenters => 'नजिकका सेवा केन्द्रहरू';

  @override
  String get noServiceCentersFound => 'कुनै सेवा केन्द्र भेटिएन';

  @override
  String get tryAdjustingFilters => 'आफ्ना फिल्टर वा खोजी समायोजन गर्नुहोस्';

  @override
  String get km => 'कि.मि.';

  @override
  String get away => 'टाढा';

  @override
  String get routeLoaded => 'मार्ग लोड भयो';

  @override
  String get notApplicable => 'उपलब्ध छैन';

  @override
  String get featured => 'विशेष';

  @override
  String get viewOnMap => 'नक्सामा हेर्नुहोस्';

  @override
  String get details => 'विवरण';

  @override
  String get filtersAndSort => 'फिल्टर र क्रमबद्धता';

  @override
  String get clearAll => 'सबै हटाउनुहोस्';

  @override
  String get distance => 'दूरी';

  @override
  String get name => 'नाम';

  @override
  String get rating => 'रेटिङ';

  @override
  String get newest => 'नवीनतम';

  @override
  String get searchRadius => 'खोज दायरा';

  @override
  String get showFeaturedOnly => 'केवल विशेष देखाउनुहोस्';

  @override
  String get applyFilters => 'फिल्टर लागू गर्नुहोस्';

  @override
  String get serviceCenterNotFound => 'सेवा केन्द्र भेटिएन';

  @override
  String get basedOnUserReviews => 'प्रयोगकर्ताका समीक्षामा आधारित';

  @override
  String get ratingSingular => 'रेटिङ';

  @override
  String get ratingPlural => 'रेटिङहरू';

  @override
  String get reviewSingular => 'समीक्षा';

  @override
  String get reviewPlural => 'समीक्षाहरू';

  @override
  String get contactInformation => 'सम्पर्क जानकारी';

  @override
  String get phone => 'फोन';

  @override
  String get website => 'वेबसाइट';

  @override
  String get contactPerson => 'सम्पर्क व्यक्ति';

  @override
  String get directions => 'दिशा';

  @override
  String wardNo(String no) {
    return 'वडा नं: $no';
  }

  @override
  String get operatingHours => 'कार्य समय';

  @override
  String get servicesOffered => 'प्रदान गरिएका सेवाहरू';

  @override
  String get yourRating => 'तपाईंको रेटिङ';

  @override
  String get editRating => 'रेटिङ सम्पादन गर्नुहोस्';

  @override
  String get helpOthersRate =>
      'यो सेवा केन्द्रलाई रेटिङ दिएर अरूलाई मद्दत गर्नुहोस्';

  @override
  String get addYourRating => 'आफ्नो रेटिङ थप्नुहोस्';

  @override
  String get rateServiceCenter => 'सेवा केन्द्रलाई रेटिङ दिनुहोस्';

  @override
  String get writeReviewOptional => 'समीक्षा लेख्नुहोस् (वैकल्पिक)';

  @override
  String get shareYourExperienceHint => 'आफ्नो अनुभव साझा गर्नुहोस्...';

  @override
  String get submit => 'पेश गर्नुहोस्';

  @override
  String get editYourRating => 'आफ्नो रेटिङ सम्पादन गर्नुहोस्';

  @override
  String get deleteRatingQuestion => 'रेटिङ मेटाउने?';

  @override
  String get deleteRatingReviewConfirm =>
      'के तपाईं आफ्नो रेटिङ र समीक्षा मेटाउन निश्चित हुनुहुन्छ? यो कार्य पूर्ववत गर्न सकिँदैन।';

  @override
  String get ratingSubmittedSuccess => 'रेटिङ सफलतापूर्वक पेश गरियो!';

  @override
  String get ratingUpdatedSuccess => 'रेटिङ सफलतापूर्वक अपडेट गरियो!';

  @override
  String get youRatedThisCenter => 'तपाईंले यो सेवा केन्द्रलाई रेटिङ दिनुभयो';

  @override
  String get recentReviews => 'हालका समीक्षाहरू';

  @override
  String viewAllReviews(String count) {
    return 'सबै $count समीक्षाहरू हेर्नुहोस्';
  }

  @override
  String get anonymous => 'अज्ञात';

  @override
  String get ago => 'अघि';

  @override
  String get minUnit => 'मिनेट';

  @override
  String get hrUnit => 'घण्टा';

  @override
  String get dayUnit => 'दिन';

  @override
  String get daysUnit => 'दिन';

  @override
  String get weekUnit => 'हप्ता';

  @override
  String get weeksUnit => 'हप्ता';

  @override
  String get topRatedServiceCenters =>
      'उच्च मूल्याङ्कन प्राप्त सेवा केन्द्रहरू';

  @override
  String get basicInformation => 'आधारभूत जानकारी';

  @override
  String get requestDetails => 'अनुरोध विवरण';

  @override
  String get requestTarget => 'अनुरोधको लक्ष्य';

  @override
  String get actionCannotBeUndone => 'यो कार्य पूर्ववत् गर्न सकिँदैन।';

  @override
  String get kalimatiPriceList => 'कालिमाटी मूल्य सूची';

  @override
  String get commodity => 'वस्तु';

  @override
  String get unit => 'एकाइ';

  @override
  String get minPrice => 'न्यूनतम मूल्य';

  @override
  String get maxPrice => 'अधिकतम मूल्य';

  @override
  String get avgPrice => 'औसत मूल्य';

  @override
  String get tapAnyFileToViewOrDownload =>
      'हेर्न वा डाउनलोड गर्न कुनै पनि फाइलमा ट्याप गर्नुहोस्।';

  @override
  String get addUser => 'प्रयोगकर्ता थप गर्नुहोस्';

  @override
  String get noUsersYet =>
      'तपाईंले अहिलेसम्म कुनै पनि प्रयोगकर्ता थप्नुभएको छैन !';

  @override
  String get deleteUserConfirm =>
      'तपाईं यो प्रयोगकर्ता मेटाउन निश्चित हुनुहुन्छ?';

  @override
  String get addUserTitle => 'प्रयोगकर्ता थप्नुहोस्';

  @override
  String get updateUserTitle => 'प्रयोगकर्ता अपडेट गर्नुहोस्';

  @override
  String get userFullName => 'प्रयोगकर्ताको पूरा नाम';

  @override
  String get enterUserFullName => 'प्रयोगकर्ताको पूरा नाम प्रविष्टि गर्नुहोस्';

  @override
  String get pleaseEnterUserFullName =>
      'कृपया प्रयोगकर्ताको पूरा नाम प्रविष्टि गर्नुहोस्';

  @override
  String get pleaseEnterValidUserName =>
      'कृपया प्रयोगकर्ताको मान्य नाम प्रविष्ट गर्नुहोस्';

  @override
  String get userPhoneNumber => 'प्रयोगकर्ताको फोन नम्बर';

  @override
  String get enterUserPhoneNumber =>
      'प्रयोगकर्ताको फोन नम्बर प्रविष्टि गर्नुहोस्';

  @override
  String get pleaseEnterUserPhone =>
      'कृपया प्रयोगकर्ताको फोन नम्बर प्रविष्टि गर्नुहोस्';

  @override
  String get pleaseEnterValidUserPhone =>
      'कृपया प्रयोगकर्ताको मान्य फोन नम्बर प्रविष्टि गर्नुहोस्';

  @override
  String get userEmail => 'प्रयोगकर्ताको ई - मेल ठेगाना';

  @override
  String get enterUserEmail =>
      'प्रयोगकर्ताको ई - मेल ठेगाना प्रविष्टि गर्नुहोस्';

  @override
  String get userPassword => 'प्रयोगकर्ताको पासवर्ड';

  @override
  String get enterUserPassword => 'प्रयोगकर्ताको पासवर्ड प्रविष्टि गर्नुहोस्';

  @override
  String get pleaseEnterUserPassword =>
      'कृपया प्रयोगकर्ताको पासवर्ड प्रविष्ट गर्नुहोस्';

  @override
  String get passwordMinLength => 'पासवर्ड कम्तिमा ८ वर्ण लामो हुनुपर्छ';

  @override
  String get userConfirmPassword => 'प्रयोगकर्ताको पुन पासवर्ड';

  @override
  String get confirmUserPassword => 'प्रयोगकर्ताको पासवर्ड सुनिश्चित गर्नुहोस';

  @override
  String get confirmPasswordEmpty => 'पुन पासवर्ड फिल्ड खाली हुन सक्दैन';

  @override
  String get users => 'प्रयोगकर्ताहरू';

  @override
  String get profile => 'प्रोफाइल';

  @override
  String get dailyActivities => 'दैनिक \n गतिविधि';

  @override
  String get dailyActivity => 'दैनिक गतिविधि';

  @override
  String get products => 'उत्पादन';

  @override
  String get expenses => 'खर्च';

  @override
  String get sales => 'बिक्री';

  @override
  String get farmlands => 'खेतबारी';

  @override
  String get notes => 'नोटहरू';

  @override
  String get noNotesMsg => 'तपाईंसँग हाल कुनै नोट छैन !';

  @override
  String get c => 'से';

  @override
  String get humidity => 'आर्द्रता';

  @override
  String get search => 'खोजी गर्नुहोस';

  @override
  String get searchHint => 'खोजी गर्नुहोस...';

  @override
  String get sellerMode => 'विक्रेता मोड';

  @override
  String get buyerMode => 'खरिदकर्ता मोड';

  @override
  String get farmerMode => 'किसान मोड';

  @override
  String get myDeliveryLocations => 'मेरो डेलिभरी स्थानहरू';

  @override
  String get myCart => 'मेरो कार्ट';

  @override
  String get myProductOrders => 'मेरो अर्डरहरू';

  @override
  String get logOut => 'Log Out';

  @override
  String get market => 'बजार';

  @override
  String get noItems => 'कुनै वस्तु छैन';

  @override
  String get yourCart => 'तपाईंको कार्ट';

  @override
  String get buyProducts => 'उत्पादन खरीद गर्नुहोस्';

  @override
  String get yourCartIsEmpty => 'तपाईंको कार्ट खाली छ!';

  @override
  String get cartMessage =>
      'तपाईंले कार्टमा उत्पादन थप्न थालेपछि यहाँ देख्नुहुनेछ!';

  @override
  String get shoppingCart => 'किनमेल कार्ट';

  @override
  String get results => 'परिणामहरू';

  @override
  String get showingDefaultProducts => 'पूर्वनिर्धारित उत्पादनहरू देखाउँदै';

  @override
  String get sortBy => 'क्रमबद्ध गर्नुहोस्';

  @override
  String get defaultResults => 'पूर्वनिर्धारित';

  @override
  String get recentlyAdded => 'भर्खरै थपिएका';

  @override
  String get priceLowToHigh => 'मूल्य: कम देखि उच्च';

  @override
  String get priceHighToLow => 'मूल्य: उच्च देखि कम';

  @override
  String get categories => 'उत्पादनका प्रकार';

  @override
  String get allCategories => 'उत्पादनका प्रकारहरू';

  @override
  String get paymentTypes => 'भुक्तानीका प्रकार';

  @override
  String get whatAreYouLookingFor => 'तपाईं के खोज्दै हुनुहुन्छ ?';

  @override
  String get buyItNow => 'सीधा खरिद';

  @override
  String get addToBag => 'कार्टमा थप्नुहोस्';

  @override
  String get viewAll => 'सबै हेर्नुहोस्';

  @override
  String get featuredProducts => 'विशेष उत्पादनहरू';

  @override
  String get searchProducts => 'उत्पादन खोज्नुहोस्';

  @override
  String get noResultFound => 'कुनै उत्पादन भेटिएन';

  @override
  String get noResultFoundDesc =>
      'कुनै उत्पादन भेटिएन। कृपया पुन: प्रयास गर्नुहोस्।';

  @override
  String get exploreCategories => 'उत्पादनका प्रकार अन्वेषण गर्नुहोस्';

  @override
  String get myDeliveryAddress => 'मेरो डेलिभरी ठेगाना';

  @override
  String get addNewAddress => 'नयाँ ठेगाना थप्नुहोस्';

  @override
  String get deliveryChargesInfo =>
      'डेलिभरी शुल्क किसान र तपाईंको स्थानमा निर्भर हुन सक्छ।';

  @override
  String get noDeliveryAddress =>
      'तपाईंले कुनै डेलिभरी ठेगाना थप्नुभएको छैन। कृपया आफ्नो अर्डर प्रक्रिया जारी राख्न नयाँ ठेगाना थप्नुहोस्।';

  @override
  String get updateAddress => 'अद्यावधिक गर्नुहोस्';

  @override
  String get addressTitle => 'ठेगानाको शीर्षक';

  @override
  String get enterAddressTitle => 'कृपया ठेगानाको शीर्षक प्रविष्ट गर्नुहोस्';

  @override
  String get city => 'सहर';

  @override
  String get enterCityName => 'कृपया आफ्नो सहरको नाम प्रविष्ट गर्नुहोस्';

  @override
  String get addressDescription => 'ठेगानाको विवरण';

  @override
  String get addressDescriptionLandmark => 'ठेगानाको विवरण/ल्यान्डमार्क';

  @override
  String get enterAddressDescription =>
      'कृपया ठेगानाको विवरण प्रविष्ट गर्नुहोस्';

  @override
  String get setAsDefaultAddress => 'पूर्वनिर्धारित ठेगाना सेट गर्नुहोस्';

  @override
  String get saveAddress => 'ठेगाना थप्नुहोस्';

  @override
  String get addNewAddressButton => 'नयाँ ठेगाना थप्नुहोस्';

  @override
  String get showingNewestResults => 'नवीनतम परिणाम देखाउँदै';

  @override
  String searchResultFor(Object name) {
    return '\'$name\' को लागि खोज परिणाम';
  }

  @override
  String get showingLowToHighResults => 'मूल्य: कमबाट उच्च परिणाम देखाउँदै';

  @override
  String get showingHighToLowResults => 'मूल्य: उच्चबाट कम परिणाम देखाउँदै';

  @override
  String get showingDefaultResults => 'डिफल्ट परिणाम देखाउँदै';

  @override
  String productResults(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'हरू',
      one: '',
    );
    return '$count उत्पादन$_temp0 भेटियो';
  }

  @override
  String filterTitle(Object title) {
    return '$titleहरू फिल्टर गर्नुहोस्';
  }

  @override
  String get confirm => 'पुष्टि गर्नुहोस्';

  @override
  String get searchHistory => 'खोजी इतिहास';

  @override
  String get currency => 'रु ';

  @override
  String get minimumOrder => 'न्यूनतम अर्डर';

  @override
  String get acceptedPaymentMethods => 'स्वीकृत भुक्तानी विधिहरू';

  @override
  String get deliveryLocations => 'वितरण स्थानहरू';

  @override
  String get additionalNotes => 'थप नोटहरू';

  @override
  String get total => 'जम्मा रकम';

  @override
  String get checkOut => 'चेकआउट';

  @override
  String cartItems(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'हरू',
      one: '',
    );
    return 'बस्तु$_temp0';
  }

  @override
  String get quantityShort => 'मात्रा: ';

  @override
  String get deleteCartTitle => 'कार्टबाट हटाउनुहोस्';

  @override
  String get deleteCartMessage =>
      'तपाईं यो उत्पादनलाई आफ्नो कार्टबाट हटाउन निश्चित हुनुहुन्छ?';

  @override
  String get cancel => 'रद्द गर्नुहोस्';

  @override
  String get delete => 'मेटाउनुस्';

  @override
  String get selectDeliveryLocation => 'डेलिभरी स्थान चयन गर्नुहोस्';

  @override
  String get confirmOrder => 'अर्डर पुष्टि गर्नुहोस्';

  @override
  String get deleteDeliveryAddressTitle => 'डेलिभरी ठेगाना मेटाउनुहोस्';

  @override
  String get deleteDeliveryAddressMessage =>
      'के तपाईं यो डेलिभरी ठेगाना मेटाउन चाहनुहुन्छ?';

  @override
  String get orderConfirmedTitle => 'अर्डर पुष्टि भयो';

  @override
  String get orderConfirmedMessage =>
      'तपाईंको अर्डर सफलतापूर्वक राखिएको छ। तपाईं आफ्नो अर्डर इतिहासबाट अर्डरहरू ट्र्याक गर्न सक्नुहुन्छ।';

  @override
  String get continueShopping => 'किनमेल जारी राख्नुहोस्';

  @override
  String get haveAnyQuestions => 'के तपाईंसँग कुनै प्रश्न छ?';

  @override
  String get connectToUs => 'हामीलाई सम्पर्क गर्नुहोस्';

  @override
  String get deliveryLocation => 'डेलिभरी ठेगाना';

  @override
  String get notSelected => 'छानिएको छैन';

  @override
  String get myOrder => 'मेरो अर्डर';

  @override
  String get activeOrders => 'सक्रिय अर्डर';

  @override
  String get inactiveOrders => 'निष्क्रिय अर्डर';

  @override
  String get rate => 'मूल्याङ्कन';

  @override
  String get orderPlaced => 'अर्डर प्राप्त';

  @override
  String get orderReceived => 'हामीले तपाईंको अर्डर प्राप्त गरेका छौं।';

  @override
  String get pending => 'विचाराधीन';

  @override
  String get confirmed => 'पुष्टि गरिएको';

  @override
  String get orderConfirmed => 'तपाईंको अर्डर पुष्टि गरिएको छ।';

  @override
  String get shipped => 'पठाइएको';

  @override
  String get orderShipped => 'हामीले तपाईंको अर्डर पठाएका छौं।';

  @override
  String get delivered => 'डेलिभर गरियो';

  @override
  String get orderDelivered => 'तपाईंको अर्डर डेलिभर गरियो।';

  @override
  String get cancelled => 'रद्द गरियो';

  @override
  String get orderCancelled => 'तपाईंको अर्डर रद्द गरिएको छ।';

  @override
  String get cancelOrder => 'अर्डर रद्द गर्नुहोस्';

  @override
  String get vendorNotAvailable => 'विक्रेता उपलब्ध छैन';

  @override
  String get customerNotAvailable => 'ग्राहक उपलब्ध छैन';

  @override
  String get productNotAvailable => 'उत्पादन उपलब्ध छैन';

  @override
  String get noActiveOrders => 'तपाईंको सक्रिय अर्डरहरूको सूची खाली छ';

  @override
  String get noOrdersMessage =>
      'अर्डर राखेपछि तपाईंले यहाँ अर्डरहरू देख्नुहुनेछ';

  @override
  String get seller => 'विक्रेता';

  @override
  String get noPhoneAvailable => 'फोन नम्बर उपलब्ध छैन';

  @override
  String get quantity => 'मात्रा';

  @override
  String get cancelOrderTitle => 'अर्डर रद्ध गर्नुहोस्';

  @override
  String get cancelOrderMessage => 'के तपाईं यो अर्डर रद्ध गर्न चाहनुहुन्छ?';

  @override
  String get inactiveOrdersTitle => 'तपाईंको निष्क्रिय अर्डरहरूको सूची खाली छ';

  @override
  String get inactiveOrdersDescription =>
      'अर्डर पूरा भएपछि वा रद्द भएपछि तपाईंले यहाँ अर्डरहरू देख्नुहुनेछ।';

  @override
  String get myProducts => 'मेरो उत्पादनहरू';

  @override
  String get myOrders => 'मेरो अर्डरहरू';

  @override
  String get thisMonth => 'यस महिना';

  @override
  String get grossSales => 'कुल बिक्री';

  @override
  String get averageSales => 'औसत बिक्री';

  @override
  String get totalProducts => 'कुल उत्पादन';

  @override
  String get totalOrders => 'कुल अर्डर';

  @override
  String get recentOrders => 'हालका अर्डरहरू';

  @override
  String get dashboard => 'ड्यासबोर्ड';

  @override
  String get income => 'आम्दानी';

  @override
  String get jan => 'जन';

  @override
  String get feb => 'फेब';

  @override
  String get mar => 'मार्च';

  @override
  String get apr => 'अप्रि';

  @override
  String get may => 'May';

  @override
  String get jun => 'जुन';

  @override
  String get jul => 'जुल';

  @override
  String get aug => 'अग';

  @override
  String get sep => 'सेप्ट';

  @override
  String get oct => 'अक्टो';

  @override
  String get nov => 'नोभे';

  @override
  String get dec => 'डिसे';

  @override
  String get customerName => 'ग्राहकको नाम';

  @override
  String get orderStatus => 'अर्डरको स्थिति';

  @override
  String get buyersGroups => 'खरिदकर्ताहरूको समूह';

  @override
  String get sellProduct => 'उत्पादन बिक्री';

  @override
  String get myProductsForSale => 'मेरो बिक्री सूची';

  @override
  String get emptyProductList => 'तपाईंको वर्तमान उत्पादन सूची खाली छ।';

  @override
  String get addProductForSale => 'बिक्रीका लागि उत्पादन थप्नुहोस्।';

  @override
  String get addSaleProduct => 'बिक्री उत्पादन थप गर्नुहोस';

  @override
  String get inStock => 'स्टकमा';

  @override
  String get status => 'स्थिति';

  @override
  String get active => 'सक्रिय';

  @override
  String get inactive => 'निष्क्रिय';

  @override
  String get vendorNewOrderMessage => 'नयाँ अर्डर राखिएको छ।';

  @override
  String get vendorProcessingMessage => 'तपाईंले अर्डर पुष्टि गर्नुभयो।';

  @override
  String get vendorShippedMessage => 'तपाईंले आफ्नो अर्डर पठाउनुभयो।';

  @override
  String get vendorDeliveredMessage => 'तपाईंले अर्डर डेलिभर गर्नुभयो।';

  @override
  String get vendorCancelledMessage => 'अर्डर रद्द गरिएको छ।';

  @override
  String get customer => 'ग्राहक';

  @override
  String get updateOrder => 'अर्डर अपडेट गर्नुहोस्';

  @override
  String get updateOrderStatus => 'अर्डर स्थिति अपडेट गर्नुहोस्';

  @override
  String get chooseNewStatus => 'यस अर्डरको लागि नयाँ स्थिति छान्नुहोस्।';

  @override
  String get recommendedVegetables => 'सिफारिस गरिएका तरकारीहरू';

  @override
  String get recommendedFruit => 'सिफारिस गरिएका फलफूलहरू';

  @override
  String get inventory => 'जिन्सी समान';

  @override
  String get inventoryBroken => 'जिन्सी \n समान';

  @override
  String get activeVendorOrdersDescription =>
      'तपाईंले अर्डरहरू प्राप्त गर्न सुरु गरेपछि यहाँ अर्डरहरू देख्नुहुनेछ।';

  @override
  String get kalimatiPrice => 'कालीमाटी \n मूल्य';

  @override
  String get subsidies => 'सरकारी सब्सिडी';

  @override
  String get myApplications => 'मेरो आवेदनहरू';

  @override
  String get noSubsidies => 'हाल कुनै सब्सिडी उपलब्ध छैन!';

  @override
  String get refresh => 'रिफ्रेस गर्नुहोस्';

  @override
  String get requestSubsidy => 'सब्सिडी अनुरोध गर्नुहोस्';

  @override
  String get applied => 'आवेदन दिइएको';

  @override
  String get applyNow => 'आवेदन';

  @override
  String get more => 'अधिक';

  @override
  String get less => 'कम';

  @override
  String get deadline => 'समयसीमा';

  @override
  String get expired => 'समाप्त भएको';

  @override
  String get eligibility => 'योग्यता मापदण्ड';

  @override
  String get targetSector => 'लक्षित बाली/क्षेत्र';

  @override
  String get locationLevel => 'स्तर';

  @override
  String get subsidyDetails => 'सब्सिडी विवरण';

  @override
  String get description => 'विवरण';

  @override
  String get fiscalYear => 'आर्थिक वर्ष';

  @override
  String get expectedBeneficiaries => 'अपेक्षित लाभार्थी';

  @override
  String get budgetPerBeneficiary => 'प्रत्येक लाभग्राहीको लागि बजेट';

  @override
  String get totalBudget => 'कुल बजेट';

  @override
  String get lastDate => 'अन्तिम मिति';

  @override
  String get locationDetails => 'स्थान विवरण';

  @override
  String get province => 'प्रदेश';

  @override
  String get district => 'जिल्ला';

  @override
  String get municipality => 'नगरपालिका';

  @override
  String get ward => 'वडा';

  @override
  String get alreadyApplied => 'पहिले नै आवेदन दिइसकियो';

  @override
  String get deadlinePassed => 'समयसीमा समाप्त भयो';

  @override
  String get applyForSubsidy => 'सब्सिडीको लागि आवेदन';

  @override
  String get applicationNotes => 'आवेदन नोटहरू';

  @override
  String get explainEligibility =>
      'तपाईं किन यो सब्सिडीको लागि योग्य हुनुहुन्छ भनी व्याख्या गर्नुहोस्';

  @override
  String get enterNotes => 'आफ्नो आवेदन टिप्पणी यहाँ लेख्नुहोस्...';

  @override
  String get submitApplication => 'आवेदन पेश गर्नुहोस्';

  @override
  String get noSubsidySelected => 'कुनै सब्सिडी चयन गरिएको छैन';

  @override
  String get applicationSuccessful => 'आवेदन सफलतापूर्वक पठाइयो';

  @override
  String get applicationFailed => 'आवेदन पठाउन असफल भयो';

  @override
  String get enterApplicationNotes => 'कृपया आवेदन टिप्पणी प्रविष्ट गर्नुहोस्';

  @override
  String get min10Characters => 'कृपया कम्तिमा १० वर्ण प्रविष्ट गर्नुहोस्';

  @override
  String get importantNote =>
      'तपाईंको आवेदन समीक्षा गरिनेछ। कृपया सही जानकारी प्रदान गर्नुहोस्।';

  @override
  String get rateReview => 'मूल्याङ्कन र समीक्षा';

  @override
  String get rateSubsidy => 'तपाईं यो सब्सिडीलाई कस्तो मूल्याङ्कन गर्नुहुन्छ?';

  @override
  String get shareExperience => 'आफ्नो अनुभव साझा गर्नुहोस्';

  @override
  String get submitReview => 'समीक्षा पेश गर्नुहोस्';

  @override
  String get poor => 'कमजोर';

  @override
  String get fair => 'औसत';

  @override
  String get good => 'राम्रो';

  @override
  String get veryGood => 'धेरै राम्रो';

  @override
  String get excellent => 'उत्कृष्ट';

  @override
  String get reviewSubmitted => 'समीक्षा सफलतापूर्वक पेश गरियो!';

  @override
  String get thankYou => 'तपाईंको प्रतिक्रियाको लागि धन्यवाद।';

  @override
  String get untitled => 'शीर्षकविहीन';

  @override
  String get noInfo => 'जानकारी उपलब्ध छैन';

  @override
  String get noDeadline => 'कुनै समयसीमा छैन';

  @override
  String get fertilizer => 'मल';

  @override
  String get equipment => 'उपकरण';

  @override
  String get training => 'तालिम';

  @override
  String get irrigation => 'सिंचाई';

  @override
  String get livestock => 'पशुपालन';

  @override
  String get seeds => 'बीउ';

  @override
  String get insurance => 'बीमा';

  @override
  String get loan => 'ऋण';

  @override
  String get organic => 'जैविक';

  @override
  String get general => 'सामान्य';

  @override
  String get central => 'केन्द्रीय';

  @override
  String get provinceLevel => 'प्रदेश स्तर';

  @override
  String get districtLevel => 'जिल्ला स्तर';

  @override
  String get municipalityLevel => 'नगरपालिका स्तर';

  @override
  String get wardLevel => 'वडा स्तर';

  @override
  String get requestNewSubsidy => 'नयाँ अनुदान अनुरोध गर्नुहोस्';

  @override
  String get subsidyTitle => 'सब्सिडी शीर्षक';

  @override
  String get category => 'श्रेणी';

  @override
  String get descriptionLabel => 'विवरण';

  @override
  String get descriptionHint => 'यो सब्सिडी किन आवश्यक छ वर्णन गर्नुहोस्...';

  @override
  String get submitRequest => 'अनुरोध पेश गर्नुहोस्';

  @override
  String get subsidyRequestSubmitted => 'अनुदान अनुरोध सफलतापूर्वक पेश गरियो';

  @override
  String get tellOtherFarmers =>
      'यो सब्सिडीसँग आफ्नो अनुभवको बारेमा अन्य किसानहरूलाई बताउनुहोस्...';

  @override
  String get tipMention =>
      'सुझाव: आवेदन प्रक्रिया, स्वीकृति समय, वा प्राप्त लाभहरू उल्लेख गर्नुहोस्';

  @override
  String get reviewHelps =>
      'तपाईंको समीक्षाले अन्य किसानहरूलाई सूचित निर्णय लिन मद्दत गर्दछ।';

  @override
  String get noApplicationsYet => 'तपाईंले अझै कुनै आवेदन दिनुभएको छैन!';

  @override
  String get withdrawApplication => 'आवेदन फिर्ता लिनुहोस्';

  @override
  String get withdrawConfirm =>
      'के तपाईं आफ्नो आवेदन फिर्ता लिन निश्चित हुनुहुन्छ';

  @override
  String get applicationWithdrawn => 'आवेदन सफलतापूर्वक फिर्ता लिइयो!';

  @override
  String get approved => 'स्वीकृत';

  @override
  String get rejected => 'अस्वीकृत';

  @override
  String get requiredDocumentsForApplication => 'आवेदनको लागि आवश्यक कागजातहरू';

  @override
  String get subsidyDetailDocuments => 'अनुदान विवरण कागजातहरू';

  @override
  String get documentsUploadWarning =>
      'आवेदन गर्दा तपाईंले यी कागजातहरू अपलोड गर्नु पर्नेछ';

  @override
  String get required => 'अनिवार्य';

  @override
  String get optional => 'वैकल्पिक';

  @override
  String get document => 'कागजात';

  @override
  String get cannotOpenDocument => 'कागजात खोल्न सकिएन';

  @override
  String get page => 'पृष्ठ';

  @override
  String get ofTxt => 'को';

  @override
  String get loading => 'लोड हुँदैछ';

  @override
  String get errorLoadingPdf => 'PDF लोड गर्न त्रुटि';

  @override
  String get applicationForm => 'आवेदन फारम';

  @override
  String get uploadFile => 'फाइल अपलोड गर्नुहोस्';

  @override
  String get changeFile => 'फाइल परिवर्तन गर्नुहोस्';

  @override
  String get errorLoadingImage => 'तस्बिर लोड गर्न त्रुटि भयो';

  @override
  String get success => 'सफलता';

  @override
  String get failed => 'असफल भयो';

  @override
  String get validationErrorMessage => 'प्रमाणीकरण त्रुटि';

  @override
  String get pleaseCheckAllFields => 'कृपया सबै आवश्यक फिल्डहरू जाँच गर्नुहोस्';

  @override
  String get documentRequired => 'कागजात अनिवार्य छ';

  @override
  String get invalidFileType => 'अवैध फाइल प्रकार';

  @override
  String pleaseUpload(Object types) {
    return 'कृपया यस प्रकारको फाइल अपलोड गर्नुहोस्: $types';
  }

  @override
  String get fileTooLarge => 'फाइलको आकार ५MB भन्दा कम हुनु पर्छ';

  @override
  String maximumFileSize(Object size) {
    return 'फाइलको अधिकतम साइज $size MB हो';
  }

  @override
  String get uploaded => 'अपलोड भयो';

  @override
  String get documentUploadedSuccessfully => 'कागजात सफलतापूर्वक अपलोड भयो';

  @override
  String get error => 'त्रुटि';

  @override
  String get failedToPickFile => 'फाइल चयन गर्न असफल';

  @override
  String get applicationWithdrawFailed => 'आवेदन फिर्ता गर्न असफल भयो';

  @override
  String get withdrawWarningMessage =>
      'के तपाईं आफ्नो आवेदन फिर्ता गर्न निश्चित हुनुहुन्छ?';

  @override
  String get withdraw => 'फिर्ता गर्नुहोस्';

  @override
  String get subsidyInformation => 'अनुदान सम्बन्धी जानकारी';

  @override
  String get applicationTimeline => 'आवेदन समयरेखा';

  @override
  String get appliedOn => 'कति बेलामा आवेदन गरियो';

  @override
  String get submittedInformation => 'पेश गरिएको विवरण';

  @override
  String get uploadedDocuments => 'अपलोड गरिएका कागजातहरू';

  @override
  String get applicationId => 'आवेदन आईडी';

  @override
  String get startApplyingMessage =>
      'अनुदानका लागि आवेदन गर्न सुरु गर्नुहोस्, यहाँ सूची देखिन्छ';

  @override
  String get exploreSubsidies => 'अनुदानहरू हेर्नुहोस्';

  @override
  String get viewDetails => 'विवरण हेर्नुहोस्';

  @override
  String get congratulations => 'बधाई छ!';

  @override
  String get applicationApprovedMessage =>
      'तपाईंको आवेदन स्वीकृत भएको छ। थप निर्देशन चाँडै प्रदान गरिनेछ।';

  @override
  String get applicationRejected => 'आवेदन अस्वीकृत भयो';

  @override
  String get applicationRejectedMessage =>
      'दुर्भाग्यवश, तपाईंको आवेदन स्वीकृत भएन। योग्यता भएमा पुनः आवेदन दिन सक्नुहुन्छ।';

  @override
  String get underReview => 'समीक्षाधीन';

  @override
  String get applicationPendingMessage =>
      'तपाईंको आवेदन हाल समिक्षामा छ। निर्णय भएपछि हामीले तपाईंलाई सूचित गर्नेछौं।';

  @override
  String get yes => 'हो';

  @override
  String get no => 'होइन';

  @override
  String get applicationDetails => 'आवेदन विवरण';

  @override
  String get submitted => 'पेश गरिएको';

  @override
  String get reviewed => 'समिक्षा गरियो';

  @override
  String get title => 'शीर्षक';

  @override
  String get subsidyType => 'प्रकार';

  @override
  String get fromReviewer => 'समिक्षकबाट';

  @override
  String get notesDisclaimer =>
      'यी नोटहरू एप्लिकेशन समिक्षकद्वारा प्रदान गरिएको हुन्।';

  @override
  String get updateReview => 'समीक्षा अपडेट गर्नुहोस्';

  @override
  String get ratingFailed => 'मूल्याङ्कन पेश गर्न असफल';

  @override
  String get deleteRating => 'मूल्याङ्कन मेटाउनुहोस्';

  @override
  String get confirmDelete => 'मेटाउन पुष्टि गर्नुहोस्';

  @override
  String get deleteRatingConfirm =>
      'के तपाईं आफ्नो मूल्याङ्कन मेटाउन निश्चित हुनुहुन्छ?';

  @override
  String get ratingDeleted => 'मूल्याङ्कन सफलतापूर्वक मेटाइयो';

  @override
  String get ratingDeleteFailed => 'मूल्याङ्कन मेटाउन असफल';

  @override
  String get reviewUpdated => 'समीक्षा अपडेट गरियो';

  @override
  String get locationRequired => 'स्थान जानकारी आवश्यक छ';

  @override
  String get locationRequiredDescription =>
      'अनुदान सुविधाहरू पहुँच गर्न, कृपया पहिले आफ्नो प्रोफाइलमा स्थान जानकारी थप्नुहोस्।';

  @override
  String get whyLocationNeeded => 'किन स्थान आवश्यक छ?';

  @override
  String get locationReason1 =>
      'तपाईंको क्षेत्रका लागि उपलब्ध अनुदानहरू देखाउन';

  @override
  String get locationReason2 => 'सरकारी अनुदान कार्यक्रमहरूमा आवेदन दिन';

  @override
  String get locationReason3 => 'तपाईंको नजिकका स्थानीय सुविधाहरू पत्ता लगाउन';

  @override
  String get addLocation => 'स्थान थप्नुहोस्';

  @override
  String get goBack => 'पछाडि जानुहोस्';

  @override
  String get editProfile => 'प्रोफाइल सम्पादन गर्नुहोस्';

  @override
  String get notifications => 'सूचनाहरू';

  @override
  String get privacy => 'गोपनीयता र सुरक्षा';

  @override
  String get about => 'बारेमा';

  @override
  String get help => 'मद्दत र समर्थन';

  @override
  String get location => 'स्थान';

  @override
  String get selectLanguage => 'आफ्नो मनपर्ने भाषा चयन गर्नुहोस्';

  @override
  String get confirmLogout => 'लगआउट पुष्टि गर्नुहोस्';

  @override
  String get logoutMessage => 'के तपाईं लगआउट गर्न निश्चित हुनुहुन्छ?';

  @override
  String get locationNotSet => 'स्थान सेट गरिएको छैन';

  @override
  String get aboutUs => 'हाम्रो बारेमा';

  @override
  String get changePassword => 'पासवर्ड परिवर्तन गर्नुहोस्';

  @override
  String get updateLocation => 'स्थान अपडेट गर्नुहोस्';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get enterFullName => 'पूरा नाम प्रविष्ट गर्नुहोस्';

  @override
  String get pleaseEnterName => 'कृपया नाम प्रविष्ट गर्नुहोस्';

  @override
  String get nameTooShort => 'नाम धेरै छोटो छ';

  @override
  String get email => 'इमेल';

  @override
  String get enterEmail => 'इमेल प्रविष्ट गर्नुहोस्';

  @override
  String get pleaseEnterEmail => 'कृपया इमेल प्रविष्ट गर्नुहोस्';

  @override
  String get invalidEmail => 'अमान्य इमेल';

  @override
  String get enterPhoneNumber => 'फोन नम्बर प्रविष्ट गर्नुहोस्';

  @override
  String get pleaseEnterPhone => 'कृपया फोन नम्बर प्रविष्ट गर्नुहोस्';

  @override
  String get updateProfile => 'प्रोफाइल अपडेट गर्नुहोस्';

  @override
  String get profileUpdatedSuccessfully => 'प्रोफाइल सफलतापूर्वक अपडेट गरियो';

  @override
  String get profileUpdateFailed => 'प्रोफाइल अपडेट गर्न असफल';

  @override
  String get errorOccurred => 'त्रुटि देखा पर्‍यो';

  @override
  String get currentPassword => 'हालको पासवर्ड';

  @override
  String get enterCurrentPassword => 'हालको पासवर्ड प्रविष्ट गर्नुहोस्';

  @override
  String get pleaseEnterCurrentPassword =>
      'कृपया हालको पासवर्ड प्रविष्ट गर्नुहोस्';

  @override
  String get newPassword => 'नयाँ पासवर्ड';

  @override
  String get enterNewPassword => 'नयाँ पासवर्ड प्रविष्ट गर्नुहोस्';

  @override
  String get pleaseEnterNewPassword => 'कृपया नयाँ पासवर्ड प्रविष्ट गर्नुहोस्';

  @override
  String get passwordTooShort => 'पासवर्ड कम्तिमा ६ अक्षरको हुनुपर्छ';

  @override
  String get confirmPassword => 'पासवर्ड पुष्टि गर्नुहोस्';

  @override
  String get enterConfirmPassword => 'पासवर्ड पुष्टि गर्नुहोस्';

  @override
  String get pleaseConfirmPassword => 'कृपया पासवर्ड पुष्टि गर्नुहोस्';

  @override
  String get passwordsDoNotMatch => 'पासवर्डहरू मेल खाँदैनन्';

  @override
  String get updatePassword => 'पासवर्ड अपडेट गर्नुहोस्';

  @override
  String get passwordUpdatedSuccessfully => 'पासवर्ड सफलतापूर्वक अपडेट गरियो';

  @override
  String get passwordUpdateFailed => 'पासवर्ड अपडेट गर्न असफल';

  @override
  String get selectProvince => 'प्रदेश चयन गर्नुहोस्';

  @override
  String get selectDistrict => 'जिल्ला चयन गर्नुहोस्';

  @override
  String get selectMunicipality => 'नगरपालिका चयन गर्नुहोस्';

  @override
  String get selectWard => 'वडा चयन गर्नुहोस्';

  @override
  String get address => 'ठेगाना';

  @override
  String get enterAddress => 'ठेगाना प्रविष्ट गर्नुहोस्';

  @override
  String get pleaseEnterAddress => 'कृपया ठेगाना प्रविष्ट गर्नुहोस्';

  @override
  String get pleaseSelectAllLocationFields =>
      'कृपया सबै स्थान फिल्डहरू चयन गर्नुहोस्';

  @override
  String get locationUpdatedSuccessfully => 'स्थान सफलतापूर्वक अपडेट गरियो';

  @override
  String get locationUpdateFailed => 'स्थान अपडेट गर्न असफल';

  @override
  String get accountInformation => 'खाता जानकारी';

  @override
  String get updateYourPersonalInformation =>
      'आफ्नो व्यक्तिगत जानकारी अपडेट गर्नुहोस्';

  @override
  String get updateYourAddress => 'आफ्नो ठेगाना अपडेट गर्नुहोस्';

  @override
  String get updateYourPassword => 'आफ्नो पासवर्ड अपडेट गर्नुहोस्';

  @override
  String get myRequests => 'मेरो अनुरोधहरू';

  @override
  String get noRequests => 'कुनै अनुरोध छैन';

  @override
  String get noRequestsDescription =>
      'तपाईंले कुनै अनुदान अनुरोध पेश गर्नुभएको छैन';

  @override
  String get enterTitle => 'अनुदान शीर्षक प्रविष्ट गर्नुहोस्';

  @override
  String get pleaseEnterTitle => 'कृपया गुनासो शीर्षक प्रविष्ट गर्नुहोस्';

  @override
  String get targetCrop => 'लक्षित बाली/खण्ड';

  @override
  String get enterTargetCrop => 'जस्तै, धान, गहुँ';

  @override
  String get pleaseEnterDescription => 'कृपया विवरण प्रविष्ट गर्नुहोस्';

  @override
  String get justification => 'औचित्य';

  @override
  String get justificationHint =>
      'तपाईंलाई यो अनुदान किन आवश्यक छ भन्ने बताउनुहोस्';

  @override
  String get pleaseEnterJustification => 'कृपया आफ्नो आवश्यकता बताउनुहोस्';

  @override
  String get requestTo => 'अनुरोध गर्ने';

  @override
  String get requestInfo =>
      'तपाईंको अनुरोध सरकारी अधिकारीहरूले समीक्षा गर्नेछन्';

  @override
  String get pleaseSelectAll => 'कृपया सबै आवश्यक फाँटहरू चयन गर्नुहोस्';

  @override
  String get requestFailed => 'अनुरोध पेश गर्न असफल';

  @override
  String get converted => 'रूपान्तरण गरिएको';

  @override
  String get rejectionReason => 'अस्वीकृतिको कारण';

  @override
  String get yesCancel => 'हो, रद्द गर्नुहोस्';

  @override
  String get confirmCancel => 'अनुरोध रद्द गर्नुहोस्';

  @override
  String get cancelRequestMessage =>
      'के तपाईं यो अनुरोध रद्द गर्न निश्चित हुनुहुन्छ?';

  @override
  String get requestCancelled => 'अनुरोध सफलतापूर्वक रद्द गरियो';

  @override
  String get cannotCancel => 'अनुरोध रद्द गर्न सकिँदैन';

  @override
  String get noRequestSelected => 'कुनै अनुरोध चयन गरिएको छैन';

  @override
  String get requestInformation => 'अनुरोध जानकारी';

  @override
  String get requestId => 'अनुरोध ID';

  @override
  String get requestedTo => 'अनुरोध गरिएको';

  @override
  String get submittedOn => 'पेश गरिएको मिति';

  @override
  String get reviewedOn => 'समीक्षा गरिएको मिति';

  @override
  String get subsidyId => 'अनुदान ID';

  @override
  String get adminNotes => 'प्रशासकीय नोटहरू';

  @override
  String get cancelRequest => 'अनुरोध रद्द गर्नुहोस्';

  @override
  String get cancelRequestConfirm =>
      'के तपाईं यो अनुरोध रद्द गर्न निश्चित हुनुहुन्छ? यो क्रिया पूर्ववत गर्न सकिँदैन।';

  @override
  String get requestConverted => 'अनुरोध रूपान्तरण गरियो!';

  @override
  String get convertedToSubsidy => 'तपाईंको अनुरोध रूपान्तरण गरिएको छ';

  @override
  String get viewSubsidy => 'अनुदान हेर्नुहोस्';

  @override
  String get requestSubsidyHint => 'सरकारबाट अनुदान अनुरोध गर्नुहोस्';

  @override
  String get fileComplaint => 'गुनासो दर्ता गर्नुहोस्';

  @override
  String get myComplaints => 'मेरा गुनासोहरू';

  @override
  String get complaintDetails => 'गुनासो विवरण';

  @override
  String get reportYourIssue => 'आफ्नो समस्या रिपोर्ट गर्नुहोस्';

  @override
  String get weAreHereToHelp => 'हामी तपाईंको समस्या समाधान गर्न यहाँ छौं';

  @override
  String get reportIssues => 'समस्या रिपोर्ट गर्नुहोस्';

  @override
  String get fileComplaints => 'गुनासो दर्ता गर्नुहोस्';

  @override
  String get reportProblemsToGovernment =>
      'सरकारलाई आफ्नो समस्या रिपोर्ट गर्नुहोस्';

  @override
  String get complaintCategory => 'गुनासो श्रेणी';

  @override
  String get priorityLevel => 'प्राथमिकता स्तर';

  @override
  String get complaintTitle => 'गुनासो शीर्षक';

  @override
  String get detailedDescription => 'विस्तृत विवरण';

  @override
  String get specificLocation => 'विशेष स्थान';

  @override
  String get submitTo => 'पेश गर्नुहोस्';

  @override
  String get locationDetailsOptional => 'स्थान विवरण (ऐच्छिक)';

  @override
  String get locationHint => 'जस्तै: विद्यालय नजिक, मुख्य सडक, आदि।';

  @override
  String get enterComplaintTitle =>
      'आफ्नो गुनासोको छोटो शीर्षक प्रविष्ट गर्नुहोस्';

  @override
  String get describeComplaint => 'आफ्नो गुनासोको विस्तृत विवरण दिनुहोस्...';

  @override
  String get pleaseProvideDescription => 'कृपया गुनासो विवरण प्रदान गर्नुहोस्';

  @override
  String get descriptionMinLength => 'विवरण कम्तिमा २० वर्णको हुनुपर्छ';

  @override
  String get pleaseSelectCategory => 'कृपया गुनासो श्रेणी चयन गर्नुहोस्';

  @override
  String get pleaseSelectPriority => 'कृपया प्राथमिकता स्तर चयन गर्नुहोस्';

  @override
  String get pleaseSelectLevel => 'कृपया सरकारी स्तर चयन गर्नुहोस्';

  @override
  String get cropDisease => 'बाली रोग';

  @override
  String get pestInfestation => 'कीरा प्रकोप';

  @override
  String get irrigationIssue => 'सिँचाइ';

  @override
  String get roadInfrastructure => 'सडक';

  @override
  String get fertilizerQuality => 'मल';

  @override
  String get seedQuality => 'बीउ';

  @override
  String get equipmentIssue => 'उपकरण';

  @override
  String get waterSupply => 'पानी';

  @override
  String get marketAccess => 'बजार';

  @override
  String get extensionService => 'विस्तार सेवा';

  @override
  String get subsidyRelated => 'अनुदान';

  @override
  String get electricity => 'बिजुली';

  @override
  String get other => 'अन्य';

  @override
  String get urgent => 'अत्यावश्यक';

  @override
  String get high => 'उच्च';

  @override
  String get medium => 'मध्यम';

  @override
  String get low => 'कम';

  @override
  String get centralLevel => 'केन्द्रीय स्तर';

  @override
  String get acknowledged => 'स्वीकृत';

  @override
  String get underInvestigation => 'अनुसन्धान अन्तर्गत';

  @override
  String get inProgress => 'प्रगतिमा';

  @override
  String get forwarded => 'अग्रसारित';

  @override
  String get resolved => 'समाधान भयो';

  @override
  String get closed => 'बन्द';

  @override
  String get submitComplaint => 'गुनासो पेश गर्नुहोस्';

  @override
  String get newComplaint => 'नयाँ गुनासो';

  @override
  String get cancelComplaint => 'गुनासो रद्द गर्नुहोस्';

  @override
  String get complaintSubmitted => 'गुनासो सफलतापूर्वक पेश गरियो!';

  @override
  String get complaintCancelled => 'गुनासो सफलतापूर्वक रद्द गरियो';

  @override
  String get failedToSubmit =>
      'गुनासो पेश गर्न असफल भयो। कृपया पुन: प्रयास गर्नुहोस्।';

  @override
  String get failedToCancel => 'गुनासो रद्द गर्न असफल भयो';

  @override
  String get noComplaintsFound => 'कुनै गुनासो फेला परेन';

  @override
  String get fileComplaintToGetStarted => 'सुरु गर्न गुनासो दर्ता गर्नुहोस्';

  @override
  String get confirmCancelComplaint =>
      'के तपाईं यो गुनासो रद्द गर्न निश्चित हुनुहुन्छ? यो कार्य पूर्ववत गर्न सकिँदैन।';

  @override
  String get noKeepIt => 'होइन, राख्नुहोस्';

  @override
  String get all => 'सबै';

  @override
  String get priority => 'प्राथमिकता';

  @override
  String get assignedTo => 'तोकिएको';

  @override
  String get resolution => 'समाधान';

  @override
  String get resolvedOn => 'समाधान मिति';

  @override
  String get coordinates => 'अक्षांश र देशांतर';

  @override
  String get latitude => 'अक्षांश';

  @override
  String get longitude => 'देशांतर';

  @override
  String get enterLatitude => 'अक्षांश प्रविष्ट गर्नुहोस्';

  @override
  String get enterLongitude => 'देशांतर प्रविष्ट गर्नुहोस्';

  @override
  String get getMyLocation => 'मेरो स्थान प्राप्त गर्नुहोस्';

  @override
  String get locationFetched => 'स्थान सफलतापूर्वक प्राप्त गरियो';

  @override
  String get failedToGetLocation => 'स्थान प्राप्त गर्न असफल';

  @override
  String get attachment => 'संलग्नक';

  @override
  String get attachmentDescription =>
      'फाइल संलग्न गर्नुहोस् (PDF, JPG, PNG - अधिकतम ५MB)';

  @override
  String get chooseFile => 'फाइल चयन गर्नुहोस्';

  @override
  String get fileAttached => 'फाइल सफलतापूर्वक संलग्न गरियो';

  @override
  String get preview => 'पूर्वावलोकन';

  @override
  String get remove => 'हटाउनुहोस्';

  @override
  String get attachmentPreview => 'संलग्नक पूर्वावलोकन';

  @override
  String attachmentsCount(int count) {
    return 'संलग्नकहरू ($count)';
  }

  @override
  String get comments => 'टिप्पणीहरू';

  @override
  String commentsCount(int count) {
    return 'टिप्पणीहरू ($count)';
  }

  @override
  String get addComment => 'टिप्पणी थप्नुहोस्...';

  @override
  String get pleaseEnterComment => 'कृपया टिप्पणी प्रविष्ट गर्नुहोस्';

  @override
  String get commentMinLength => 'टिप्पणी कम्तिमा ३ अक्षर हुनुपर्छ';

  @override
  String get commentAddedSuccessfully => 'टिप्पणी सफलतापूर्वक थपियो';

  @override
  String get failedToAddComment => 'टिप्पणी थप्न असफल भयो';

  @override
  String get send => 'पठाउनुहोस्';

  @override
  String get surveys => 'सर्वेक्षणहरू';

  @override
  String get survey => 'सर्वेक्षण';

  @override
  String get available => 'उपलब्ध';

  @override
  String get completed => 'सम्पन्न';

  @override
  String get startSurvey => 'सर्वेक्षण सुरु गर्नुहोस्';

  @override
  String get takeAgain => 'फेरि भर्नुहोस्';

  @override
  String get canRetake => 'पुनः भर्न सकिन्छ';

  @override
  String questionsCount(String count) {
    return '$count प्रश्नहरू';
  }

  @override
  String respondedTimes(String count) {
    return '$count पटक जवाफ दिइयो';
  }

  @override
  String estimatedMinutes(String min) {
    return '~$min मिनेट';
  }

  @override
  String endsOn(String date) {
    return 'अन्त्य: $date';
  }

  @override
  String get noAvailableSurveys => 'कुनै उपलब्ध सर्वेक्षण छैन';

  @override
  String get checkBackLater => 'नयाँ सर्वेक्षणका लागि पछि फेरि हेर्नुहोस्';

  @override
  String get noCompletedSurveys => 'कुनै सम्पन्न सर्वेक्षण छैन';

  @override
  String get completeSurveysToSee => 'यहाँ देख्न सर्वेक्षणहरू पूरा गर्नुहोस्';

  @override
  String get noSurveysAvailable => 'कुनै सर्वेक्षण उपलब्ध छैन';

  @override
  String get noSurveysAvailableDesc =>
      'अहिले तपाईंका लागि कुनै सर्वेक्षण उपलब्ध छैन';

  @override
  String get pullDownToRefresh => 'ताजा गर्न तल तान्नुहोस्';

  @override
  String get surveyTypeCropProduction => 'बाली उत्पादन';

  @override
  String get surveyTypeLivestockCensus => 'पशुधन गणना';

  @override
  String get surveyTypeLandUsage => 'भूमि उपयोग';

  @override
  String get surveyTypeFarmerSatisfaction => 'किसान सन्तुष्टि';

  @override
  String get surveyTypeSubsidyImpact => 'अनुदान प्रभाव';

  @override
  String get surveyTypeTrainingNeeds => 'तालिम आवश्यकता';

  @override
  String get surveyTypeMarketAccess => 'बजार पहुँच';

  @override
  String get surveyTypeGeneral => 'सामान्य सर्वेक्षण';

  @override
  String get noQuestionsFound => 'यस सर्वेक्षणमा कुनै प्रश्न फेला परेन';

  @override
  String get answerAllRequired =>
      'कृपया सबै अनिवार्य प्रश्नहरूको जवाफ दिनुहोस्';

  @override
  String get surveySubmittedSuccess => 'सर्वेक्षण सफलतापूर्वक पेश भयो';

  @override
  String get surveySubmitFailed => 'सर्वेक्षण पेश गर्न असफल भयो';

  @override
  String get validationError => 'प्रमाणीकरण त्रुटि';

  @override
  String get checkRequiredFields =>
      'कृपया सबै अनिवार्य फिल्डहरू जाँच गर्नुहोस्';

  @override
  String get requiredQuestion => 'अनिवार्य प्रश्न';

  @override
  String get noSurveySelected => 'कुनै सर्वेक्षण चयन गरिएको छैन';

  @override
  String get loadingSurveyQuestions => 'सर्वेक्षण प्रश्नहरू लोड हुँदैछ...';

  @override
  String get noQuestionsAvailable =>
      'यस सर्वेक्षणका लागि कुनै प्रश्न उपलब्ध छैन';

  @override
  String get fileUploads => 'फाइल अपलोडहरू';

  @override
  String get locationInformation => 'स्थान जानकारी';

  @override
  String get instruction => 'निर्देशन';

  @override
  String get requiredLabel => 'अनिवार्य';

  @override
  String get defaultEligibility =>
      '२ हेक्टर सम्मको जोत भएका साना र सीमान्त किसानहरु';

  @override
  String get fileUploaded => 'फाइल सफलतापूर्वक अपलोड भयो';

  @override
  String get enterYourAnswer => 'तपाईंको जवाफ लेख्नुहोस्';

  @override
  String get fieldRequired => 'यो फिल्ड अनिवार्य छ';

  @override
  String minCharactersRequired(String count) {
    return 'कम्तिमा $count अक्षर आवश्यक छ';
  }

  @override
  String get enterNumber => 'एउटा संख्या लेख्नुहोस्';

  @override
  String get enterValidNumber => 'कृपया मान्य संख्या लेख्नुहोस्';

  @override
  String minValueIs(String value) {
    return 'न्यूनतम मान $value हो';
  }

  @override
  String maxValueIs(String value) {
    return 'अधिकतम मान $value हो';
  }

  @override
  String get selectOption => 'एउटा विकल्प छान्नुहोस्';

  @override
  String get pleaseSelectOption => 'कृपया एउटा विकल्प छान्नुहोस्';

  @override
  String get selectDate => 'मिति छान्नुहोस्';

  @override
  String ratingOutOf(String rating, String max) {
    return '$max मध्ये $rating';
  }

  @override
  String get allowedFileFormats => 'PDF, JPG, PNG, DOC';

  @override
  String get maxFileSizeLabel => 'अधिकतम ५ MB';

  @override
  String get currentLocation => 'हालको स्थान';

  @override
  String get currentLocationSet => 'हालको स्थान सेट गरिएको छ';

  @override
  String get locationSet => 'स्थान सेट भयो';

  @override
  String get chooseOnMap => 'नक्सामा छान्नुहोस्';

  @override
  String get comingSoon => 'चाँडै आउँदैछ';

  @override
  String get mapPickerComingSoon => 'नक्सा छान्ने सुविधा चाँडै आउँदैछ';

  @override
  String latLngLabel(String lat, String lng) {
    return 'अक्षांश: $lat, देशान्तर: $lng';
  }

  @override
  String get importantNoteLabel => 'महत्त्वपूर्ण टिप्पणी';

  @override
  String get surveyImportantNote =>
      'पेश गर्नु अघि सबै अनिवार्य प्रश्नहरूको जवाफ दिनुपर्छ। तपाईंको जवाफले कृषि सेवाहरू सुधार गर्न मद्दत गर्नेछ।';

  @override
  String get submitting => 'पेश गर्दैछ...';

  @override
  String get submitSurvey => 'सर्वेक्षण पेश गर्नुहोस्';
}
