import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/screens/farmland/farmland_details_screen.dart';
import 'package:smart_kishan/size_config.dart';

class FarmlandsScreen extends StatefulWidget {
  const FarmlandsScreen({super.key});
  @override
  State<FarmlandsScreen> createState() => _FarmlandsScreenState();
}

class _FarmlandsScreenState extends State<FarmlandsScreen> {
  @override
  void initState() {
    // farmlandController.getFarmlands();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        title: const Text(
          'खेतबारी',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          farmlandController.isEdit(false);
          farmlandController.selectedFarmlandImage.value = '';
          farmlandController.networkFarmlandImage.value = '';
          Get.toNamed(AppRoute.addFarmlandScreen);
        },
        backgroundColor: kPrimaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'नयाँ थप्नुहोस्',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: Obx(
        () => farmlandController.farmlands.isNotEmpty
            ? ListView.builder(
                padding: EdgeInsets.all(getProportionateScreenWidth(16)),
                itemCount: farmlandController.farmlands.length,
                itemBuilder: (context, index) {
                  final farmland = farmlandController.farmlands[index];
                  return _buildFarmlandCard(context, farmland, index);
                },
              )
            : _buildEmptyState(),
      ),
    );
  }

  Widget _buildFarmlandCard(context, farmland, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: getProportionateScreenWidth(16)),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            farmlandController.selectedFarmlandImage.value = '';
            farmlandController.networkFarmlandImage.value = '';
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FarmlandDetailsScreen(
                  farmland: farmland,
                ),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(getProportionateScreenWidth(12)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Farmland Image
                _buildFarmlandImage(farmland),
                SizedBox(width: getProportionateScreenWidth(12)),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        farmland.title ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: getProportionateScreenWidth(14),
                          color: Colors.grey.shade900,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: getProportionateScreenWidth(4)),

                      // Description
                      if (farmland.description != null &&
                          farmland.description!.isNotEmpty)
                        Text(
                          farmland.description!,
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(12),
                            color: Colors.grey.shade600,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                      // Added by info
                      if ((authController.user.value!.parentId == null ||
                              authController.user.value!.parentId == 0) &&
                          farmland.user != null &&
                          farmland.user!.name != null) ...[
                        SizedBox(height: getProportionateScreenWidth(6)),
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: getProportionateScreenWidth(12),
                              color: kPrimaryColor,
                            ),
                            SizedBox(width: getProportionateScreenWidth(4)),
                            Expanded(
                              child: Text(
                                'Added By: ${farmland.user!.name}',
                                style: TextStyle(
                                  fontSize: getProportionateScreenWidth(11),
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],

                      SizedBox(height: getProportionateScreenWidth(8)),

                      // Info chips
                      _buildInfoChips(farmland),
                    ],
                  ),
                ),

                // Delete button
                Material(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    splashColor: Colors.red.shade200,
                    highlightColor: Colors.red.shade100,
                    onTap: () => _showDeleteDialog(context, farmland.id!),
                    child: Padding(
                      padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                      child: Icon(
                        Icons.delete,
                        color: Colors.red.shade700,
                        size: getProportionateScreenWidth(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFarmlandImage(farmland) {
    return Container(
      width: getProportionateScreenWidth(80),
      height: getProportionateScreenWidth(80),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: farmland.image != null
            ? CachedNetworkImage(
                imageUrl: '$imgUrl${farmland.image!}',
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey.shade100,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: kPrimaryColor,
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey.shade100,
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.grey.shade400,
                    size: getProportionateScreenWidth(30),
                  ),
                ),
              )
            : Image.asset(
                'assets/images/farmland.png',
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget _buildInfoChips(farmland) {
    List<Map<String, dynamic>> chips = [];

    // Add location chip if available
    if (farmland.lat != null && farmland.lng != null) {
      chips.add({
        'icon': Icons.location_on,
        'label': 'स्थान',
        'color': Colors.blue,
      });
    }

    // Add soil info chip if available
    if (farmland.nitrogen != null ||
        farmland.phosphate != null ||
        farmland.pH != null) {
      chips.add({
        'icon': Icons.grass,
        'label': 'माटो',
        'color': Colors.brown,
      });
    }

    if (chips.isEmpty) return const SizedBox();

    return Wrap(
      spacing: getProportionateScreenWidth(6),
      children: chips.map((chip) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(8),
            vertical: getProportionateScreenWidth(4),
          ),
          decoration: BoxDecoration(
            color: (chip['color'] as Color).withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                chip['icon'] as IconData,
                size: getProportionateScreenWidth(12),
                color: chip['color'] as Color,
              ),
              SizedBox(width: getProportionateScreenWidth(4)),
              Text(
                chip['label'] as String,
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(10),
                  color: chip['color'] as Color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(getProportionateScreenWidth(24)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(24)),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.agriculture_outlined,
                size: getProportionateScreenWidth(60),
                color: kPrimaryColor,
              ),
            ),
            SizedBox(height: getProportionateScreenWidth(20)),
            Text(
              'तपाईंसँग हाल कुनै खेतबारी छैन !',
              style: TextStyle(
                fontSize: getProportionateScreenWidth(15),
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: getProportionateScreenWidth(8)),
            Text(
              'आफ्नो पहिलो खेतबारी थप्न तल बटन थिच्नुहोस्',
              style: TextStyle(
                fontSize: getProportionateScreenWidth(12),
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: getProportionateScreenWidth(24)),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(24),
                  vertical: getProportionateScreenWidth(12),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              onPressed: () {
                farmlandController.isEdit(false);
                farmlandController.selectedFarmlandImage.value = '';
                farmlandController.networkFarmlandImage.value = '';
                Get.toNamed(AppRoute.addFarmlandScreen);
              },
              icon: const Icon(Icons.add_circle_outline),
              label: Text(
                'खेतबारी थप गर्नुहोस्',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(14),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, int farmlandId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red.shade700,
                  size: getProportionateScreenWidth(20),
                ),
              ),
              SizedBox(width: getProportionateScreenWidth(12)),
              Expanded(
                child: Text(
                  "मेटाउने पुष्टि गर्नुहोस्",
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            "तपाईं यो खेतबारी मेटाउन निश्चित हुनुहुन्छ? यो कार्य पूर्ववत गर्न सकिँदैन।",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(13),
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "रद्द गर्नुहोस्",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                farmlandController.deleteFarmland(farmlandId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                "मेटाउनुहोस्",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}
