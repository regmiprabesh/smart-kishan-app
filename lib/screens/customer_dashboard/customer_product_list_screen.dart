import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/screens/customer_dashboard/widgets/buy_products_list.dart';
import 'package:smart_kishan/screens/customer_dashboard/widgets/rotating_listview_icon.dart';
import 'package:smart_kishan/screens/customer_dashboard/widgets/buy_products_grid.dart';
import 'package:smart_kishan/screens/customer_dashboard/widgets/sliding_filters.dart';
import 'package:smart_kishan/screens/customer_dashboard/widgets/sort_product_buttonsheet.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class CustomerProductListScreen extends StatefulWidget {
  const CustomerProductListScreen({super.key});

  @override
  State<CustomerProductListScreen> createState() =>
      _CustomerProductListScreenState();
}

class _CustomerProductListScreenState extends State<CustomerProductListScreen> {
  bool isListView = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   // automaticallyImplyLeading: false,
      //   leading: Icon(
      //     Icons.arrow_back,
      //     color: kCardTitleColor,
      //   ),
      //   title: Text(
      //     'Products',
      //     style: TextStyle(color: kCardTitleColor),
      //   ),
      //   backgroundColor: Colors.white,
      // ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Obx(
                () => TextFormField(
                  controller: TextEditingController(
                      text: buyProductsController.searchName.value),
                  style: TextStyle(fontSize: 14),
                  cursorColor: kPrimaryColor,
                  cursorHeight: 15,
                  textInputAction: TextInputAction.search,
                  onFieldSubmitted: (value) {
                    buyProductsController.searchProducts(name: value);
                    buyProductsController.searchName(value);
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    suffixIcon: buyProductsController
                            .searchName.value.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.all(5),
                            child: Ink(
                              decoration: ShapeDecoration(
                                color: kErrorColor.withOpacity(0.2),
                                shape: CircleBorder(),
                              ),
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: IconButton(
                                    iconSize: 15,
                                    color: kErrorColor,
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      if (buyProductsController
                                              .searchName.value.isNotEmpty &&
                                          buyProductsController
                                                  .searchName.value !=
                                              '') {
                                        buyProductsController.searchName('');
                                        buyProductsController.searchProducts();
                                      } else {}
                                    }),
                              ),
                            ),
                          )
                        : null,
                    prefixIcon: Icon(Icons.search),
                    fillColor: kPrimaryGrey.withOpacity(0.4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kPrimaryGrey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kPrimaryGrey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kPrimaryGrey),
                    ),
                    hintText:
                        AppLocalizations.of(context)!.whatAreYouLookingFor,
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey.withOpacity(0.9),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: SlidingFilters()),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () {
                                  final count =
                                      buyProductsController.allProducts.length;
                                  final isNepali =
                                      Localizations.localeOf(context)
                                              .languageCode ==
                                          'ne';

                                  // Get the localized string with the raw count (integer)
                                  String localizedString =
                                      AppLocalizations.of(context)!
                                          .productResults(count);

                                  // Convert the count to Nepali numerals if the language is Nepali
                                  final countInNumerals = isNepali
                                      ? convertToNepaliNumber(count.toString())
                                      : count.toString();

                                  // Replace the placeholder with the Nepali or regular count
                                  localizedString =
                                      localizedString.replaceFirst(
                                          count.toString(), countInNumerals);

                                  return Text(
                                    localizedString,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                              Obx(
                                () => buildSearchResultDescription(
                                  context: context,
                                  name: buyProductsController.searchName.value,
                                  sortCode: buyProductsController.sortBy.value,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          RotatingListViewIcon(
                            currentValue: isListView,
                            onTap: (bool value) {
                              setState(() {
                                isListView = value;
                              });
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Material(
                            color: Colors.transparent,
                            child: Ink(
                              decoration: ShapeDecoration(
                                color: kPrimaryGrey.withOpacity(0.6),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: SizedBox(
                                height: 45,
                                width: 45,
                                child: IconButton(
                                  iconSize: 20,
                                  color: kPrimaryColor,
                                  icon: HugeIcon(
                                      icon: HugeIcons.strokeRoundedSorting05),
                                  onPressed: () =>
                                      _showSortBottomSheet(context),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Obx(
                      () => buyProductsController.allProducts.isNotEmpty
                          ? isListView
                              ? BuyProductsList(
                                  products: buyProductsController.allProducts)
                              : BuyProductsGrid(
                                  products: buyProductsController.allProducts)
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/empty_search.png',
                                  height: 200,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.noResultFound,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: kCardTitleColor,
                                  ),
                                ),
                                Text(
                                  AppLocalizations.of(context)!
                                      .noResultFoundDesc,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: kCardDescColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SortProductButtonsheet(
          selectedOption: buyProductsController
              .sortBy.value, // Pass the current selected option
          onOptionSelected: (selectedOption, code) {
            buyProductsController.sortBy(code);
            // Call the API with the selected option
            buyProductsController.searchProducts(
              name: buyProductsController.searchName.value,
              sortsBy: buyProductsController.sortBy.value,
            );
          },
        );
      },
    );
  }

  Widget buildSearchResultDescription({
    required BuildContext context,
    required String? name,
    required String sortCode,
  }) {
    String description;
    if (name != null && name.isNotEmpty) {
      // Show the search result text if a name is provided
      description = "Search result for '$name'";
    } else {
      // Show sorting-related descriptions if no name is provided
      switch (sortCode) {
        case 'Newest':
          description = AppLocalizations.of(context)!.showingNewestResults;
          break;
        case 'LowToHigh':
          description = AppLocalizations.of(context)!.showingLowToHighResults;
          break;
        case 'HighToLow':
          description = AppLocalizations.of(context)!.showingHighToLowResults;
          break;
        default:
          description = AppLocalizations.of(context)!.showingDefaultResults;
      }
    }

    return Text(
      description,
      style: const TextStyle(fontSize: 13, color: kCardDescColor),
    );
  }
}
