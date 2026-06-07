import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/screens/crop_info/crop_info_screen.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class CropInfoListScreen extends StatefulWidget {
  const CropInfoListScreen({super.key});

  @override
  State<CropInfoListScreen> createState() => _CropInfoListScreenState();
}

class _CropInfoListScreenState extends State<CropInfoListScreen> {
  TextEditingController _searchController = TextEditingController();
  var filteredCropInfo = [].obs; // Create an observable list for filtered crops

  @override
  void initState() {
    super.initState();
    // Initialize filteredCropInfo with all crop data initially
    filteredCropInfo.value = cropInfoController.cropInfo;

    // Add a listener to the search controller
    _searchController.addListener(_filterCrops);
  }

  @override
  void dispose() {
    _searchController
        .dispose(); // Dispose controller when the screen is disposed
    super.dispose();
  }

  void _filterCrops() {
    String query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      filteredCropInfo.value = cropInfoController.cropInfo;
    } else {
      filteredCropInfo.value = cropInfoController.cropInfo
          .where((crop) =>
              crop.name!.toLowerCase().contains(query) ||
              crop.name_en!.toLowerCase().contains(query))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.crops),
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(color: kPrimaryColor),
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
            child: TextFormField(
              controller: _searchController, // Attach the search controller
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal:
                        20.0), // Adjust vertical padding to decrease height
                hintText: AppLocalizations.of(context)!.search,
                filled: true, // Ensure fillColor is applied
                fillColor: Colors.white, // Background color of the text field
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear(); // Clear search field
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: Obx(() => filteredCropInfo.isNotEmpty
                  ? GridView.builder(
                      itemCount: filteredCropInfo.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CropInfoScreen(
                                      cropInfo: filteredCropInfo[index]),
                                ));
                          },
                          child: Card(
                            elevation: 4.0,
                            child: GridTile(
                              footer: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Center(
                                  child: Text(
                                    filteredCropInfo[index].name!,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Spacer(),
                                  SizedBox(
                                    width: getProportionateScreenWidth(70),
                                    height: getProportionateScreenWidth(60),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          '$imgUrl${filteredCropInfo[index].image!}',
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Center(
                                        child: Icon(Icons.error),
                                      ),
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : const SizedBox()),
            ),
          ),
        ],
      ),
    );
  }
}
