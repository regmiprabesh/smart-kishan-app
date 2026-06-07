import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_kishan/color_config.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/models/buyersgroup.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/size_config.dart';

class BuyersGroupScreen extends StatefulWidget {
  const BuyersGroupScreen({super.key});

  @override
  State<BuyersGroupScreen> createState() => _BuyersGroupScreenState();
}

class _BuyersGroupScreenState extends State<BuyersGroupScreen> {
  @override
  void initState() {
    buyersGroupController.getBuyersGroups();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('खरिदकर्ताहरूको समूह')),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            buyersGroupController.isEdit(false);
            buyersGroupController.selectedBuyersGroupImage.value = '';
            buyersGroupController.networkBuyersGroupImage.value = '';
            Get.toNamed(AppRoute.addBuyersGroup);
          },
          backgroundColor: kPrimaryColor,
          child: const Icon(Icons.add),
        ),
        body: Obx(() => buyersGroupController.buyersGroups.isNotEmpty
            ? ListView.separated(
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 15,
                  );
                },
                padding: const EdgeInsets.all(15.0),
                itemCount: buyersGroupController.buyersGroups.length,
                itemBuilder: (context, index) {
                  final group = buyersGroupController.buyersGroups[index];
                  return index == buyersGroupController.buyersGroups.length - 1
                      ? Container(
                          margin: EdgeInsets.only(bottom: 120),
                          child: GroupCard(group: group),
                        )
                      : GroupCard(group: group);
                },
              )
            : SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height -
                      kToolbarHeight - // Exclude AppBar height
                      MediaQuery.of(context).padding.top -
                      80,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image Icon Section
                      CircleAvatar(
                        radius: 80, // Circle size
                        backgroundColor:
                            Colors.green.shade50, // Soft beige background
                        child: Icon(
                          Icons.group,
                          size: 80,
                          color:
                              Colors.green.shade300, // Brownish tint for icon
                        ),
                      ),
                      const SizedBox(height: 20), // Spacing
                      // "No Groups" Title
                      const Text(
                        "हाल खरिदकर्ताहरूको समूह खाली छ!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10), // Spacing

                      // Subtitle Text
                      const Text(
                        "आफ्ना साथीहरूसँग खरिदकर्ताहरूको समूह सिर्जना गर्नुहोस्।",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(15),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              minimumSize: Size(getProportionateScreenWidth(20),
                                  getProportionateScreenWidth(40))),
                          onPressed: () {
                            buyersGroupController.isEdit(false);
                            buyersGroupController
                                .selectedBuyersGroupImage.value = '';
                            buyersGroupController
                                .networkBuyersGroupImage.value = '';
                            Get.toNamed(AppRoute.addBuyersGroup);
                          },
                          child: const Text('समूह थप गर्नुहोस'))
                    ],
                  )),
                ),
              )));
  }
}

class GroupCard extends StatefulWidget {
  final BuyersGroup group;

  const GroupCard({Key? key, required this.group}) : super(key: key);

  @override
  _GroupCardState createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
  @override
  Widget build(BuildContext context) {
    final group = widget.group;
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 150),
      child: InkWell(
        onTap: () {
          buyersGroupController.isEdit(true);
          buyersGroupController.selectedBuyersGroup(group);
          if (group.image != null) {
            buyersGroupController.networkBuyersGroupImage(group.image);
          } else {
            buyersGroupController.networkBuyersGroupImage.value = '';
          }
          Get.toNamed(AppRoute.addBuyersGroup);
        },
        focusColor: Colors.white,
        splashColor: kPrimaryColor.withOpacity(0.2),
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: kPrimaryColor.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 15,
                offset: const Offset(5, 5),
              ),
              BoxShadow(
                color: kPrimaryColor.withOpacity(0.2),
                offset: Offset(-5, -5),
                blurRadius: 15,
                spreadRadius: 1,
              ),
            ],
            color: Colors.white,
          ),
          child: Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Group name and action button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${group.name}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        IconButton.outlined(
                          icon: Icon(CupertinoIcons.arrow_right),
                          onPressed: () {
                            Get.toNamed(AppRoute.addBuyersGroup);
                          },
                        ),
                      ],
                    ),

                    // People count

                    Text(
                      'खरिदकर्ता(${group.buyers != null ? convertToNepaliNumber(group.buyers!.length.toString()) : convertToNepaliNumber(0.toString())})',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 10),

                    // Avatars of buyers
                    group.buyers != null && group.buyers!.isNotEmpty
                        ? SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 5),
                              itemCount: group.buyers!.length > 4
                                  ? 5
                                  : group.buyers!.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                if (index == 4 && group.buyers!.length > 4) {
                                  // If more than 4 buyers, show the "+X" avatar
                                  return CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.grey.shade300,
                                    child: Text(
                                      '+${group.buyers!.length - 4}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  );
                                } else {
                                  // Show regular buyer avatar or initials
                                  return group.buyers![index].image != null &&
                                          group.buyers![index].image!.isNotEmpty
                                      ? CircleAvatar(
                                          radius: 20, // Size of the avatar
                                          backgroundImage: NetworkImage(
                                              group.buyers![index].image!),
                                        )
                                      : CircleAvatar(
                                          radius: 20,
                                          backgroundColor: getRandomColor(),
                                          child: Text(
                                            group.buyers![index].name!
                                                .substring(0, 1)
                                                .toUpperCase(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                }
                              },
                            ),
                          )
                        : SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'समूह खाली छ!',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400),
                              ),
                            )),
                  ],
                ),
              ),

              // Delete button positioned in bottom-right
              Positioned(
                bottom: 15,
                right: 15,
                child: IconButton.outlined(
                  color: Colors.red,
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.red)),
                  onPressed: () async {
                    // Show confirmation dialog or directly handle deletion
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          backgroundColor: Colors.transparent,
                          insetPadding: const EdgeInsets.all(
                              10), // To control padding from the edges
                          child: Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width *
                                    0.8, // 80% of screen width
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 40),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                        height: 60), // Space for the icon
                                    Text(
                                      "समूह मेटाउनुस्",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "के तपाईं यो समूह मेटाउने निश्चित हुनुहुन्छ?",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey[200],
                                            foregroundColor: Colors.black,
                                            minimumSize: const Size(100, 40),
                                          ),
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text("रद्द गर्नुहोस्"),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            minimumSize: const Size(100, 40),
                                          ),
                                          onPressed: () {
                                            buyersGroupController
                                                .deleteBuyersGroup(group.id!);
                                          },
                                          child: const Text("मेटाउनुस्"),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 0, // Position the icon above the dialog
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.white,
                                  child: HugeIcon(
                                    icon: HugeIcons.strokeRoundedDelete04,
                                    color: Colors.red,
                                    size: 50,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(
                    CupertinoIcons.delete,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
