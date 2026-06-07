import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/models/farmland.dart';
import 'package:smart_kishan/models/recommendedCrop.dart';
import 'package:smart_kishan/models/soildata.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class FarmlandDetailsScreen extends StatefulWidget {
  const FarmlandDetailsScreen({super.key, this.farmland});
  final Farmland? farmland;
  @override
  State<FarmlandDetailsScreen> createState() => _FarmlandDetailsScreenState();
}

class _FarmlandDetailsScreenState extends State<FarmlandDetailsScreen> {
  Farmland? farmland;
  bool? soilInfo;
  bool? locationInfo;
  Coordinates coordinates = Coordinates(lat: 27.650085, lng: 85.619474);
  RecommendedCropData? recommendedCropData;
  bool isLoading = true;

  @override
  void initState() {
    if (widget.farmland != null) {
      setState(() {
        farmland = widget.farmland;
      });
    }
    if (farmland!.nitrogen != null ||
        farmland!.potassium != null ||
        farmland!.organicMatter != null ||
        farmland!.phosphate != null ||
        farmland!.pH != null) {
      setState(() {
        soilInfo = true;
      });
    }
    if (farmland!.lat != null && farmland!.lng != null) {
      setState(() {
        locationInfo = true;
      });
      setState(() {
        coordinates = Coordinates(lat: farmland!.lat, lng: farmland!.lng);
      });
    }
    getRecommendedCrop();
    super.initState();
  }

