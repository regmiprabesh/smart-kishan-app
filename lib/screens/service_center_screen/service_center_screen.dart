import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/controllers/service_center_controller.dart';
import 'package:smart_kishan/helpers/l10n.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
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
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              isSheetExpanded = true;
            });
            _fitMapToShowNearestCenter();
          }
        });
      }
    });

    // Listen to service centers loading completion
    ever(controller.isServiceCentersLoading, (isLoading) {
      if (!isLoading && mounted && showMapView) {
        // Once loading is complete, fit map to nearest center
        Future.delayed(const Duration(milliseconds: 300), () {
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
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _mapController.fitCamera(
          CameraFit.bounds(
            bounds: bounds,
            padding: const EdgeInsets.all(100),
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
              const Icon(Icons.info_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(l10n.currentLocationNotAvailable)),
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
    controller.clearRoute(); // Clear old route first

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

      Future.delayed(const Duration(milliseconds: 100), () {
        _mapController.fitCamera(
          CameraFit.bounds(
            bounds: bounds,
            padding: const EdgeInsets.all(180),
          ),
        );
      });
    }
  }

  List<ServiceCenter> _getTop5NearestCenters() {
    final centers = controller.serviceCenters.toList();

    switch (controller.sortBy.value) {
      case 'name':
        centers.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'rating':
        centers.sort(
            (a, b) => (b.averageRating ?? 0).compareTo(a.averageRating ?? 0));
        break;
      case 'newest':
        // already sorted from server, preserve order
        break;
      case 'distance':
      default:
        centers.removeWhere((c) => c.distance == null);
        centers.sort((a, b) => a.distance!.compareTo(b.distance!));
        break;
    }

    return centers.take(5).toList();
  }

  // Distance helpers (unit/words localized; numeric value stays Latin)
  String _distanceText(double? d) => d != null
      ? '${localizedNumber(d.toStringAsFixed(1))} ${l10n.km}'
      : l10n.notApplicable;

  String _distanceAway(double d) =>
      '${localizedNumber(d.toStringAsFixed(1))} ${l10n.km} ${l10n.away}';

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          l10n.serviceCenters,
          style: const TextStyle(fontWeight: FontWeight.bold),
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
                  Future.delayed(const Duration(milliseconds: 300), () {
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
            tooltip: showMapView ? l10n.listView : l10n.mapView,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context, lang),
            tooltip: l10n.filters,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndTypeFilter(lang),
          Expanded(
            child: showMapView ? _buildMapView(lang) : _buildListView(lang),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndTypeFilter(String lang) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: l10n.searchServiceCentersHint,
              prefixIcon: Icon(Icons.search, color: Colors.green[600]),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
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
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),

          const SizedBox(height: 12),

          // Type Filter Chips
          Obx(() {
            if (controller.types.isEmpty) return const SizedBox.shrink();

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
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(l10n.all),
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
                    padding: const EdgeInsets.only(right: 8),
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

  Widget _buildMapView(String lang) {
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
                  : const LatLng(27.7103, 85.3222),
              initialZoom: 18,
              minZoom: 5,
              maxZoom: 18,
              onTap: (_, __) {
                setState(() {
                  selectedMarkerCenter = null;
                  isSheetExpanded = true;
                });
                controller.clearRoute();
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.smartKishan',
                additionalOptions: const {},
              ),

              // Route Polyline (before markers so it appears below)
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
                              offset: const Offset(0, 2),
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
                        child: const Icon(Icons.person,
                            color: Colors.white, size: 20),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                      const SizedBox(width: 12),
                      Text(
                        l10n.loadingRoute,
                        style: const TextStyle(fontWeight: FontWeight.w600),
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
            _buildPersistentNearbySheet(lang),

          // Selected Center Card
          if (selectedMarkerCenter != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildSelectedCenterCard(selectedMarkerCenter!, lang),
            ),

          // Loading Indicator
          if (controller.isServiceCentersLoading.value)
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                      const SizedBox(width: 12),
                      Text(
                        l10n.loading,
                        style: const TextStyle(fontWeight: FontWeight.w600),
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

  Widget _buildPersistentNearbySheet(String lang) {
    final nearestCenters = _getTop5NearestCenters();

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.primaryDelta! > 10) {
            setState(() {
              isSheetExpanded = false;
            });
          } else if (details.primaryDelta! < -10) {
            setState(() {
              isSheetExpanded = true;
            });
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height:
              isSheetExpanded ? MediaQuery.of(context).size.height * 0.45 : 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    color: Colors.white,
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
                        const SizedBox(height: 12),
                        // Title - Centered
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.near_me,
                                color: Colors.green[600], size: 20),
                            const SizedBox(width: 8),
                            Text(
                              nearestCenters.isEmpty
                                  ? l10n.noServiceCentersFound
                                  : controller.sortBy.value == 'distance'
                                      ? l10n.nearestServiceCenters
                                      : controller.sortBy.value == 'rating'
                                          ? l10n.topRatedServiceCenters
                                          : controller.sortBy.value == 'name'
                                              ? l10n.serviceCenters
                                              : l10n.nearestServiceCenters,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            const Spacer(),
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
                  const Divider(height: 1),
                  if (nearestCenters.isEmpty)
                    Expanded(
                      child: SingleChildScrollView(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_off,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.noServiceCentersFound,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  l10n.tryAdjustingFilters,
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
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: nearestCenters.length,
                        separatorBuilder: (context, index) => const Divider(
                          height: 1,
                          indent: 68,
                          endIndent: 20,
                        ),
                        itemBuilder: (context, index) {
                          final center = nearestCenters[index];
                          return InkWell(
                            onTap: () => _moveToServiceCenter(center),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
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
                                      localizedNumber(index + 1),
                                      style: TextStyle(
                                        color: index == 0
                                            ? Colors.white
                                            : Colors.grey[700],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  // Icon
                                  Container(
                                    padding: const EdgeInsets.all(8),
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

                                  const SizedBox(width: 12),

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
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.navigation,
                                              size: 12,
                                              color: Colors.blue[600],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              _distanceText(center.distance),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.blue[700],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            if (center.averageRating != null &&
                                                center.averageRating! > 0) ...[
                                              const SizedBox(width: 12),
                                              const Icon(
                                                Icons.star,
                                                size: 12,
                                                color: Colors.amber,
                                              ),
                                              const SizedBox(width: 2),
                                              Text(
                                                localizedNumber(center
                                                    .averageRating!
                                                    .toStringAsFixed(1)),
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

  Widget _buildSelectedCenterCard(ServiceCenter center, String lang) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(12),
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
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  center.getLocalizedAddress(lang),
                  style: const TextStyle(fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (center.distance != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.navigation, size: 14, color: Colors.blue[600]),
                      const SizedBox(width: 4),
                      Text(
                        _distanceAway(center.distance!),
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
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.directions,
                            size: 16, color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        Text(
                          '${l10n.routeLoaded} • ${_distanceText(center.distance)}',
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
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  selectedMarkerCenter = null;
                  isSheetExpanded = true;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                if (center.averageRating != null &&
                    center.averageRating! > 0) ...[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          localizedNumber(
                              center.averageRating!.toStringAsFixed(1)),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[700],
                          ),
                        ),
                        if (center.totalRatings != null) ...[
                          const SizedBox(width: 4),
                          Text(
                            '(${localizedNumber(center.totalRatings!)})',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      controller.selectedServiceCenter.value = center;
                      Get.toNamed(AppRoute.serviceCenterDetailsScreen);
                    },
                    icon: const Icon(Icons.info_outline, size: 18),
                    label: Text(l10n.viewDetails),
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

  Widget _buildListView(String lang) {
    return Obx(() {
      if (controller.isServiceCentersLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final centers = controller.serviceCenters;

      if (centers.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_off, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 20),
              Text(
                l10n.noServiceCentersFound,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => controller.getServiceCenters(),
                icon: const Icon(Icons.refresh),
                label: Text(l10n.refresh),
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
          padding: const EdgeInsets.all(16),
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
    super.key,
    required this.center,
    required this.lang,
    this.onViewMap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ServiceCenterController>();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getTypeColor(center.type?.color).withOpacity(0.8),
                      _getTypeColor(center.type?.color),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
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
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            center.getLocalizedName(lang),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (center.type != null) ...[
                            const SizedBox(height: 4),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star,
                                size: 14, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              l10n.featured,
                              style: const TextStyle(
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Address
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on,
                            size: 18, color: Colors.grey[600]),
                        const SizedBox(width: 8),
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
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        if (center.distance != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
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
                                const SizedBox(width: 4),
                                Text(
                                  '${localizedNumber(center.distance!.toStringAsFixed(1))} ${l10n.km}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (center.averageRating != null &&
                            center.averageRating! > 0) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.amber[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  localizedNumber(
                                      center.averageRating!.toStringAsFixed(1)),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber[700],
                                    fontSize: 12,
                                  ),
                                ),
                                if (center.totalRatings != null) ...[
                                  const SizedBox(width: 4),
                                  Text(
                                    '(${localizedNumber(center.totalRatings!)})',
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
                      const SizedBox(height: 12),
                      if (center.phone != null)
                        Row(
                          children: [
                            Icon(Icons.phone,
                                size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 8),
                            Text(
                              center.phone!,
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      if (center.email != null) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.email,
                                size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 8),
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

                    const SizedBox(height: 16),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: onViewMap,
                            icon: const Icon(Icons.map, size: 18),
                            label: Text(l10n.viewOnMap),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.green[600],
                              side: BorderSide(color: Colors.green[600]!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              controller.selectedServiceCenter.value = center;
                              Get.toNamed(AppRoute.serviceCenterDetailsScreen);
                            },
                            icon: const Icon(Icons.info_outline, size: 18),
                            label: Text(l10n.details),
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

  const ServiceCenterFilterSheet({super.key, required this.lang});

  @override
  State<ServiceCenterFilterSheet> createState() =>
      _ServiceCenterFilterSheetState();
}

class _ServiceCenterFilterSheetState extends State<ServiceCenterFilterSheet> {
  final controller = Get.find<ServiceCenterController>();

  // Pending (uncommitted) values — only applied on "Apply Filters"
  late String _sortBy;
  late double _radius;
  late bool _featuredOnly;

  @override
  void initState() {
    super.initState();
    _sortBy = controller.sortBy.value;
    _radius = controller.searchRadius.value;
    _featuredOnly = controller.showFeaturedOnly.value;
  }

  void _applyFilters() {
    controller.setSortBy(_sortBy);
    controller.setSearchRadius(_radius);
    if (controller.showFeaturedOnly.value != _featuredOnly) {
      controller.toggleFeaturedOnly();
    }
    Navigator.pop(context);
  }

  Widget _sortChip(String label, String value) {
    final selected = _sortBy == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (s) {
        if (s) setState(() => _sortBy = value);
      },
      selectedColor: Colors.green[600],
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.grey[800],
        fontWeight: FontWeight.w600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
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
          const SizedBox(height: 20),

          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.filtersAndSort,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _sortBy = 'distance';
                    _radius = 599;
                    _featuredOnly = false;
                  });
                },
                child: Text(l10n.clearAll),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Sort By
          Text(
            l10n.sortBy,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              _sortChip(l10n.distance, 'distance'),
              _sortChip(l10n.name, 'name'),
              _sortChip(l10n.rating, 'rating'),
              _sortChip(l10n.newest, 'newest'),
            ],
          ),

          const SizedBox(height: 20),

          // Search Radius
          Text(
            l10n.searchRadius,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Slider(
            value: _radius,
            min: 5,
            max: 599,
            divisions: 19,
            activeColor: Colors.green[600],
            label: '${localizedNumber(_radius.toInt())} ${l10n.km}',
            onChanged: (value) => setState(() => _radius = value),
          ),
          Center(
            child: Text(
              '${localizedNumber(_radius.toInt())} ${l10n.km}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.green[700],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Featured Only
          SwitchListTile(
            title: Text(l10n.showFeaturedOnly),
            value: _featuredOnly,
            onChanged: (value) => setState(() => _featuredOnly = value),
            activeColor: Colors.green[600],
            contentPadding: EdgeInsets.zero,
          ),

          const SizedBox(height: 20),

          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                l10n.applyFilters,
                style: const TextStyle(
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
