import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/service_center_controller.dart';
import 'package:smart_kishan/models/service_center.dart';
import 'package:smart_kishan/languages/langauge_constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';

class ServiceCenterDetailsScreen extends StatefulWidget {
  const ServiceCenterDetailsScreen({super.key});

  @override
  State<ServiceCenterDetailsScreen> createState() =>
      _ServiceCenterDetailsScreenState();
}

class _ServiceCenterDetailsScreenState
    extends State<ServiceCenterDetailsScreen> {
  final ServiceCenterController controller = Get.find();
  final MapController _mapController = MapController();

  int? userRating;
  String? userReview;
  bool isLoadingUserRating = true;

  @override
  void initState() {
    super.initState();
    _loadUserRating();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    if (controller.selectedServiceCenter.value != null) {
      await controller.getServiceCenterDetails(
        controller.selectedServiceCenter.value!.id,
      );
    }
  }

  Future<void> _loadUserRating() async {
    if (controller.selectedServiceCenter.value != null) {
      final rating = await controller.getUserRating(
        controller.selectedServiceCenter.value!.id,
      );
      if (mounted) {
        setState(() {
          userRating = rating?['rating'];
          userReview = rating?['review'];
          isLoadingUserRating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final lang = locale.languageCode;
    final t = translation(context);

    return Scaffold(
      body: Obx(() {
        final center = controller.selectedServiceCenter.value;

        if (center == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                SizedBox(height: 16),
                Text('Service center not found'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: Text('Go Back'),
                ),
              ],
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            _buildAppBar(center, lang),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderInfo(center, lang),
                  _buildRatingOverview(center, lang),
                  _buildContactInfo(center, lang),
                  _buildLocationSection(center, lang),
                  _buildOperatingHours(center, lang),
                  _buildServices(center, lang),
                  _buildDescription(center, lang),
                  _buildUserRatingSection(center, lang),
                  _buildReviewsList(center, lang),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildAppBar(ServiceCenter center, String lang) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: _getTypeColor(center.type?.color),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          center.getLocalizedName(lang),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                offset: Offset(0, 1),
                blurRadius: 3,
                color: Colors.black.withOpacity(0.5),
              ),
            ],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            // If images exist, show them, otherwise show a gradient
            if (center.images != null && center.images!.isNotEmpty)
              Image.network(
                center.images!.first,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildGradientBackground(center),
              )
            else
              _buildGradientBackground(center),

            // Overlay gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // actions: [
      //   if (center.isFeatured)
      //     Padding(
      //       padding: EdgeInsets.only(right: 8),
      //       child: Chip(
      //         label: Row(
      //           mainAxisSize: MainAxisSize.min,
      //           children: [
      //             Icon(Icons.star, size: 14, color: Colors.white),
      //             SizedBox(width: 4),
      //             Text(
      //               'Featured',
      //               style: TextStyle(
      //                 color: Colors.white,
      //                 fontSize: 11,
      //                 fontWeight: FontWeight.bold,
      //               ),
      //             ),
      //           ],
      //         ),
      //         backgroundColor: Colors.amber[600],
      //         padding: EdgeInsets.symmetric(horizontal: 8),
      //       ),
      //     ),
      // ],
    );
  }

  Widget _buildGradientBackground(ServiceCenter center) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getTypeColor(center.type?.color),
            _getTypeColor(center.type?.color).withOpacity(0.7),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          _getIconData(center.type?.icon ?? 'location_on'),
          size: 80,
          color: Colors.white.withOpacity(0.6),
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(ServiceCenter center, String lang) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getTypeColor(center.type?.color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconData(center.type?.icon ?? 'location_on'),
                  color: _getTypeColor(center.type?.color),
                  size: 28,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (center.type != null)
                      Text(
                        lang == 'ne' && center.type!.nameNe != null
                            ? center.type!.nameNe!
                            : center.type!.name,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    SizedBox(height: 4),
                    Text(
                      center.getLocalizedName(lang),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.location_on, size: 18, color: Colors.grey[600]),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  center.getLocalizedAddress(lang),
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
          if (center.distance != null) ...[
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.navigation, size: 18, color: Colors.blue[600]),
                SizedBox(width: 8),
                Text(
                  '${center.distance!.toStringAsFixed(1)} km away',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRatingOverview(ServiceCenter center, String lang) {
    if (center.averageRating == null || center.averageRating == 0) {
      return SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber[200]!),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                center.averageRating!.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[700],
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < center.averageRating!.round()
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  );
                }),
              ),
            ],
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (center.totalRatings != null)
                  Text(
                    '${center.totalRatings} ${center.totalRatings == 1 ? 'rating' : 'ratings'}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                SizedBox(height: 4),
                Text(
                  'Based on user reviews',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(ServiceCenter center, String lang) {
    if (center.phone == null &&
        center.email == null &&
        center.website == null) {
      return SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          Divider(height: 1),
          if (center.phone != null)
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.phone, color: Colors.green[600], size: 20),
              ),
              title: Text(center.phone!),
              subtitle: Text('Phone'),
              trailing: IconButton(
                icon: Icon(Icons.call, color: Colors.green[600]),
                onPressed: () => _launchPhone(center.phone!),
              ),
            ),
          if (center.email != null) ...[
            Divider(height: 1, indent: 68),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.email, color: Colors.blue[600], size: 20),
              ),
              title: Text(center.email!),
              subtitle: Text('Email'),
              trailing: IconButton(
                icon: Icon(Icons.send, color: Colors.blue[600]),
                onPressed: () => _launchEmail(center.email!),
              ),
            ),
          ],
          if (center.website != null) ...[
            Divider(height: 1, indent: 68),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    Icon(Icons.language, color: Colors.purple[600], size: 20),
              ),
              title: Text(center.website!),
              subtitle: Text('Website'),
              trailing: IconButton(
                icon: Icon(Icons.open_in_new, color: Colors.purple[600]),
                onPressed: () => _launchUrl(center.website!),
              ),
            ),
          ],
          if (center.contactPerson != null) ...[
            Divider(height: 1, indent: 68),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.person, color: Colors.orange[600], size: 20),
              ),
              title: Text(center.contactPerson!),
              subtitle:
                  Text(center.contactPersonDesignation ?? 'Contact Person'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLocationSection(ServiceCenter center, String lang) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _openInMaps(center),
                  icon: Icon(Icons.directions, size: 18),
                  label: Text('Directions'),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          Container(
            height: 200,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(center.latitude, center.longitude),
                initialZoom: 15,
                interactionOptions: InteractionOptions(
                  flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.smartKishan',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(center.latitude, center.longitude),
                      width: 40,
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _getTypeColor(center.type?.color),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: Icon(
                          _getIconData(center.type?.icon ?? 'location_on'),
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  center.getLocalizedAddress(lang),
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                if (center.wardNo != null) ...[
                  SizedBox(height: 4),
                  Text(
                    'Ward No: ${center.wardNo}',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperatingHours(ServiceCenter center, String lang) {
    if (center.operatingHours == null || center.operatingHours!.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Operating Hours',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          Divider(height: 1),
          ...center.operatingHours!.entries.map((entry) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _capitalize(entry.key),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    entry.value,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildServices(ServiceCenter center, String lang) {
    if (center.services == null || center.services!.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Services Offered',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: center.services!.map((service) {
                return Chip(
                  label: Text(service),
                  backgroundColor: Colors.green[50],
                  labelStyle: TextStyle(
                    color: Colors.green[700],
                    fontSize: 13,
                  ),
                  avatar: Icon(
                    Icons.check_circle,
                    color: Colors.green[600],
                    size: 18,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(ServiceCenter center, String lang) {
    final description = lang == 'ne' && center.descriptionNe != null
        ? center.descriptionNe
        : center.description;

    if (description == null || description.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserRatingSection(ServiceCenter center, String lang) {
    return Container(
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Your Rating',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          Divider(height: 1),
          if (isLoadingUserRating)
            Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (userRating != null)
            _buildExistingRating(center)
          else
            _buildNewRatingForm(center),
        ],
      ),
    );
  }

  Widget _buildExistingRating(ServiceCenter center) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating display
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ...List.generate(5, (index) {
                      return Icon(
                        index < userRating! ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 28,
                      );
                    }),
                    SizedBox(width: 8),
                    Text(
                      '$userRating/5',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[700],
                      ),
                    ),
                  ],
                ),
                if (userReview != null && userReview!.isNotEmpty) ...[
                  SizedBox(height: 12),
                  Text(
                    userReview!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
                SizedBox(height: 12),
                Text(
                  'You rated this service center',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showEditRatingDialog(center),
                  icon: Icon(Icons.edit, size: 18),
                  label: Text('Edit Rating'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green[600],
                    side: BorderSide(color: Colors.green[600]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showDeleteRatingDialog(center),
                  icon: Icon(Icons.delete_outline, size: 18),
                  label: Text('Delete'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red[600],
                    side: BorderSide(color: Colors.red[600]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNewRatingForm(ServiceCenter center) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.star_border,
                  size: 48,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 12),
                Text(
                  'Share Your Experience',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Help others by rating this service center',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showAddRatingDialog(center),
              icon: Icon(Icons.rate_review),
              label: Text('Add Your Rating'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddRatingDialog(ServiceCenter center) {
    int? selectedRating;
    String? reviewText;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            title: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.rate_review,
                    color: Colors.green[600],
                    size: 32,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Rate Service Center',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    center.name,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),

                  // Star rating
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          onPressed: () {
                            setDialogState(() {
                              selectedRating = index + 1;
                            });
                          },
                          icon: Icon(
                            index < (selectedRating ?? 0)
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 30,
                          ),
                        );
                      }),
                    ),
                  ),

                  if (selectedRating != null) ...[
                    Center(
                      child: Text(
                        _getRatingText(selectedRating!),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.amber[700],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Review text field
                    Text(
                      'Write a review (optional)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      maxLines: 4,
                      maxLength: 500,
                      decoration: InputDecoration(
                        hintText: 'Share your experience...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                        counterText: '',
                      ),
                      onChanged: (value) {
                        reviewText = value;
                      },
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  overlayColor: kPrimaryColor,
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: kPrimaryColor),
                ),
              ),
              ElevatedButton(
                onPressed: selectedRating == null
                    ? null
                    : () async {
                        Navigator.pop(context);
                        await _submitRating(
                          center,
                          selectedRating!,
                          reviewText,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  disabledBackgroundColor: Colors.grey[300],
                ),
                child: Text('Submit'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditRatingDialog(ServiceCenter center) {
    int? selectedRating = userRating;
    String? reviewText = userReview;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            title: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.edit,
                    color: Colors.amber[600],
                    size: 32,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Edit Your Rating',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    center.name,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),

                  // Star rating
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          onPressed: () {
                            setDialogState(() {
                              selectedRating = index + 1;
                            });
                          },
                          icon: Icon(
                            index < (selectedRating ?? 0)
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 30,
                          ),
                        );
                      }),
                    ),
                  ),

                  if (selectedRating != null) ...[
                    Center(
                      child: Text(
                        _getRatingText(selectedRating!),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.amber[700],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Review text field
                    Text(
                      'Write a review (optional)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      maxLines: 4,
                      maxLength: 500,
                      controller: TextEditingController(text: reviewText),
                      decoration: InputDecoration(
                        hintText: 'Share your experience...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                        counterText: '',
                      ),
                      onChanged: (value) {
                        reviewText = value;
                      },
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  overlayColor: kPrimaryColor,
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: kPrimaryColor),
                ),
              ),
              ElevatedButton(
                onPressed: selectedRating == null
                    ? null
                    : () async {
                        Navigator.pop(context);
                        await _submitRating(
                          center,
                          selectedRating!,
                          reviewText,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  disabledBackgroundColor: Colors.grey[300],
                ),
                child: Text('Update'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDeleteRatingDialog(ServiceCenter center) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        title: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_outline,
                color: Colors.red[600],
                size: 32,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Delete Rating?',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to delete your rating and review? This action cannot be undone.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[700]),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              overlayColor: kPrimaryColor,
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: kPrimaryColor),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await controller.deleteRating(center.id);
              if (success) {
                setState(() {
                  userRating = null;
                  userReview = null;
                });
                _showSnackBar('Rating deleted successfully!');
              } else {
                _showSnackBar('Failed to delete rating', isError: true);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitRating(
      ServiceCenter center, int rating, String? review) async {
    final success = await controller.rateServiceCenter(
      center.id,
      rating,
      review: review?.isEmpty ?? true ? null : review,
    );

    if (success) {
      _showSnackBar(
          'Rating ${userRating != null ? 'updated' : 'submitted'} successfully!');
      await _loadUserRating();
    } else {
      _showSnackBar('Failed to submit rating', isError: true);
    }
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }

  Widget _buildReviewsList(ServiceCenter center, String lang) {
    final reviews = center.ratings ?? [];

    if (reviews.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Reviews',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  '${reviews.length} ${reviews.length == 1 ? 'review' : 'reviews'}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(16),
            itemCount: reviews.length > 5 ? 5 : reviews.length,
            separatorBuilder: (context, index) => Divider(height: 24),
            itemBuilder: (context, index) {
              final review = reviews[index];
              return _buildReviewItem(review);
            },
          ),
          if (reviews.length > 5)
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: TextButton(
                onPressed: () {
                  // TODO: Show all reviews in a new screen or bottom sheet
                },
                child: Text('View all ${reviews.length} reviews'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green[600],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(ServiceCenterRating review) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.green[100],
              child: Text(
                review.user?.name.substring(0, 1).toUpperCase() ?? 'U',
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.user?.name ?? 'Anonymous',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        return Icon(
                          index < review.rating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 14,
                        );
                      }),
                      SizedBox(width: 8),
                      Text(
                        _formatDate(review.createdAt.toString()),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        if (review.review != null && review.review!.isNotEmpty) ...[
          SizedBox(height: 12),
          Text(
            review.review!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          return '${difference.inMinutes} min ago';
        }
        return '${difference.inHours} hr ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return '$weeks week${weeks > 1 ? 's' : ''} ago';
      } else {
        return DateFormat('MMM d, yyyy').format(date);
      }
    } catch (e) {
      return '';
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red[600] : Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _launchPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openInMaps(ServiceCenter center) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${center.latitude},${center.longitude}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Color _getTypeColor(String? colorHex) {
    if (colorHex == null) return Colors.green;
    try {
      return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.green;
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'agriculture':
        return Icons.agriculture;
      case 'science':
        return Icons.science;
      case 'store':
        return Icons.store;
      case 'medical_services':
        return Icons.medical_services;
      case 'school':
        return Icons.school;
      case 'water_drop':
        return Icons.water_drop;
      case 'business':
        return Icons.business;
      case 'grass':
        return Icons.grass;
      default:
        return Icons.location_on;
    }
  }
}
