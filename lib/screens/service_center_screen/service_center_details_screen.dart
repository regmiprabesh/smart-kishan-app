import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/service_center_controller.dart';
import 'package:smart_kishan/models/service_center.dart';
import 'package:smart_kishan/helpers/l10n.dart';
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
    final lang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      body: Obx(() {
        final center = controller.selectedServiceCenter.value;

        if (center == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(l10n.serviceCenterNotFound),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: Text(l10n.goBack),
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
                  const SizedBox(height: 20),
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
        title: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Text(
            center.getLocalizedName(lang),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: const Offset(0, 1),
                  blurRadius: 3,
                  color: Colors.black.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
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
              const SizedBox(width: 12),
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
                    const SizedBox(height: 4),
                    Text(
                      center.getLocalizedName(lang),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.location_on, size: 18, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  center.getLocalizedAddress(lang),
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
          if (center.distance != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.navigation, size: 18, color: Colors.blue[600]),
                const SizedBox(width: 8),
                Text(
                  '${center.distance!.toStringAsFixed(1)} ${l10n.km} ${l10n.away}',
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
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
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
                localizedNumber(center.averageRating!.toStringAsFixed(1)),
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[700],
                ),
              ),
              const SizedBox(height: 4),
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
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (center.totalRatings != null)
                  Text(
                    '${localizedNumber(center.totalRatings!)} ${center.totalRatings == 1 ? l10n.ratingSingular : l10n.ratingPlural}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  l10n.basedOnUserReviews,
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
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              l10n.contactInformation,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          const Divider(height: 1),
          if (center.phone != null)
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.phone, color: Colors.green[600], size: 20),
              ),
              title: Text(center.phone!),
              subtitle: Text(l10n.phone),
              trailing: IconButton(
                icon: Icon(Icons.call, color: Colors.green[600]),
                onPressed: () => _launchPhone(center.phone!),
              ),
            ),
          if (center.email != null) ...[
            const Divider(height: 1, indent: 68),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.email, color: Colors.blue[600], size: 20),
              ),
              title: Text(center.email!),
              subtitle: Text(l10n.email),
              trailing: IconButton(
                icon: Icon(Icons.send, color: Colors.blue[600]),
                onPressed: () => _launchEmail(center.email!),
              ),
            ),
          ],
          if (center.website != null) ...[
            const Divider(height: 1, indent: 68),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    Icon(Icons.language, color: Colors.purple[600], size: 20),
              ),
              title: Text(center.website!),
              subtitle: Text(l10n.website),
              trailing: IconButton(
                icon: Icon(Icons.open_in_new, color: Colors.purple[600]),
                onPressed: () => _launchUrl(center.website!),
              ),
            ),
          ],
          if (center.contactPerson != null) ...[
            const Divider(height: 1, indent: 68),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.person, color: Colors.orange[600], size: 20),
              ),
              title: Text(center.contactPerson!),
              subtitle:
                  Text(center.contactPersonDesignation ?? l10n.contactPerson),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLocationSection(ServiceCenter center, String lang) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.location,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _openInMaps(center),
                  icon: const Icon(Icons.directions, size: 18),
                  label: Text(l10n.directions),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          SizedBox(
            height: 200,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(center.latitude, center.longitude),
                initialZoom: 15,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.smartKishan',
                  additionalOptions: const {},
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  center.getLocalizedAddress(lang),
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                if (center.wardNo != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    l10n.wardNo(localizedNumber(center.wardNo!)),
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
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              l10n.operatingHours,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          const Divider(height: 1),
          ...center.operatingHours!.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildServices(ServiceCenter center, String lang) {
    if (center.services == null || center.services!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              l10n.servicesOffered,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
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
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.about,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
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
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              localizedNumber(l10n.yourRating),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          const Divider(height: 1),
          if (isLoadingUserRating)
            const Padding(
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating display
          Container(
            padding: const EdgeInsets.all(16),
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
                    const SizedBox(width: 8),
                    Text(
                      '${localizedNumber(userRating!)}/${localizedNumber(5)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[700],
                      ),
                    ),
                  ],
                ),
                if (userReview != null && userReview!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    userReview!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Text(
                  l10n.youRatedThisCenter,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showEditRatingDialog(center),
                  icon: const Icon(Icons.edit, size: 18),
                  label: Text(l10n.editRating),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green[600],
                    side: BorderSide(color: Colors.green[600]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showDeleteRatingDialog(center),
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: Text(l10n.delete),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red[600],
                    side: BorderSide(color: Colors.red[600]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
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
                const SizedBox(height: 12),
                Text(
                  l10n.shareExperience,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.helpOthersRate,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showAddRatingDialog(center),
              icon: const Icon(Icons.rate_review),
              label: Text(l10n.addYourRating),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
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
            insetPadding: const EdgeInsets.symmetric(horizontal: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            title: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
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
                const SizedBox(height: 12),
                Text(
                  l10n.rateServiceCenter,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        l10n.localeName == 'ne' && center.nameNe != null
                            ? center.nameNe!
                            : center.name,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),

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
                      const SizedBox(height: 20),

                      // Review text field
                      Text(
                        l10n.writeReviewOptional,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        maxLines: 4,
                        maxLength: 500,
                        decoration: InputDecoration(
                          hintText: l10n.shareYourExperienceHint,
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
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  overlayColor: kPrimaryColor,
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  l10n.cancel,
                  style: const TextStyle(color: kPrimaryColor),
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
                child: Text(l10n.submit),
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
            insetPadding: const EdgeInsets.symmetric(horizontal: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            title: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
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
                const SizedBox(height: 12),
                Text(
                  l10n.editYourRating,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        l10n.localeName == 'ne' && center.nameNe != null
                            ? center.nameNe!
                            : center.name,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),

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
                      const SizedBox(height: 20),

                      // Review text field
                      Text(
                        l10n.writeReviewOptional,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        maxLines: 4,
                        maxLength: 500,
                        controller: TextEditingController(text: reviewText),
                        decoration: InputDecoration(
                          hintText: l10n.shareYourExperienceHint,
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
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  overlayColor: kPrimaryColor,
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  l10n.cancel,
                  style: const TextStyle(color: kPrimaryColor),
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
                child: Text(l10n.update),
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
              padding: const EdgeInsets.all(12),
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
            const SizedBox(height: 12),
            Text(
              l10n.deleteRatingQuestion,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
        content: Text(
          l10n.deleteRatingReviewConfirm,
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
              l10n.cancel,
              style: const TextStyle(color: kPrimaryColor),
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
                _showSnackBar(l10n.ratingDeleted);
              } else {
                _showSnackBar(l10n.ratingDeleteFailed, isError: true);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  Future<void> _submitRating(
      ServiceCenter center, int rating, String? review) async {
    final wasUpdate = userRating != null;
    final success = await controller.rateServiceCenter(
      center.id,
      rating,
      review: review?.isEmpty ?? true ? null : review,
    );

    if (success) {
      _showSnackBar(
          wasUpdate ? l10n.ratingUpdatedSuccess : l10n.ratingSubmittedSuccess);
      await _loadUserRating();
    } else {
      _showSnackBar(l10n.ratingFailed, isError: true);
    }
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return l10n.poor;
      case 2:
        return l10n.fair;
      case 3:
        return l10n.good;
      case 4:
        return l10n.veryGood;
      case 5:
        return l10n.excellent;
      default:
        return '';
    }
  }

  Widget _buildReviewsList(ServiceCenter center, String lang) {
    final reviews = center.ratings ?? [];

    if (reviews.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.recentReviews,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  '${localizedNumber(reviews.length)} ${reviews.length == 1 ? l10n.reviewSingular : l10n.reviewPlural}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: reviews.length > 5 ? 5 : reviews.length,
            separatorBuilder: (context, index) => const Divider(height: 24),
            itemBuilder: (context, index) {
              final review = reviews[index];
              return _buildReviewItem(review);
            },
          ),
          if (reviews.length > 5)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: TextButton(
                onPressed: () {
                  // TODO: Show all reviews in a new screen or bottom sheet
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green[600],
                ),
                child: Text(
                    l10n.viewAllReviews((localizedNumber(reviews.length)))),
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
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.user?.name ?? l10n.anonymous,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 2),
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
                      const SizedBox(width: 8),
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
          const SizedBox(height: 12),
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
          return '${localizedNumber(difference.inMinutes)} ${l10n.minUnit} ${l10n.ago}';
        }
        return '${localizedNumber(difference.inHours)} ${l10n.hrUnit} ${l10n.ago}';
      } else if (difference.inDays < 7) {
        final unit = difference.inDays == 1 ? l10n.dayUnit : l10n.daysUnit;
        return '${localizedNumber(difference.inDays)} $unit ${l10n.ago}';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        final unit = weeks == 1 ? l10n.weekUnit : l10n.weeksUnit;
        return '${localizedNumber(weeks)} $unit ${l10n.ago}';
      } else {
        return DateFormat('MMM d, yyyy', localeCode).format(date);
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
