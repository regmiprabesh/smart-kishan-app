import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/controllers/subsidy_controller..dart';
import 'package:smart_kishan/helpers/l10n.dart';
import 'package:smart_kishan/helpers/nepali_date_helper.dart';
import 'package:smart_kishan/languages/langauge_constants.dart';
import 'package:smart_kishan/models/subsidy.dart';
import 'package:smart_kishan/routes/app_routes.dart';

class SubsidiesScreen extends StatefulWidget {
  const SubsidiesScreen({super.key});

  @override
  State<SubsidiesScreen> createState() => _SubsidiesScreenState();
}

class _SubsidiesScreenState extends State<SubsidiesScreen> {
  final SubsidyController subsidyController = Get.put(SubsidyController());

  @override
  void initState() {
    super.initState();
    _checkLocationAndLoadSubsidies();
  }

  // Add this method to handle navigation results
  void _navigateToUpdateLocation() async {
    final result = await Get.toNamed(AppRoute.updateLocationScreen);

    // If location was updated successfully, reload subsidies
    if (result == true) {
      setState(() {
        // Trigger rebuild
      });
      _checkLocationAndLoadSubsidies();
    }
  }

  void _checkLocationAndLoadSubsidies() {
    // Check if user has location information
    if (!_hasUserLocation()) {
      // Don't load subsidies if location is missing
      return;
    }
    subsidyController.getSubsidies();
  }

  bool _hasUserLocation() {
    final user = authController.user.value;
    if (user == null) return false;

    // Check if user has all required location fields
    return user.provinceId != null &&
        user.districtId != null &&
        user.municipalityId != null &&
        user.wardId != null;
  }

  String _getCategoryName(String? type) {
    if (type == null) return translation(context).general;

    switch (type.toLowerCase()) {
      case 'fertilizer':
        return translation(context).fertilizer;
      case 'equipment':
        return translation(context).equipment;
      case 'training':
        return translation(context).training;
      case 'irrigation':
        return translation(context).irrigation;
      case 'livestock':
        return translation(context).livestock;
      case 'seeds':
        return translation(context).seeds;
      case 'insurance':
        return translation(context).insurance;
      case 'loan':
        return translation(context).loan;
      case 'organic':
        return translation(context).organic;
      default:
        return translation(context).general;
    }
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
          t.subsidies,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[600],
        elevation: 0,
        actions: [
          if (_hasUserLocation())
            IconButton(
              icon: Icon(Icons.history),
              onPressed: () {
                Get.toNamed(AppRoute.mySubsidyApplicationsScreen);
              },
            ),
        ],
      ),
      body: !_hasUserLocation()
          ? _buildLocationRequiredView(t)
          : Obx(
              () => subsidyController.isSubsidiesLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : _buildSubsidyList(lang),
            ),
      floatingActionButton: _hasUserLocation()
          ? FloatingActionButton.extended(
              onPressed: () => Get.toNamed(AppRoute.mySubsidyRequestsScreen),
              backgroundColor: Colors.green[600],
              icon: Icon(Icons.add),
              label: Text(t.requestSubsidy),
            )
          : null,

