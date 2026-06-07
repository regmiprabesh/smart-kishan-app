import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/survey_controller.dart';
import 'package:smart_kishan/languages/langauge_constants.dart';
import 'package:smart_kishan/models/survey.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:intl/intl.dart';

class SurveysListScreen extends StatefulWidget {
  const SurveysListScreen({super.key});

  @override
  State<SurveysListScreen> createState() => _SurveysListScreenState();
}

class _SurveysListScreenState extends State<SurveysListScreen>
    with SingleTickerProviderStateMixin {
  final SurveyController surveyController = Get.put(SurveyController());
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    surveyController.getAvailableSurveys();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getSurveyTypeIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'crop_production':
        return '🌾';
      case 'livestock_census':
        return '🐄';
      case 'land_usage':
        return '🗺️';
      case 'farmer_satisfaction':
        return '😊';
      case 'subsidy_impact':
        return '💰';
      case 'training_needs':
        return '📚';
      case 'market_access':
        return '🏪';
      default:
        return '📋';
    }
  }

  String _getSurveyTypeName(String? type) {
    switch (type?.toLowerCase()) {
      case 'crop_production':
        return 'Crop Production';
      case 'livestock_census':
        return 'Livestock Census';
      case 'land_usage':
        return 'Land Usage';
      case 'farmer_satisfaction':
        return 'Farmer Satisfaction';
      case 'subsidy_impact':
        return 'Subsidy Impact';
      case 'training_needs':
        return 'Training Needs';
      case 'market_access':
        return 'Market Access';
      default:
        return 'General Survey';
    }
  }

  Color _getSurveyTypeColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'crop_production':
        return Colors.green;
      case 'livestock_census':
        return Colors.brown;
      case 'land_usage':
        return Colors.blue;
      case 'farmer_satisfaction':
        return Colors.orange;
      case 'subsidy_impact':
        return Colors.purple;
      case 'training_needs':
        return Colors.indigo;
      case 'market_access':
        return Colors.teal;
      default:
        return Colors.grey;
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
        backgroundColor: kPrimaryColor,
        elevation: 0,
        title: Text(
          'Surveys',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
          tabs: [
            Tab(text: 'All'),
            Tab(text: 'Available'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: Obx(() {
        if (surveyController.isSurveysLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: kPrimaryColor),
          );
        }

        final allSurveys = surveyController.availableSurveys;
        final availableSurveys = surveyController.availableSurveys
            .where((s) => s.canRespond)
            .toList();
        final completedSurveys = surveyController.availableSurveys
            .where((s) =>
                s.hasResponded == true && s.allowMultipleSubmissions == false)
            .toList();

        return TabBarView(
          controller: _tabController,
          children: [
            _buildSurveysList(allSurveys, lang, t, 'all'),
            _buildSurveysList(availableSurveys, lang, t, 'available'),
            _buildSurveysList(completedSurveys, lang, t, 'completed'),
          ],
        );
      }),
    );
  }

  Widget _buildSurveysList(
      List<Survey> surveys, String lang, dynamic t, String listType) {
    if (surveys.isEmpty) {
      return _buildEmptyState(t, listType);
    }

    return RefreshIndicator(
      onRefresh: () => surveyController.getAvailableSurveys(),
      color: kPrimaryColor,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: surveys.length,
        itemBuilder: (context, index) {
          return _buildSurveyCard(surveys[index], lang, t);
        },
      ),
    );
  }

  Widget _buildSurveyCard(Survey survey, String lang, dynamic t) {
    final canRespond = survey.canRespond;
    final hasResponded = survey.hasResponded ?? false;
    final allowMultiple = survey.allowMultipleSubmissions ?? false;
    final isMandatory = survey.isMandatory ?? false;
    final typeColor = _getSurveyTypeColor(survey.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: isMandatory ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: canRespond
              ? () {
                  surveyController.selectedSurvey.value = survey;
                  Get.toNamed(AppRoute.takeSurveyScreen);
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: typeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getSurveyTypeIcon(survey.type),
                        style: TextStyle(fontSize: 28),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            survey.surveyCode ?? 'N/A',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            survey.title?.get(lang) ?? '',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Status/Badge
                    if (isMandatory && canRespond)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          'REQUIRED',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[700],
                          ),
                        ),
                      ),
                    if (hasResponded && !allowMultiple)
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green[700],
                          size: 20,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Description
                if (survey.description != null)
                  Text(
                    survey.description!.get(lang),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 12),

                // Info Chips Row
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildInfoChip(
                      Icons.category,
                      _getSurveyTypeName(survey.type),
                      typeColor,
                    ),
                    _buildInfoChip(
                      Icons.quiz,
                      '${survey.totalQuestions ?? 0} Questions',
                      Colors.blue,
                    ),
                    if (survey.estimatedDurationMinutes != null)
                      _buildInfoChip(
                        Icons.timer,
                        '~${survey.estimatedDurationMinutes} min',
                        Colors.orange,
                      ),
                    if (hasResponded && !allowMultiple)
                      _buildInfoChip(
                        Icons.check_circle,
                        'Completed',
                        Colors.green,
                      ),
                    if (hasResponded && allowMultiple)
                      _buildInfoChip(
                        Icons.replay,
                        'Responded ${survey.responseCount ?? 1}x',
                        Colors.purple,
                      ),
                    if (allowMultiple && canRespond)
                      _buildInfoChip(
                        Icons.refresh,
                        'Can Retake',
                        Colors.purple,
                      ),
                  ],
                ),

                // Footer Row
                if (survey.endDate != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.event,
                        size: 14,
                        color: Colors.orange[700],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Ends: ${_formatDate(survey.endDate)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ] else ...[
                  const SizedBox(height: 8),
                ],
                const SizedBox(height: 15),

                // Action Button - PROMINENT
                SizedBox(
                  height: 35,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: canRespond
                        ? () {
                            surveyController.selectedSurvey.value = survey;
                            Get.toNamed(AppRoute.takeSurveyScreen);
                          }
                        : null,
                    icon: Icon(
                      hasResponded
                          ? (allowMultiple
                              ? Icons.refresh_rounded
                              : Icons.check_circle_rounded)
                          : Icons.play_arrow_rounded,
                      size: 14,
                    ),
                    label: Text(
                      hasResponded
                          ? (allowMultiple ? 'Take Again' : 'Completed')
                          : 'Start Survey',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !canRespond
                          ? Colors.grey[400]
                          : hasResponded && allowMultiple
                              ? Colors.purple
                              : isMandatory
                                  ? Colors.red[600]
                                  : kPrimaryColor,
                      foregroundColor: Colors.white,
                      elevation: canRespond ? 4 : 0,
                      shadowColor: isMandatory
                          ? Colors.red.withOpacity(0.4)
                          : kPrimaryColor.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(dynamic t, String listType) {
    String title;
    String subtitle;
    IconData icon;

    switch (listType) {
      case 'available':
        title = 'No Available Surveys';
        subtitle = 'Check back later for new surveys';
        icon = Icons.assignment_outlined;
        break;
      case 'completed':
        title = 'No Completed Surveys';
        subtitle = 'Complete surveys to see them here';
        icon = Icons.check_circle_outline;
        break;
      default:
        title = 'No Surveys Available';
        subtitle = 'There are no surveys available for you at the moment';
        icon = Icons.assignment_outlined;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 80, color: Colors.grey[400]),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Pull down to refresh',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return 'N/A';
    }
  }
}
