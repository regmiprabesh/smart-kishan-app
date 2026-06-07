import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/models/deliveryAddress.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class MyDeliveryAddress extends StatefulWidget {
  const MyDeliveryAddress({super.key});

  @override
  State<MyDeliveryAddress> createState() => _MyDeliveryAddressState();
}

class _MyDeliveryAddressState extends State<MyDeliveryAddress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          AppLocalizations.of(context)!.myDeliveryAddress,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Divider(
            height: 2,
            color: kPrimaryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (deliveryAddressController
                                  .deliveryAddressList.length >=
                              3) {
                            ScaffoldMessenger.of(Get.overlayContext!)
                                .showSnackBar(
                              const SnackBar(
                                backgroundColor: kErrorColor,
                                content: Text(
                                  'You can only add up to 3 delivery addresses.',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            );
                            return;
                          }
                          Get.toNamed(AppRoute.addAddressScreen);
                        },
                        icon: HugeIcon(icon: HugeIcons.strokeRoundedAddCircle),
                        label: Text(
                          AppLocalizations.of(context)!.addNewAddress,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          foregroundColor: Colors.black,
                          alignment: Alignment.center,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Obx(
                      () => Column(
                        children: [
                          deliveryAddressController
                                  .deliveryAddressList.isNotEmpty
                              ? ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    DeliveryAddress address =
                                        deliveryAddressController
                                            .deliveryAddressList[index];
                                    return AddressCard(
                                      id: address.id != null ? address.id! : 0,
                                      title: address.addressTitle,
                                      isDefault: address
                                          .isDefault, // Dynamic default check
                                      name: address.city,
                                      phone: "${address.phone}",
                                      address: "${address.description}",
                                      isSelected: address.isDefault,
                                      onSelect: () {
                                        deliveryAddressController.isEdit(true);
                                        deliveryAddressController
                                            .selectedDeliveryAddress(address);
                                        Get.toNamed(AppRoute.addAddressScreen);
                                      },
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: 10),
                                  itemCount: deliveryAddressController
                                      .deliveryAddressList.length)
                              : Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.info, color: Colors.grey),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .noDeliveryAddress,
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          SizedBox(height: 16),
                          deliveryAddressController
                                  .deliveryAddressList.isNotEmpty
                              ? Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.info, color: Colors.grey),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .deliveryChargesInfo,
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  final int id;
  final String title;
  final bool isDefault;
  final String name;
  final String phone;
  final String address;
  final bool isSelected;
  final VoidCallback onSelect;
  const AddressCard({
    required this.id,
    required this.title,
    required this.isDefault,
    required this.name,
    required this.phone,
    required this.address,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(
          12), // Set the border radius for the ripple effect
      onTap: onSelect,
      child: Container(
        decoration: BoxDecoration(
            border:
                Border.all(color: isSelected ? kPrimaryColor : kPrimaryGrey),
            borderRadius: BorderRadius.circular(12),
            color: isSelected ? kPrimaryColor.withOpacity(0.1) : null),
        child: ListTile(
          title: Row(
            children: [
              // Flexible container for title and default tag
              Expanded(
                flex: 50, // Allocate a higher proportion to the title and tag
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isDefault)
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "Default",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Spacer for separation
              Spacer(),
              // Buttons aligned to the right
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton.outlined(
                    color: Colors.grey,
                    visualDensity: VisualDensity.compact,
                    iconSize: 16,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey),
                    ),
                    onPressed: onSelect,
                    icon: HugeIcon(icon: HugeIcons.strokeRoundedEdit02),
                  ),
                  IconButton.outlined(
                    color: kErrorColor,
                    visualDensity: VisualDensity.compact,
                    iconSize: 16,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: kErrorColor),
                    ),
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
                                        AppLocalizations.of(context)!
                                            .deleteDeliveryAddressTitle,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .deleteDeliveryAddressMessage,
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
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .cancel),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              foregroundColor: Colors.white,
                                              minimumSize: const Size(100, 40),
                                            ),
                                            onPressed: () {
                                              deliveryAddressController
                                                  .deleteDeliveryAddress(id);
                                            },
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .delete),
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
                                      icon: HugeIcons
                                          .strokeRoundedLocationRemove02,
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
                    icon: HugeIcon(icon: HugeIcons.strokeRoundedDelete01),
                  ),
                ],
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                phone,
                overflow: TextOverflow.ellipsis,
              ),
              Text(address),
            ],
          ),
        ),
      ),
    );
  }
}