      // floatingActionButton: _hasUserLocation()
      //     ? FloatingActionButton.extended(
      //         onPressed: () => _showRequestSubsidyDialog(context),
      //         backgroundColor: Colors.green[600],
      //         icon: Icon(Icons.add),
      //         label: Text(t.requestSubsidy),
      //       )
      //     : null,
    );
  }

  Widget _buildLocationRequiredView(dynamic t) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              padding: EdgeInsets.all(40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green[100]!, Colors.green[50]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on_outlined,
                size: 100,
                color: Colors.green[700],
              ),
            ),
            SizedBox(height: 32),

            // Title
            Text(
              t.locationRequired,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),

            // Description
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange[200]!, width: 1.5),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Colors.orange[700],
                    size: 32,
                  ),
                  SizedBox(height: 12),
                  Text(
                    t.locationRequiredDescription,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.orange[900],
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Why is location needed
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue[200]!, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.help_outline_rounded,
                          color: Colors.blue[700], size: 24),
                      SizedBox(width: 10),
                      Text(
                        t.whyLocationNeeded,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  _buildReasonItem(
                    Icons.check_circle_outline,
                    t.locationReason1,
                  ),
                  SizedBox(height: 8),
                  _buildReasonItem(
                    Icons.check_circle_outline,
                    t.locationReason2,
                  ),
                  SizedBox(height: 8),
                  _buildReasonItem(
                    Icons.check_circle_outline,
                    t.locationReason3,
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),

            // Action button - UPDATED to use the new navigation method
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _navigateToUpdateLocation, // Use new method
                icon: Icon(Icons.edit_location_alt, size: 22),
                label: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    t.addLocation,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shadowColor: Colors.green[600]!.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReasonItem(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blue[700], size: 20),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue[800],
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubsidyList(String lang) {
    final t = translation(context);
    final allSubsidies = subsidyController.subsidies;

    if (allSubsidies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.card_giftcard, size: 80, color: Colors.grey[400]),
            SizedBox(height: 20),
            Text(
              t.noSubsidies,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => subsidyController.getSubsidies(),
              icon: Icon(Icons.refresh),
              label: Text(t.refresh),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await subsidyController.getSubsidies();
      },
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: allSubsidies.length,
        itemBuilder: (context, index) {
          return SubsidyCard(
            subsidy: allSubsidies[index],
            lang: lang,
            getCategoryName: _getCategoryName,
          );
        },
      ),
    );
  }

  void _showRequestSubsidyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => RequestSubsidyDialog(),
    );
  }
}

class SubsidyCard extends StatefulWidget {
  final Subsidy subsidy;
  final String lang;
  final String Function(String?) getCategoryName;

  const SubsidyCard({
    Key? key,
    required this.subsidy,
    required this.lang,
    required this.getCategoryName,
  }) : super(key: key);

  @override
  _SubsidyCardState createState() => _SubsidyCardState();
}

class _SubsidyCardState extends State<SubsidyCard> {
  bool isExpanded = false;
  double rating = 0;
  int totalRatings = 0;

  String _formatDate(String? rawDate, String localeName) {
    if (rawDate == null || rawDate.isEmpty) return '';
    final dt = DateTime.tryParse(rawDate);
    if (dt == null) return rawDate;
    return DateFormat('EEEE, dd MMMM, yyyy', localeName).format(dt);
  }

  String getDeadlineText() {
    final t = translation(context);
    final lang = widget.lang;
    final raw = widget.subsidy.deadline;

    if (raw == null || raw.isEmpty) return t.noDeadline;

    if (lang == 'ne') {
      final bsRaw = widget.subsidy.deadlineNepali;
      if (bsRaw != null && bsRaw.isNotEmpty) {
        return NepaliDateHelper.formatNepaliDate(bsRaw);
      }
      // No BS date — show the AD date with Nepali Unicode digits.
      return convertToNepaliNumber(_formatDate(raw, 'ne'));
    }

    return _formatDate(raw, lang);
  }

  bool isDeadlinePassed() {
    if (widget.subsidy.deadline == null) return false;
    try {
      final deadline = DateTime.parse(widget.subsidy.deadline!);
      return deadline.isBefore(DateTime.now());
    } catch (e) {
      return false;
    }
  }

  String _getLocationInNepali(String? level) {
    if (level == null) return '';
    final t = translation(context);

    switch (level.toLowerCase()) {
      case 'central':
        return t.central;
      case 'province':
        return t.provinceLevel;
      case 'district':
        return t.districtLevel;
      case 'municipality':
        return t.municipalityLevel;
      case 'ward':
        return t.wardLevel;
      default:
        return level;
    }
  }

