import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/screens/dashboard/widgets/custom_drawer.dart';
import 'package:smart_kishan/screens/dashboard/widgets/weather_card.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Items item1 = Items(
      id: 1,
      title: AppLocalizations.of(context)!.dailyActivities,
      count: "210",
      img: "assets/images/daily_activity.png",
      route: AppRoute.dailyActivityScreen,
      color: 0xFF4099FF,
    );

    Items item2 = Items(
      id: 2,
      title: AppLocalizations.of(context)!.inventoryBroken,
      count: "15",
      route: AppRoute.productsScreen,
      img: "assets/images/inventory.png",
      color: 0xFF2ED8B6,
    );

    Items item3 = Items(
        id: 3,
        title: AppLocalizations.of(context)!.sales,
        count: "7",
        route: AppRoute.incomeScreen,
        img: "assets/images/sales.png",
        color: 0xFFFF5370);
    Items item4 = Items(
        id: 4,
        title: AppLocalizations.of(context)!.expenses,
        count: "4",
        route: AppRoute.expenseScreen,
        img: "assets/images/expenses.png",
        color: 0xFFFFB64D);
    Items item5 = Items(
        id: 5,
        title: AppLocalizations.of(context)!.farmlands,
        count: "0",
        route: AppRoute.farmlandScreen,
        img: "assets/images/farmland.png",
        color: 0xFFFF5370);
    Items item6 = Items(
      id: 6,
      title: AppLocalizations.of(context)!.kalimatiPrice,
      route: AppRoute.kalimatiPriceScreen,
      img: "assets/images/price_list.png",
      color: 0xFF2ED8B6,
    );
    List<Items> myList = [item1, item2, item3, item4, item5, item6];
    if (authController.user.value!.parentId != null &&
        authController.user.value!.parentId != 0) {
      myList.removeAt(1);
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          elevation: 0,
          backgroundColor: kPrimaryColor,
          centerTitle: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  kPrimaryColor,
                  kPrimaryColor.withOpacity(0.85),
                ],
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.welcomeBack,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.85),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  authController.user.value != null
                      ? authController.user.value!.name!
                      : 'Bikash Lamichane',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                )
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0, top: 8.0),
              child: Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    CupertinoIcons.person_fill,
                    size: 22,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // Add profile navigation
                  },
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        heroTag: "home_fab",
        onPressed: () => Get.toNamed(AppRoute.chatbotScreen),
        child: const Icon(CupertinoIcons.chat_bubble_text, color: Colors.white),
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Green Background Section with Weather Card Overlay
            Stack(
              children: [
                // Extended Green Background with Curve
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        kPrimaryColor,
                        kPrimaryColor.withOpacity(0.9),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                  ),
                ),
                // Weather Card Overlapping the Green Background
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: const WeatherCard(),
                ),
              ],
            ),

            // Main Content Section
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. NOTES SECTION (FIRST - Most Important)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Container(
                          height: 24,
                          width: 4,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.notes,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              Get.toNamed(AppRoute.notesScreen);
                            },
                            icon: const Icon(
                              CupertinoIcons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Notes Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Obx(
                          () => noteController.notes.isNotEmpty
                              ? ListView.separated(
                                  itemCount: noteController.notes.length > 2
                                      ? 2
                                      : noteController.notes.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  separatorBuilder: (context, index) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Divider(
                                      color: Colors.grey[200],
                                      height: 1,
                                    ),
                                  ),
                                  itemBuilder: (context, index) {
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(top: 2),
                                          height: 8,
                                          width: 8,
                                          decoration: BoxDecoration(
                                            color: kPrimaryColor,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                noteController
                                                    .notes[index].title!,
                                                style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              if (noteController.notes[index]
                                                      .description !=
                                                  null) ...[
                                                const SizedBox(height: 4),
                                                Text(
                                                  noteController.notes[index]
                                                      .description!,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                )
                              : Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Column(
                                      children: [
                                        Icon(
                                          CupertinoIcons.doc_text,
                                          size: 40,
                                          color: Colors.grey[300],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .noNotesMsg,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 2. GOVERNMENT SERVICES SECTION
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      children: [
                        Container(
                          height: 24,
                          width: 4,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'सरकारी सेवाहरू',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Government Services Cards - Horizontal Scrollable
                  SizedBox(
                    height: 155,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      children: [
                        // Governemt Service Centers Card
                        _buildHorizontalFeatureCard(
                          context: context,
                          title: 'Government Offices',
                          subtitle: 'Find nearby agriculture offices and labs',
                          badge: 'Locations',
                          icon: Icons.location_city,
                          gradientColors: [
                            Colors.blue[700]!,
                            Colors.cyan[600]!
                          ],
                          onTap: () =>
                              Get.toNamed(AppRoute.serviceCentersScreen),
                        ),

                        const SizedBox(width: 12),

                        // Subsidies Card
                        _buildHorizontalFeatureCard(
                          context: context,
                          title: 'Subsidies &\nBenefits',
                          subtitle: 'Explore government subsidies',
                          badge: 'Gov Support',
                          icon: Icons.account_balance_wallet,
                          gradientColors: [kPrimaryColor, Colors.amber[600]!],
                          onTap: () => Get.toNamed(AppRoute.subsidyScreen),
                        ),
                        const SizedBox(width: 12),

                        // Complaints Card
                        _buildHorizontalFeatureCard(
                          context: context,
                          title: 'File\nComplaints',
                          subtitle: 'Report your problems',
                          badge: 'Report Issues',
                          icon: Icons.report_problem,
                          gradientColors: [
                            Colors.red[600]!,
                            Colors.orange[600]!
                          ],
                          onTap: () => Get.toNamed(AppRoute.complaintsScreen),
                        ),
                        const SizedBox(width: 12),

                        // Surveys Card
                        _buildHorizontalFeatureCard(
                          context: context,
                          title: 'Surveys',
                          subtitle: 'Share your feedback',
                          badge: 'Feedback',
                          icon: Icons.poll,
                          gradientColors: [
                            Colors.purple[600]!,
                            Colors.deepPurple[600]!
                          ],
                          onTap: () => Get.toNamed(AppRoute.surveysScreen),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 3. QUICK ACTIONS SECTION (Activity Cards)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Container(
                          height: 24,
                          width: 4,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'द्रुत कार्यहरू',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Activity Grid - Original Design
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      childAspectRatio: 1.0,
                      crossAxisCount: 3,
                      crossAxisSpacing: getProportionateScreenWidth(10),
                      mainAxisSpacing: getProportionateScreenWidth(10),
                      children: myList.map((data) {
                        return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Colors.red,
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(data.route);
                            },
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      stops: const [
                                        0.1,
                                        0.6,
                                      ],
                                      colors: [
                                        Color(data.color),
                                        Color(data.color).withOpacity(0.8)
                                      ]),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Stack(
                                children: [
                                  Positioned(
                                    bottom: -55,
                                    left: -55,
                                    child: Container(
                                      height: getProportionateScreenWidth(110),
                                      width: getProportionateScreenWidth(110),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(55.0)),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 5,
                                    left: 3,
                                    child: Image.asset(
                                      data.img,
                                      height: getProportionateScreenWidth(35),
                                    ),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(
                                          top: 8, left: 10),
                                      alignment: Alignment.topLeft,
                                      child: Obx(
                                        () => Text(
                                            data.id == 1
                                                ? convertToNepaliNumber(
                                                    dailyActivityController
                                                        .activities.length
                                                        .toString())
                                                : data.id == 2
                                                    ? convertToNepaliNumber(
                                                        productController
                                                            .products.length
                                                            .toString())
                                                    : data.id == 3
                                                        ? convertToNepaliNumber(
                                                            incomeController
                                                                .incomeActivities
                                                                .length
                                                                .toString())
                                                        : data.id == 4
                                                            ? convertToNepaliNumber(
                                                                expenseController
                                                                    .expenseActivities
                                                                    .length
                                                                    .toString())
                                                            : data.id == 6
                                                                ? farmlandController
                                                                    .emptyString
                                                                    .value
                                                                : convertToNepaliNumber(
                                                                    farmlandController
                                                                        .farmlands
                                                                        .length
                                                                        .toString()),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600)),
                                      )),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 10, right: 10),
                                    alignment: Alignment.topRight,
                                    child: Text(data.title,
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 4. CROP INFORMATION BANNER (LAST)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(AppRoute.cropInfoListScreen);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 15,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              // Background Image
                              Image.asset(
                                'assets/images/crop_banner_img.png',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                              // Gradient Overlay
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.3),
                                      Colors.black.withOpacity(0.6),
                                    ],
                                  ),
                                ),
                              ),
                              // Content
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .knowAboutCrops,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black26,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(25),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            Get.toNamed(
                                                AppRoute.cropInfoListScreen);
                                          },
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 28,
                                              vertical: 12,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .clickHere,
                                                  style: const TextStyle(
                                                    color: kPrimaryColor,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                const Icon(
                                                  Icons.arrow_forward,
                                                  color: kPrimaryColor,
                                                  size: 18,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalFeatureCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String badge,
    required IconData icon,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 250,
      height: 135,
      child: Card(
        elevation: 3,
        shadowColor: gradientColors[0].withOpacity(0.25),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
            ),
            child: Stack(
              children: [
                // Background decoration
                Positioned(
                  top: -30,
                  right: -30,
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -35,
                  left: -35,
                  child: Container(
                    height: 110,
                    width: 110,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              badge,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                            ),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.92),
                              fontSize: 12,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 10,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              icon,
                              color: Colors.white,
                              size: 22,
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
      ),
    );
  }
}

class Items {
  int id;
  String title;
  String? count;
  String route;
  String img;
  int color;
  Items({
    required this.id,
    required this.title,
    this.count,
    required this.route,
    required this.img,
    required this.color,
  });
}
