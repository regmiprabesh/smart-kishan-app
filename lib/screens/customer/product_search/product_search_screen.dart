import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/models/cropCategory.dart';
import 'package:smart_kishan/models/searchHistory.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  final TextEditingController _searchTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
    buyProductsController.searchName.value != ''
        ? _searchTextController.text = buyProductsController.searchName.value
        : _searchTextController.text = '';

    _searchTextController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          AppLocalizations.of(context)!.searchProducts,
          style: TextStyle(color: kCardTitleColor),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Divider(
            height: 2,
            color: kPrimaryGrey,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Ink(
              decoration: ShapeDecoration(
                color: kPrimaryGrey.withOpacity(0.4),
                shape: CircleBorder(),
              ),
              child: SizedBox(
                height: 30,
                width: 30,
                child: IconButton(
                  iconSize: 15,
                  color: kCardTitleColor,
                  icon: Icon(Icons.close),
                  onPressed: () {
                    if (buyProductsController.searchName.value.isEmpty ||
                        buyProductsController.searchName.value == '') {
                      _searchTextController.clear();
                    }
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Fixed Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: SizedBox(
                height: 42,
                child: Obx(
                  () => TextFormField(
                    controller: TextEditingController(
                        text: buyProductsController.searchName.value),
                    style: TextStyle(fontSize: 14),
                    cursorColor: kPrimaryColor,
                    cursorHeight: 15,
                    textInputAction: TextInputAction.search,
                    onFieldSubmitted: (value) async {
                      // Call the search function
                      buyProductsController.searchProducts(name: value);
                      buyProductsController.searchName(value);
                      customerDashboardController.updateIndex(1);
                      Get.toNamed(AppRoute.customerDashboard);
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      suffixIcon: _searchTextController.text.isNotEmpty
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
                                        _searchTextController.clear();
                                      } else {
                                        _searchTextController.clear();
                                      }
                                    },
                                  ),
                                ),
                              ),
                            )
                          : null,
                      prefixIcon: Icon(Icons.search),
                      fillColor: kPrimaryGrey.withOpacity(0.4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: kPrimaryGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: kPrimaryGrey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
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
            ),
            Divider(
              height: 2,
              color: kPrimaryGrey,
            ),
            SizedBox(height: 10),
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Searches Section
                      Obx(() => searchHistoryController.searchHistory.isEmpty
                          ? SizedBox()
                          : Text(
                              AppLocalizations.of(context)!.searchHistory,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            )),
                      Obx(
                        () => searchHistoryController.searchHistory.isEmpty
                            ? SizedBox()
                            : ListView.separated(
                                padding: EdgeInsets.only(bottom: 10),
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: searchHistoryController
                                    .searchHistory.length,
                                separatorBuilder: (context, index) => Divider(
                                  color: Colors.grey.withOpacity(0.9),
                                  thickness: 0.4,
                                  height: 4,
                                ),
                                itemBuilder: (context, index) {
                                  SearchHistory currentHistory =
                                      searchHistoryController
                                          .searchHistory[index];
                                  return ListTile(
                                    onTap: () {
                                      // Get the clicked item
                                      SearchHistory clickedItem =
                                          searchHistoryController
                                              .searchHistory[index];

                                      // Check if the clicked item is not already at the top
                                      if (index != 0) {
                                        // Remove the clicked item from its current position
                                        searchHistoryController.searchHistory
                                            .removeAt(index);

                                        // Insert it at the top
                                        searchHistoryController.searchHistory
                                            .insert(0, clickedItem);
                                      }

                                      // Update the date to the current time
                                      clickedItem.searchedAt = DateTime
                                          .now(); // Update with current date

                                      // Perform the desired actions
                                      buyProductsController
                                          .searchName(clickedItem.searchTerm);
                                      buyProductsController.searchProducts(
                                          name: clickedItem.searchTerm);
                                      customerDashboardController
                                          .updateIndex(1);
                                      Get.back();
                                    },
                                    contentPadding: EdgeInsets.all(0),
                                    dense: true,
                                    visualDensity: VisualDensity.compact,
                                    minVerticalPadding: 0,
                                    leading: Icon(Icons.history),
                                    title: Text(
                                      currentHistory.searchTerm,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: Text(
                                      '${formatDate(currentHistory.searchedAt, AppLocalizations.of(context)!.localeName)}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: kCardDescColor,
                                      ),
                                      maxLines: 1,
                                    ),
                                  );
                                },
                              ),
                      ),
                      // Explore Categories Section
                      Text(
                        AppLocalizations.of(context)!.exploreCategories,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10),
                      Obx(
                        () => cropCategoryController.cropCategories.isNotEmpty
                            ? GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5,
                                ),
                                itemCount: cropCategoryController
                                    .cropCategories.length,
                                itemBuilder: (context, index) {
                                  CropCategory currentCategory =
                                      cropCategoryController
                                          .cropCategories[index];
                                  return Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: kPrimaryGrey),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Constrained image to prevent overflow
                                        Expanded(
                                          child: Image.network(
                                            '$imgUrl${currentCategory.image}',
                                            fit: BoxFit.contain,
                                            errorBuilder: (context, error,
                                                    stackTrace) =>
                                                Icon(Icons
                                                    .error), // Fallback in case of an error
                                          ),
                                        ),
                                        SizedBox(
                                            height:
                                                5), // Space between image and text
                                        Text(
                                          '${currentCategory.name}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            : SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