  @override
  Widget build(BuildContext context) {
    final subsidyController = Get.find<SubsidyController>();
    final lang = widget.lang;
    final t = translation(context);
    // Get actual rating data from subsidy
    final double rating = widget.subsidy.averageRating ?? 0.0;
    final int totalRatings = widget.subsidy.totalRatings ?? 0;
    final bool hasUserRated = widget.subsidy.userRating != null;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () {
            subsidyController.selectedSubsidy.value = widget.subsidy;
            Get.toNamed(AppRoute.subsidyDetailsScreen);
          },
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and status
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green[400]!, Colors.green[600]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.subsidy.title?.get(lang) ?? t.untitled,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              widget
                                  .getCategoryName(widget.subsidy.subsidyType),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: widget.subsidy.hasApplied == true
                            ? Colors.orange
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.subsidy.hasApplied == true
                            ? t.applied
                            : t.active,
                        style: TextStyle(
                          color: widget.subsidy.hasApplied == true
                              ? Colors.white
                              : Colors.green[600],
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
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
                    // Amount and Rating Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (widget.subsidy.budgetPerBeneficiary != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green[200]!),
                            ),
                            child: Text(
                              '${l10n.currencySymbol} ${localizedNumber(widget.subsidy.budgetPerBeneficiary.toString())}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                          ),
                        GestureDetector(
                          onTap: () => _showRatingDialog(context),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
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
                                  localizedNumber(rating.toStringAsFixed(1)),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber[700],
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '(${localizedNumber(totalRatings)})',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 12),

                    // Description
                    if (widget.subsidy.description != null)
                      Text(
                        widget.subsidy.description!.get(lang),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.4,
                        ),
                      ),

                    SizedBox(height: 12),

                    // Deadline
                    if (widget.subsidy.deadline != null)
                      Row(
                        children: [
                          Icon(Icons.schedule,
                              size: 16,
                              color: isDeadlinePassed()
                                  ? Colors.red
                                  : Colors.orange),
                          SizedBox(width: 4),
                          Text(
                            isDeadlinePassed()
                                ? t.expired
                                : '${t.deadline}: ${getDeadlineText()}',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDeadlinePassed()
                                  ? Colors.red[700]
                                  : Colors.orange[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                    // Expandable section
                    AnimatedCrossFade(
                      firstChild: Container(),
                      secondChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 12),
                          Divider(),
                          SizedBox(height: 8),
                          Text(
                            '${t.eligibility}:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            widget.subsidy.eligibilityCriteria?.get(lang) ??
                                t.noInfo,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                          if (widget.subsidy.targetCropOrSector != null) ...[
                            SizedBox(height: 8),
                            Text(
                              '${t.targetSector}:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              widget.subsidy.targetCropOrSector!.get(lang),
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                          if (widget.subsidy.locationLevel != null) ...[
                            SizedBox(height: 8),
                            Text(
                              '${t.locationLevel}:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              _getLocationInNepali(
                                  widget.subsidy.locationLevel),
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ],
                      ),
                      crossFadeState: isExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: Duration(milliseconds: 300),
                    ),

                    SizedBox(height: 16),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: (widget.subsidy.hasApplied == true ||
                                    isDeadlinePassed())
                                ? null
                                : () {
                                    subsidyController.selectedSubsidy.value =
                                        widget.subsidy;
                                    Get.toNamed(AppRoute.applySubsidyScreen);
                                  },
                            icon: Icon(Icons.assignment),
                            label: Text(
                              widget.subsidy.hasApplied == true
                                  ? t.applyNow
                                  : t.applyNow,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[600],
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () => _showRatingDialog(context),
                          icon: Icon(Icons.star_rate),
                          label: Text(
                            t.rate,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber[600],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          icon: Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more,
                          ),
                          label: Text(
                            isExpanded ? t.less : t.more,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green[600],
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
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

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          RatingDialog(subsidy: widget.subsidy, lang: widget.lang),
    );
  }
}
// Rating Dialog and Request Dialog classes - I'll provide in next message

class RatingDialog extends StatefulWidget {
  final Subsidy subsidy;
  final String lang;

  const RatingDialog({Key? key, required this.subsidy, required this.lang})
      : super(key: key);

  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog>
    with SingleTickerProviderStateMixin {
  int selectedRating = 0;
  final TextEditingController commentController = TextEditingController();
  bool isLoading = true;
  bool isSubmitting = false;
  Map<String, dynamic>? existingRating;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    _loadExistingRating();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingRating() async {
    final subsidyController = Get.find<SubsidyController>();
    final rating = await subsidyController.getUserRating(widget.subsidy.id!);

    if (mounted) {
      setState(() {
        existingRating = rating;
        if (rating != null) {
          selectedRating = rating['rating'] ?? 0;
          commentController.text = rating['review'] ?? '';
        }
        isLoading = false;
      });
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = translation(context);
    final lang = widget.lang;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
          horizontal: 16, vertical: 24), // Added for better width control
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 600, // Increased from 500
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        width: double.infinity, // Take full available width
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 30,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: isLoading
            ? _buildLoadingState()
            : ScaleTransition(
                scale: _scaleAnimation,
                child: _buildRatingContent(t, lang),
              ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: EdgeInsets.all(60),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.amber[600]!),
            strokeWidth: 3,
          ),
          SizedBox(height: 20),
          Text(
            'Loading...',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingContent(dynamic t, String lang) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(t, lang),
        Flexible(
          child: SingleChildScrollView(
            child: _buildBody(t, lang),
          ),
        ),
        _buildFooter(t),
      ],
    );
  }

  Widget _buildHeader(dynamic t, String lang) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 20, 24, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber[400]!, Colors.amber[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.star_rounded,
              size: 28,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  existingRating != null ? t.updateReview : t.rateReview,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  widget.subsidy.title?.get(lang) ?? t.untitled,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Delete button in header (only show if user has rated)
          if (existingRating != null) ...[
            SizedBox(width: 12),
            IconButton(
              onPressed: isSubmitting ? null : () => _showDeleteConfirmation(),
              icon: Icon(
                Icons.delete_outline_rounded,
                color: Colors.white,
                size: 24,
              ),
              tooltip: t.deleteRating ?? 'Delete Rating',
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                padding: EdgeInsets.all(10),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBody(dynamic t, String lang) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating Section
          Center(
            child: Column(
              children: [
                Text(
                  t.rateSubsidy,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 16),
                _buildStarRating(),
                if (selectedRating > 0) ...[
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.amber[100]!,
                          Colors.amber[50]!,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.amber[300]!,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.sentiment_satisfied_alt_rounded,
                          color: Colors.amber[700],
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          _getRatingText(selectedRating),
                          style: TextStyle(
                            color: Colors.amber[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: 28),

          // Review Section
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green[50]!,
                        Colors.white,
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
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green[600],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.edit_note_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          t.shareExperience,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[900],
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        '${commentController.text.length}/500',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: commentController,
                        enabled: !isSubmitting,
                        decoration: InputDecoration(
                          hintText: t.tellOtherFarmers,
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        maxLines: 5,
                        maxLength: 500,
                        style: TextStyle(fontSize: 14, height: 1.5),
                        onChanged: (value) {
                          setState(() {}); // Update character count
                        },
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue[100]!,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline_rounded,
                              color: Colors.blue[700],
                              size: 18,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                t.tipMention,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[800],
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // Info Banner
          Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.amber[50]!,
                  Colors.orange[50]!,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.amber[200]!,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: Colors.amber[700],
                  size: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    t.reviewHelps,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.amber[900],
                      height: 1.4,
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

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final isSelected = selectedRating > index;
        return GestureDetector(
          onTap: isSubmitting
              ? null
              : () {
                  setState(() {
                    selectedRating = index + 1;
                  });
                },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: EdgeInsets.all(6),
            child: Icon(
              isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
              color: isSelected ? Colors.amber[600] : Colors.grey[300],
              size: 44,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFooter(dynamic t) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: isSubmitting ? null : () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                side: BorderSide(color: Colors.grey[300]!, width: 1.5),
              ),
              child: Text(
                t.cancel,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: (selectedRating > 0 && !isSubmitting)
                  ? () => _submitRating()
                  : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.amber[600],
                disabledBackgroundColor: Colors.grey[300],
                elevation: 0,
                shadowColor: Colors.amber[600]!.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: isSubmitting
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.send_rounded, size: 18),
                        SizedBox(width: 8),
                        Text(
                          existingRating != null
                              ? t.updateReview
                              : t.submitReview,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  String _getRatingText(int rating) {
    final t = translation(context);
    switch (rating) {
      case 1:
        return t.poor;
      case 2:
        return t.fair;
      case 3:
        return t.good;
      case 4:
        return t.veryGood;
      case 5:
        return t.excellent;
      default:
        return '';
    }
  }

  void _showDeleteConfirmation() {
    final t = translation(context);

    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red[50]!,
                      Colors.red[100]!,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_forever_rounded,
                  color: Colors.red[600],
                  size: 56,
                ),
              ),
              SizedBox(height: 24),
              Text(
                t.confirmDelete ?? 'Confirm Delete',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                t.deleteRatingConfirm ??
                    'Are you sure you want to delete your rating?',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.orange[200]!,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange[700],
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.actionCannotBeUndone,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.orange[900],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        t.cancel,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close confirmation dialog
                        _deleteRating();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.red[600],
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        t.delete ?? 'Delete',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitRating() async {
    if (selectedRating == 0) return;

    setState(() {
      isSubmitting = true;
    });

    final t = translation(context);
    final subsidyController = Get.find<SubsidyController>();

    final success = await subsidyController.rateSubsidy(
      widget.subsidy.id!,
      selectedRating,
      review: commentController.text.trim().isEmpty
          ? null
          : commentController.text.trim(),
    );

    if (mounted) {
      setState(() {
        isSubmitting = false;
      });

      if (success) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check_circle_rounded,
                      color: Colors.white, size: 20),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        existingRating != null
                            ? t.reviewUpdated ?? 'Review Updated'
                            : t.reviewSubmitted,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        t.thankYou,
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green[600],
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: EdgeInsets.all(16),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    t.ratingFailed ?? 'Failed to submit rating',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  Future<void> _deleteRating() async {
    setState(() {
      isSubmitting = true;
    });

    final t = translation(context);
    final subsidyController = Get.find<SubsidyController>();
    final success = await subsidyController.deleteRating(widget.subsidy.id!);

    if (mounted) {
      setState(() {
        isSubmitting = false;
      });

      if (success) {
        Navigator.of(context).pop(); // Close main dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  t.ratingDeleted ?? 'Rating deleted successfully',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: EdgeInsets.all(16),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    t.ratingDeleteFailed ?? 'Failed to delete rating',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: EdgeInsets.all(16),
          ),
        );
      }
    }
  }
}

class RequestSubsidyDialog extends StatefulWidget {
  const RequestSubsidyDialog({Key? key}) : super(key: key);

  @override
  _RequestSubsidyDialogState createState() => _RequestSubsidyDialogState();
}

class _RequestSubsidyDialogState extends State<RequestSubsidyDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? selectedCategory;

  List<String> getCategories(BuildContext context) {
    final t = translation(context);
    return [
      t.general,
      t.insurance,
      t.organic,
      t.equipment,
      t.seeds,
      t.fertilizer,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final t = translation(context);
    final categories = getCategories(context);
    selectedCategory ??= categories[0];

    return AlertDialog(
      title: Text(t.requestNewSubsidy),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: t.subsidyTitle,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: InputDecoration(
                labelText: t.category,
                border: OutlineInputBorder(),
              ),
              items: categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue;
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: t.descriptionLabel,
                hintText: t.descriptionHint,
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(t.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            if (titleController.text.isNotEmpty &&
                descriptionController.text.isNotEmpty) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(t.subsidyRequestSubmitted),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green[600]),
          child: Text(t.submitRequest),
        ),
      ],
    );
  }
}
