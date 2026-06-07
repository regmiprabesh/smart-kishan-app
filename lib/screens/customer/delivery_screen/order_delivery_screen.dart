import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/models/deliveryAddress.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class OrderDeliveryScreen extends StatefulWidget {
  const OrderDeliveryScreen({super.key});

  @override
  State<OrderDeliveryScreen> createState() => _OrderDeliveryScreenState();
}

class _OrderDeliveryScreenState extends State<OrderDeliveryScreen> {
  int? selectedAddressId; // Store selected address by ID
  @override
  void initState() {
    super.initState();

    // Find the first address that is marked as default
    DeliveryAddress? defaultAddress =
        deliveryAddressController.deliveryAddressList.firstWhereOrNull(
      (element) => element.isDefault,
    );

    // If a default address is found, set the selectedAddressId to its ID
    if (defaultAddress != null) {
      selectedAddressId = defaultAddress.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final selectedProductId = arguments?['productId'];
    final selectedProductQuantity = arguments?['quantity'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          AppLocalizations.of(context)!.selectDeliveryLocation,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Divider(
            height: 2,
            color: Colors.grey,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Ink(
              decoration: ShapeDecoration(
                color: Colors.grey.withOpacity(0.4),
                shape: CircleBorder(),
              ),
              child: SizedBox(
                height: 30,
                width: 30,
                child: IconButton(
                  iconSize: 15,
                  color: Colors.black,
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
        ],
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
                        label:
                            Text(AppLocalizations.of(context)!.addNewAddress),
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
                                        title: address.addressTitle,
                                        isDefault: address
                                            .isDefault, // Dynamic default check
                                        name: address.city,
                                        phone: "+977${address.phone}",
                                        address: "${address.description}",
                                        isSelected: selectedAddressId == null
                                            ? address.isDefault
                                            : selectedAddressId ==
                                                address.id, // Compare by ID
                                        onSelect: () {
                                          if (address.id != null) {
                                            setState(() {
                                              selectedAddressId = address
                                                  .id; // Update selected ID
                                            });
                                          }
                                        });
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
              Align(
                alignment: Alignment.bottomCenter,
                child: Obx(
                  () => SafeArea(
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(top: 10),
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 10),
                      child: MaterialButton(
                        onPressed: deliveryAddressController
                                .deliveryAddressList.isNotEmpty
                            ? () {
                                if (selectedAddressId == null) {
                                  ScaffoldMessenger.of(Get.overlayContext!)
                                      .showSnackBar(
                                    const SnackBar(
                                      backgroundColor: kErrorColor,
                                      content: Text(
                                        'Please select a delivery address to proceed.',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                if (selectedProductId != null) {
                                  // Place direct buy order
                                  customerOrdersController.orderDirectly({
                                    'deliverylocation_id': selectedAddressId,
                                    'product_id': selectedProductId,
                                    'quantity': selectedProductQuantity,
                                  });
                                } else {
                                  // Place cart order
                                  customerOrdersController.orderFromCart({
                                    'deliverylocation_id': selectedAddressId
                                  });
                                }
                              }
                            : null,
                        height: 50,
                        minWidth: double.infinity,
                        color: deliveryAddressController
                                .deliveryAddressList.isNotEmpty
                            ? kPrimaryColor
                            : kPrimaryColor.withOpacity(0.5),
                        disabledColor: kPrimaryColor.withOpacity(0.5),
                        textColor: Colors.white,
                        disabledTextColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.confirmOrder,
                        ),
                      ),
                    ),
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

class AddressCard extends StatelessWidget {
  final String title;
  final bool isDefault;
  final String name;
  final String phone;
  final String address;
  final bool isSelected;
  final VoidCallback onSelect;

  const AddressCard({
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
              Text(title,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
              if (isDefault)
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.defaultResults,
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
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name),
              Text(phone),
              Text(address),
            ],
          ),
          trailing: isSelected
              ? Icon(Icons.check_circle, color: kPrimaryColor)
              : null,
        ),
      ),
    );
  }
}
