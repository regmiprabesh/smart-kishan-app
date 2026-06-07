import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/service_center_controller.dart';
import 'package:smart_kishan/languages/langauge_constants.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/models/service_center.dart';

class ServiceCenterScreen extends StatefulWidget {
  const ServiceCenterScreen({super.key});

  @override
  State<ServiceCenterScreen> createState() => _ServiceCenterScreenState();
}

class _ServiceCenterScreenState extends State<ServiceCenterScreen> {
  final ServiceCenterController controller = Get.put(ServiceCenterController());
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  bool showMapView = true;
  ServiceCenter? selectedMarkerCenter;
  bool isSheetExpanded = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      controller.setSearchQuery(_searchController.text);
      // Auto-expand sheet on search
      if (_searchController.text.isNotEmpty) {
        setState(() {
          isSheetExpanded = true;
          selectedMarkerCenter = null;
        });
        controller.clearRoute();
        _zoomToNearestLocation();
      }
    });

    // Auto-expand sheet when map view loads AND fit to nearest center
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (showMapView && controller.currentPosition.value != null) {
        Future.delayed(Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              isSheetExpanded = true;
            });
            _fitMapToShowNearestCenter(); // Add this line
          }
        });
      }
    });

    // Listen to service centers loading completion
    ever(controller.isServiceCentersLoading, (isLoading) {
      if (!isLoading && mounted && showMapView) {
        // Once loading is complete, fit map to nearest center
        Future.delayed(Duration(milliseconds: 300), () {
          if (mounted) {
            _fitMapToShowNearestCenter();
          }
        });
      }
    });

    // Listen to filter changes
    ever(controller.selectedType, (_) {
      if (mounted && showMapView) {
        setState(() {
          selectedMarkerCenter = null;
        });
        controller.clearRoute();
        _zoomToNearestLocation();
      }
    });

    ever(controller.sortBy, (_) {
      if (mounted && showMapView) {
        setState(() {
          isSheetExpanded = true;
          selectedMarkerCenter = null;
        });
        controller.clearRoute();
        _zoomToNearestLocation();
      }
    });

    ever(controller.searchRadius, (_) {
      if (mounted && showMapView) {
        setState(() {
          isSheetExpanded = true;
          selectedMarkerCenter = null;
        });
        controller.clearRoute();
        _zoomToNearestLocation();
      }
    });

    ever(controller.showFeaturedOnly, (_) {
      if (mounted && showMapView) {
        setState(() {
          isSheetExpanded = true;
          selectedMarkerCenter = null;
        });
        controller.clearRoute();
        _zoomToNearestLocation();
      }
    });
  }

  void _fitMapToShowNearestCenter() {
    final currentPos = controller.currentPosition.value;
    final centers =
        controller.serviceCenters.where((c) => c.distance != null).toList();

    if (currentPos == null || centers.isEmpty) return;

    // Sort by distance and get nearest
    centers.sort((a, b) => a.distance!.compareTo(b.distance!));
    final nearest = centers.first;

    // Calculate bounds to include both user location and nearest center
    final bounds = LatLngBounds(
      LatLng(
        currentPos.latitude < nearest.latitude
            ? currentPos.latitude
            : nearest.latitude,
        currentPos.longitude < nearest.longitude
            ? currentPos.longitude
            : nearest.longitude,
      ),
      LatLng(
        currentPos.latitude > nearest.latitude
            ? currentPos.latitude
            : nearest.latitude,
        currentPos.longitude > nearest.longitude
            ? currentPos.longitude
            : nearest.longitude,
      ),
    );

    // Fit map to show both points with padding
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) {
        _mapController.fitCamera(
          CameraFit.bounds(
            bounds: bounds,
            padding: EdgeInsets.all(100), // Adjust padding as needed
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _moveToUserLocation() {
    if (controller.currentPosition.value != null) {
      _mapController.move(
        LatLng(
          controller.currentPosition.value!.latitude,
          controller.currentPosition.value!.longitude,
        ),
        15,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(child: Text('Current location not available')),
            ],
          ),
          backgroundColor: Colors.orange[700],
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _moveToServiceCenter(ServiceCenter center) async {
    controller.clearRoute(); // Add this to clear old route first

    _mapController.move(
      LatLng(center.latitude, center.longitude),
      16,
    );
    setState(() {
      selectedMarkerCenter = center;
      isSheetExpanded = false;
    });

    // Load new route
    await controller.getRouteToCenter(center);
  }

  void _zoomToNearestLocation() {
    final nearestCenters = _getTop5NearestCenters();
    if (nearestCenters.isNotEmpty && controller.currentPosition.value != null) {
      final currentPos = controller.currentPosition.value!;
      final nearest = nearestCenters.first;

      // Calculate bounds to include both user location and nearest center
      final bounds = LatLngBounds(
        LatLng(
          currentPos.latitude < nearest.latitude
              ? currentPos.latitude
              : nearest.latitude,
          currentPos.longitude < nearest.longitude
              ? currentPos.longitude
              : nearest.longitude,
        ),
        LatLng(
          currentPos.latitude > nearest.latitude
              ? currentPos.latitude
              : nearest.latitude,
          currentPos.longitude > nearest.longitude
              ? currentPos.longitude
              : nearest.longitude,
        ),
      );

      // Fit map to show both points with some padding
      Future.delayed(Duration(milliseconds: 100), () {
        _mapController.fitCamera(
          CameraFit.bounds(
            bounds: bounds,
            padding: EdgeInsets.all(180),
          ),
        );
      });
    }
  }

  List<ServiceCenter> _getTop5NearestCenters() {
    final centers =
        controller.serviceCenters.where((c) => c.distance != null).toList();
    centers.sort((a, b) => a.distance!.compareTo(b.distance!));
    return centers.take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final lang = locale.languageCode;
    final t = translation(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Service Centers",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[600],
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(showMapView ? Icons.list : Icons.map),
            onPressed: () {
              setState(() {
                showMapView = !showMapView;
                if (showMapView) {
                  // Expand sheet when switching to map view
                  Future.delayed(Duration(milliseconds: 300), () {
                    if (mounted) {
                      setState(() {
                        isSheetExpanded = true;
                      });
                    }
                  });
                }
              });
              controller.clearRoute();
            },
            tooltip: showMapView ? 'List View' : 'Map View',
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context, lang),
            tooltip: 'Filters',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndTypeFilter(lang, t),
          Expanded(
            child:
                showMapView ? _buildMapView(lang, t) : _buildListView(lang, t),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndTypeFilter(String lang, dynamic t) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search service centers...',
              prefixIcon: Icon(Icons.search, color: Colors.green[600]),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, size: 20),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),

          SizedBox(height: 12),

          // Type Filter Chips
          Obx(() {
            if (controller.types.isEmpty) return SizedBox.shrink();

            // Access selectedType here to make Obx track it
            final _ = controller.selectedType.value;

            return SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.types.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text('All'),
                        selected: controller.selectedType.value == null,
                        onSelected: (selected) {
                          if (selected) {
                            controller.setSelectedType(null);
                          }
                        },
                        selectedColor: Colors.green[600],
                        checkmarkColor: Colors.white,
                        labelStyle: TextStyle(
                          color: controller.selectedType.value == null
                              ? Colors.white
                              : Colors.grey[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }

                  final type = controller.types[index - 1];
                  final isSelected =
                      controller.selectedType.value?.id == type.id;

                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(
                        lang == 'ne' && type.nameNe != null
                            ? type.nameNe!
                            : type.name,
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        controller.setSelectedType(selected ? type : null);
                      },
                      selectedColor: Colors.green[600],
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                      avatar: type.icon != null
                          ? Icon(
                              _getIconData(type.icon!),
                              size: 18,
                              color:
                                  isSelected ? Colors.white : Colors.grey[600],
                            )
                          : null,
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMapView(String lang, dynamic t) {
    return Obx(() {
      final centers = controller.serviceCenters;
      final currentPos = controller.currentPosition.value;
      final routePoints = controller.routePoints;

      return Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: currentPos != null
                  ? LatLng(currentPos.latitude, currentPos.longitude)
                  : LatLng(27.7103, 85.3222),
              initialZoom: 18,
              minZoom: 5,
              maxZoom: 18,
              onTap: (_, __) {
                setState(() {
                  selectedMarkerCenter = null;
                  isSheetExpanded = true;
                });
                controller.clearRoute(); // Clear route on tap
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.smartKishan',
              ),

              // Route Polyline (add this BEFORE markers so it appears below)
              if (routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: routePoints,
                      color: Colors.blue,
                      strokeWidth: 4.0,
                      borderColor: Colors.white,
                      borderStrokeWidth: 2.0,
                    ),
                  ],
                ),

              // Service center markers
              MarkerLayer(
                markers: centers.map((center) {
                  final isSelected = selectedMarkerCenter?.id == center.id;

                  return Marker(
                    point: LatLng(center.latitude, center.longitude),
                    width: isSelected ? 50 : 40,
                    height: isSelected ? 50 : 40,
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          selectedMarkerCenter = center;
                          isSheetExpanded = false;
                        });
                        _mapController.move(
                          LatLng(center.latitude, center.longitude),
                          16,
                        );

                        // Get route to selected center
                        await controller.getRouteToCenter(center);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _getTypeColor(center.type?.color),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: isSelected ? 3 : 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: isSelected ? 8 : 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          _getIconData(center.type?.icon ?? 'location_on'),
                          color: Colors.white,
                          size: isSelected ? 28 : 22,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              // User location marker
              if (currentPos != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(currentPos.latitude, currentPos.longitude),
                      width: 40,
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[600],
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child:
                            Icon(Icons.person, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Route loading indicator
          if (controller.isLoadingRoute.value)
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.blue[600]),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Loading route...',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // My Location Button
          Positioned(
            bottom: selectedMarkerCenter != null ? 220 : 100,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'location',
              mini: true,
              backgroundColor: Colors.white,
              onPressed: _moveToUserLocation,
              child:
                  Icon(CupertinoIcons.location_fill, color: Colors.green[600]),
            ),
          ),
          // Persistent Bottom Sheet (Header always visible)
          if (currentPos != null && selectedMarkerCenter == null)
            _buildPersistentNearbySheet(lang, t),

          // Selected Center Card
          if (selectedMarkerCenter != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildSelectedCenterCard(selectedMarkerCenter!, lang, t),
            ),

          // Loading Indicator
          if (controller.isServiceCentersLoading.value)
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.green[600]),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Loading...',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildPersistentNearbySheet(String lang, dynamic t) {
    final nearestCenters = _getTop5NearestCenters();

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.primaryDelta! > 10) {
            // Dragged down - collapse
            setState(() {
              isSheetExpanded = false;
            });
          } else if (details.primaryDelta! < -10) {
            // Dragged up - expand
            setState(() {
              isSheetExpanded = true;
            });
          }
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height:
              isSheetExpanded ? MediaQuery.of(context).size.height * 0.45 : 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header (Always Visible)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isSheetExpanded = !isSheetExpanded;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        // Handle
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        SizedBox(height: 12),
                        // Title - Centered
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.near_me,
                                color: Colors.green[600], size: 20),
                            SizedBox(width: 8),
                            Text(
                              nearestCenters.isEmpty
                                  ? 'No Service Centers Found'
                                  : 'Nearest Service Centers',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Spacer(),
                            Icon(
                              isSheetExpanded
                                  ? Icons.keyboard_arrow_down
                                  : Icons.keyboard_arrow_up,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Expandable Content
                if (isSheetExpanded) ...[
                  Divider(height: 1),
                  if (nearestCenters.isEmpty)
                    Expanded(
                      child: SingleChildScrollView(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_off,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No service centers found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Try adjusting your filters or search',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        itemCount: nearestCenters.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          indent: 68,
                          endIndent: 20,
                        ),
                        itemBuilder: (context, index) {
                          final center = nearestCenters[index];
                          return InkWell(
                            onTap: () => _moveToServiceCenter(center),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  // Rank Badge
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: index == 0
                                          ? Colors.amber[600]
                                          : Colors.grey[300],
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        color: index == 0
                                            ? Colors.white
                                            : Colors.grey[700],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 12),

                                  // Icon
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: _getTypeColor(center.type?.color)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      _getIconData(
                                          center.type?.icon ?? 'location_on'),
                                      color: _getTypeColor(center.type?.color),
                                      size: 20,
                                    ),
                                  ),

                                  SizedBox(width: 12),

                                  // Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          center.getLocalizedName(lang),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: Colors.grey[800],
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.navigation,
                                              size: 12,
                                              color: Colors.blue[600],
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '${center.distance?.toStringAsFixed(1) ?? 'N/A'} km',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.blue[700],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            if (center.averageRating != null &&
                                                center.averageRating! > 0) ...[
                                              SizedBox(width: 12),
                                              Icon(
                                                Icons.star,
                                                size: 12,
                                                color: Colors.amber,
                                              ),
                                              SizedBox(width: 2),
                                              Text(
                                                center.averageRating!
                                                    .toStringAsFixed(1),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.amber[700],
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Arrow
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: Colors.grey[400],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedCenterCard(
      ServiceCenter center, String lang, dynamic t) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getTypeColor(center.type?.color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getIconData(center.type?.icon ?? 'location_on'),
                color: _getTypeColor(center.type?.color),
                size: 24,
              ),
            ),
            title: Text(
              center.getLocalizedName(lang),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(
                  center.getLocalizedAddress(lang),
                  style: TextStyle(fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (center.distance != null) ...[
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.navigation, size: 14, color: Colors.blue[600]),
                      SizedBox(width: 4),
                      Text(
                        '${center.distance!.toStringAsFixed(1)} km away',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
                if (controller.routePoints.isNotEmpty) ...[
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.directions,
                            size: 16, color: Colors.blue[700]),
                        SizedBox(width: 8),
                        Text(
                          'Route loaded • ${center.distance?.toStringAsFixed(1) ?? 'N/A'} km',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  selectedMarkerCenter = null;
                  isSheetExpanded = true;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                if (center.averageRating != null &&
                    center.averageRating! > 0) ...[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text(
                          center.averageRating!.toStringAsFixed(1),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[700],
                          ),
                        ),
                        if (center.totalRatings != null) ...[
                          SizedBox(width: 4),
                          Text(
                            '(${center.totalRatings})',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                ],
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      controller.selectedServiceCenter.value = center;
                      Get.toNamed(AppRoute.serviceCenterDetailsScreen);
                    },
                    icon: Icon(Icons.info_outline, size: 18),
                    label: Text('View Details'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(String lang, dynamic t) {
    return Obx(() {
      if (controller.isServiceCentersLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      final centers = controller.serviceCenters;

      if (centers.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_off, size: 80, color: Colors.grey[400]),
              SizedBox(height: 20),
              Text(
                'No service centers found',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => controller.getServiceCenters(),
                icon: Icon(Icons.refresh),
                label: Text(t.refresh ?? 'Refresh'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.getServiceCenters(),
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: centers.length,
          itemBuilder: (context, index) {
            return ServiceCenterCard(
              center: centers[index],
              lang: lang,
              onViewMap: () {
                setState(() {
                  showMapView = true;
                  selectedMarkerCenter = centers[index];
                  isSheetExpanded = false;
                });
                _moveToServiceCenter(centers[index]);
              },
            );
          },
        ),
      );
    });
  }

  void _showFilterSheet(BuildContext context, String lang) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ServiceCenterFilterSheet(lang: lang),
    );
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

// Service Center Card Widget
class ServiceCenterCard extends StatelessWidget {
  final ServiceCenter center;
  final String lang;
  final VoidCallback? onViewMap;

  const ServiceCenterCard({
    Key? key,
    required this.center,
    required this.lang,
    this.onViewMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ServiceCenterController>();
    final t = translation(context);

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () {
            controller.selectedServiceCenter.value = center;
            // Get.toNamed(AppRoute.serviceCenterDetailsScreen);
          },
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getTypeColor(center.type?.color).withOpacity(0.8),
                      _getTypeColor(center.type?.color),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getIconData(center.type?.icon ?? 'location_on'),
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            center.getLocalizedName(lang),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (center.type != null) ...[
                            SizedBox(height: 4),
                            Text(
                              lang == 'ne' && center.type!.nameNe != null
                                  ? center.type!.nameNe!
                                  : center.type!.name,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (center.isFeatured)
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, size: 14, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'Featured',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Address
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on,
                            size: 18, color: Colors.grey[600]),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            center.getLocalizedAddress(lang),
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                        ),
                      ],
                    ),

                    // Distance & Rating Row
                    SizedBox(height: 12),
                    Row(
                      children: [
                        if (center.distance != null) ...[
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.navigation,
                                    size: 14, color: Colors.blue[700]),
                                SizedBox(width: 4),
                                Text(
                                  '${center.distance!.toStringAsFixed(1)} km',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                        ],
                        if (center.averageRating != null &&
                            center.averageRating! > 0) ...[
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.amber[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  center.averageRating!.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber[700],
                                    fontSize: 12,
                                  ),
                                ),
                                if (center.totalRatings != null) ...[
                                  SizedBox(width: 4),
                                  Text(
                                    '(${center.totalRatings})',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),

                    // Phone & Email
                    if (center.phone != null || center.email != null) ...[
                      SizedBox(height: 12),
                      if (center.phone != null)
                        Row(
                          children: [
                            Icon(Icons.phone,
                                size: 16, color: Colors.grey[600]),
                            SizedBox(width: 8),
                            Text(
                              center.phone!,
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      if (center.email != null) ...[
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.email,
                                size: 16, color: Colors.grey[600]),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                center.email!,
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[700]),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],

                    SizedBox(height: 16),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: onViewMap,
                            icon: Icon(Icons.map, size: 18),
                            label: Text('View on Map'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.green[600],
                              side: BorderSide(color: Colors.green[600]!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              controller.selectedServiceCenter.value = center;
                              // Get.toNamed(AppRoute.serviceCenterDetailsScreen);
                            },
                            icon: Icon(Icons.info_outline, size: 18),
                            label: Text('Details'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[600],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

// Filter Sheet Widget
class ServiceCenterFilterSheet extends StatefulWidget {
  final String lang;

  const ServiceCenterFilterSheet({Key? key, required this.lang})
      : super(key: key);

  @override
  State<ServiceCenterFilterSheet> createState() =>
      _ServiceCenterFilterSheetState();
}

class _ServiceCenterFilterSheetState extends State<ServiceCenterFilterSheet> {
  final controller = Get.find<ServiceCenterController>();

  @override
  Widget build(BuildContext context) {
    final t = translation(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 20),

          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters & Sort',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  controller.clearFilters();
                },
                child: Text('Clear All'),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Sort By
          Text(
            'Sort By',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          Obx(() => Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: Text('Distance'),
                    selected: controller.sortBy.value == 'distance',
                    onSelected: (selected) {
                      if (selected) controller.setSortBy('distance');
                    },
                  ),
                  ChoiceChip(
                    label: Text('Name'),
                    selected: controller.sortBy.value == 'name',
                    onSelected: (selected) {
                      if (selected) controller.setSortBy('name');
                    },
                  ),
                  ChoiceChip(
                    label: Text('Rating'),
                    selected: controller.sortBy.value == 'rating',
                    onSelected: (selected) {
                      if (selected) controller.setSortBy('rating');
                    },
                  ),
                  ChoiceChip(
                    label: Text('Newest'),
                    selected: controller.sortBy.value == 'newest',
                    onSelected: (selected) {
                      if (selected) controller.setSortBy('newest');
                    },
                  ),
                ],
              )),

          SizedBox(height: 20),

          // Search Radius
          Text(
            'Search Radius',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          Obx(() => Column(
                children: [
                  Slider(
                    value: controller.searchRadius.value,
                    min: 5,
                    max: 100,
                    divisions: 19,
                    label: '${controller.searchRadius.value.toInt()} km',
                    onChanged: (value) {
                      controller.setSearchRadius(value);
                    },
                  ),
                  Text(
                    '${controller.searchRadius.value.toInt()} km',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              )),

          SizedBox(height: 20),

          // Featured Only
          Obx(() => SwitchListTile(
                title: Text('Show Featured Only'),
                value: controller.showFeaturedOnly.value,
                onChanged: (value) {
                  controller.toggleFeaturedOnly();
                },
                activeColor: Colors.green[600],
                contentPadding: EdgeInsets.zero,
              )),

          SizedBox(height: 20),

          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Apply Filters',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