  getRecommendedCrop() async {
    RecommendedCropData? cropData;
    cropData =
        await farmlandController.getRecommendedCrop(coordinate: coordinates);
    setState(() {
      recommendedCropData = cropData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        title: Text(farmland != null ? farmland!.title! : 'खेतबारी',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: farmland != null
          ? SingleChildScrollView(
              child: Column(
                children: [
                  // Hero Image Section
                  _buildHeroImage(),

                  // Content
                  Padding(
                    padding: EdgeInsets.all(getProportionateScreenWidth(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Description Card (if exists)
                        if (farmland!.description != null &&
                            farmland!.description!.isNotEmpty)
                          _buildDescriptionCard(),

                        if (farmland!.description != null &&
                            farmland!.description!.isNotEmpty)
                          SizedBox(height: getProportionateScreenWidth(16)),

                        // Location Info Card
                        if (locationInfo != null && locationInfo == true)
                          _buildLocationCard(),

                        if (locationInfo != null && locationInfo == true)
                          SizedBox(height: getProportionateScreenWidth(16)),

                        // Soil Properties Card
                        if (soilInfo != null && soilInfo == true)
                          _buildSoilPropertiesCard(),

                        if (soilInfo != null && soilInfo == true)
                          SizedBox(height: getProportionateScreenWidth(16)),

                        // Recommended Crops Card
                        _buildRecommendedCropsCard(),

                        SizedBox(height: getProportionateScreenWidth(24)),

                        // Update Button
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            foregroundColor: Colors.white,
                            minimumSize: Size(double.infinity,
                                getProportionateScreenWidth(48)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          icon: Icon(Icons.edit,
                              size: getProportionateScreenWidth(18)),
                          label: Text(
                            'अपडेट गर्नुहोस्',
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(15),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () async {
                            farmlandController.isEdit(true);
                            farmlandController.selectedFarmland(farmland);
                            if (farmland!.image != null) {
                              farmlandController
                                  .networkFarmlandImage(farmland!.image);
                            } else {
                              farmlandController.networkFarmlandImage.value =
                                  '';
                            }
                            Get.toNamed(AppRoute.addFarmlandScreen);
                          },
                        ),
                        SizedBox(height: getProportionateScreenWidth(24)),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: Text('Missing Farmland Information'),
            ),
    );
  }

  Widget _buildHeroImage() {
    return Container(
      width: double.infinity,
      height: getProportionateScreenHeight(250),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: farmland != null && farmland!.image != null
          ? CachedNetworkImage(
              imageUrl: '$imgUrl${farmland!.image!}',
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(color: kPrimaryColor),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade200,
                child: Icon(
                  Icons.image_not_supported,
                  size: getProportionateScreenWidth(60),
                  color: Colors.grey.shade400,
                ),
              ),
            )
          : Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/farmland.png'),
                ),
              ),
            ),
    );
  }

  Widget _buildDescriptionCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(getProportionateScreenWidth(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.description_outlined,
                  color: kPrimaryColor,
                  size: getProportionateScreenWidth(18),
                ),
              ),
              SizedBox(width: getProportionateScreenWidth(10)),
              Text(
                'विवरण',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: getProportionateScreenWidth(15),
                  color: Colors.grey.shade900,
                ),
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenWidth(12)),
          Text(
            farmland!.description!,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(13),
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(getProportionateScreenWidth(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.location_on,
                  color: Colors.blue.shade700,
                  size: getProportionateScreenWidth(18),
                ),
              ),
              SizedBox(width: getProportionateScreenWidth(10)),
              Text(
                'भौगोलिक स्थान',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: getProportionateScreenWidth(15),
                  color: Colors.grey.shade900,
                ),
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenWidth(16)),
          _buildInfoRow(
            icon: Icons.south,
            label: 'अक्षाश',
            value: convertToNepaliNumber(farmland!.lat.toString()),
            iconColor: Colors.blue.shade700,
          ),
          SizedBox(height: getProportionateScreenWidth(12)),
          _buildInfoRow(
            icon: Icons.east,
            label: 'देशान्तर',
            value: convertToNepaliNumber(farmland!.lng.toString()),
            iconColor: Colors.blue.shade700,
          ),
        ],
      ),
    );
  }

  Widget _buildSoilPropertiesCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(getProportionateScreenWidth(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                decoration: BoxDecoration(
                  color: Colors.brown.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.grass,
                  color: Colors.brown.shade700,
                  size: getProportionateScreenWidth(18),
                ),
              ),
              SizedBox(width: getProportionateScreenWidth(10)),
              Text(
                'माटोको विवरण',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: getProportionateScreenWidth(15),
                  color: Colors.grey.shade900,
                ),
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenWidth(16)),
          if (farmland!.nitrogen != null &&
              farmland!.nitrogen.toString() != 'null')
            _buildSoilProperty('नाइट्रोजन', farmland!.nitrogen.toString(), '%'),
          if (farmland!.organicMatter != null &&
              farmland!.organicMatter.toString() != 'null')
            _buildSoilProperty(
                'जैविक पदार्थ', farmland!.organicMatter.toString(), '%'),
          if (farmland!.phosphate != null &&
              farmland!.phosphate.toString() != 'null')
            _buildSoilProperty(
                'फास्फेट', farmland!.phosphate.toString(), 'किलोग्राम/हेक्टर'),
          if (farmland!.potassium != null &&
              farmland!.potassium.toString() != 'null')
            _buildSoilProperty('पोटासियम', farmland!.potassium.toString(), ''),
          if (farmland!.pH != null && farmland!.pH.toString() != 'null')
            _buildSoilProperty('पी.एच', farmland!.pH.toString(), '',
                isLast: true),
        ],
      ),
    );
  }

  Widget _buildRecommendedCropsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(getProportionateScreenWidth(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.agriculture,
                  color: Colors.green.shade700,
                  size: getProportionateScreenWidth(18),
                ),
              ),
              SizedBox(width: getProportionateScreenWidth(10)),
              Text(
                'सिफारिश गरिएका बाली',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: getProportionateScreenWidth(15),
                  color: Colors.grey.shade900,
                ),
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenWidth(16)),
          if (isLoading)
            Center(
              child: Padding(
                padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                child: CircularProgressIndicator(color: kPrimaryColor),
              ),
            )
          else if (recommendedCropData == null)
            Center(
              child: Padding(
                padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                child: Text(
                  'सिफारिश गरिएको बाली उपलब्ध छैन',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(12),
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vegetables Section
                if (recommendedCropData!.recommendedVegetable.isNotEmpty) ...[
                  Text(
                    AppLocalizations.of(context)!.recommendedVegetables,
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(14),
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: getProportionateScreenWidth(8)),
                  ...recommendedCropData!.recommendedVegetable
                      .map((vegetable) => _buildCropItem(
                            vegetable.vegetableName,
                            Colors.green.shade600,
                          )),
                  SizedBox(height: getProportionateScreenWidth(16)),
                ],

                // Fruits Section
                if (recommendedCropData!.recommendedFruits.isNotEmpty) ...[
                  Text(
                    AppLocalizations.of(context)!.recommendedFruit,
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(14),
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: getProportionateScreenWidth(8)),
                  ...recommendedCropData!.recommendedFruits
                      .map((fruit) => _buildCropItem(
                            fruit.fruitName,
                            Colors.orange.shade600,
                          )),
                ],
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: getProportionateScreenWidth(16), color: iconColor),
        SizedBox(width: getProportionateScreenWidth(8)),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(13),
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(13),
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade900,
          ),
        ),
      ],
    );
  }

  Widget _buildSoilProperty(String label, String value, String unit,
      {bool isLast = false}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: getProportionateScreenWidth(13),
                color: Colors.grey.shade700,
              ),
            ),
            Text(
              '${convertToNepaliNumber(value)} $unit',
              style: TextStyle(
                fontSize: getProportionateScreenWidth(13),
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade900,
              ),
            ),
          ],
        ),
        if (!isLast) SizedBox(height: getProportionateScreenWidth(12)),
      ],
    );
  }

  Widget _buildCropItem(String name, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: getProportionateScreenWidth(8)),
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(12),
        vertical: getProportionateScreenWidth(10),
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: getProportionateScreenWidth(6),
            height: getProportionateScreenWidth(6),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: getProportionateScreenWidth(10)),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: getProportionateScreenWidth(13),
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
