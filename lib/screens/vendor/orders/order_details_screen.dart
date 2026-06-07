import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/enums/orderStatus.dart';
import 'package:smart_kishan/models/order.dart';
import 'package:smart_kishan/screens/vendor/orders/widgets/order_card.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/widgets/confirm_dialog.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key, required this.orderDetails});
  final Order orderDetails;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late Order orderDetails;

  @override
  void initState() {
    setState(() {
      orderDetails = widget.orderDetails;
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(orderDetails.number),
      ),
      body: Stack(
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(color: kPrimaryColor),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                orderDetails.items != null
                    ? ListView.separated(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: orderDetails.items!.length,
                        padding: EdgeInsets.symmetric(
                            vertical: getProportionateScreenWidth(15)),
                        itemBuilder: (context, index) {
                          return OrderCard(
                            orderItem: orderDetails.items![index],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: getProportionateScreenWidth(15),
                          );
                        },
                      )
                    : SizedBox(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: kCanvasColor,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: kPrimaryGrey),
                  ),
                  padding: EdgeInsets.only(left: 5),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: _getTimelineItems(orderDetails).length,
                    itemBuilder: (context, index) {
                      final status = _getTimelineItems(orderDetails)[index];
                      final isCompleted = index <=
                          _getTimelineItems(orderDetails)
                              .indexOf(orderDetails.status!);
                      final isCurrent = status == orderDetails.status;
                      final isFuture = index >
                          _getTimelineItems(orderDetails)
                              .indexOf(orderDetails.status!);

                      return TimelineTile(
                        alignment: TimelineAlign.manual,
                        lineXY: 0.0,
                        isFirst:
                            index == 0, // Correctly identify the first step
                        isLast: index ==
                            _getTimelineItems(orderDetails).length -
                                1, // Correctly identify the last step
                        indicatorStyle: IndicatorStyle(
                          width: 10,
                          color: isCompleted
                              ? const Color(
                                  0xFF27AA69) // Green for completed steps
                              : isCurrent
                                  ? const Color(
                                      0xFF2B619C) // Blue for current step
                                  : const Color(
                                      0xFFDADADA), // Grey for future steps
                          padding: EdgeInsets.all(6),
                        ),
                        endChild: _RightChild(
                          asset: _getAssetForStatus(status),
                          title: _getLabelForStatus(status, context),
                          message: _getMessageForStatus(context, status),
                          disabled: isFuture,
                        ),
                        beforeLineStyle: LineStyle(
                          color: isCompleted
                              ? const Color(0xFF27AA69)
                              : const Color(0xFFDADADA),
                          thickness:
                              2, // Adjust line thickness for better visibility
                        ),
                        afterLineStyle: LineStyle(
                          color: isCompleted
                              ? const Color(0xFF27AA69)
                              : const Color(0xFFDADADA),
                          thickness: 2,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: kCanvasColor,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: kPrimaryGrey),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedCash02,
                          color: kPrimaryColor,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.total,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                                '${AppLocalizations.of(context)!.currency}${convertToLocalizedNumber(orderDetails.totalPrice.toString(), context)}')
                          ],
                        )
                      ],
                    )),
                SizedBox(
                  height: 20,
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: kCanvasColor,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: kPrimaryGrey),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        orderDetails.customer != null &&
                                orderDetails.customer!.image != null
                            ? CircleAvatar(
                                radius: 15,
                                backgroundImage: AssetImage(
                                    "$imgUrl${orderDetails.customer!.image}"),
                              )
                            : CircleAvatar(
                                radius: 15,
                                backgroundImage: AssetImage(
                                    "assets/images/profileimage.png"),
                              ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.customer,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 197, 197, 197)),
                            ),
                            Text(
                              '${orderDetails.customer != null ? orderDetails.customer!.name : 'Customer Not Available'}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '${orderDetails.customer != null ? orderDetails.customer!.phone : 'Phone Not Available'}',
                            ),
                          ],
                        ),
                        Spacer(),
                        ClipOval(
                          child: Material(
                            color: kPrimaryColor, // Button color
                            child: InkWell(
                              splashColor: Colors.greenAccent, // Splash color
                              onTap: () {
                                // Implement call action here
                              },
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: Transform.scale(
                                    scaleX: -1,
                                    child: Icon(
                                      Icons.phone,
                                      size: 16,
                                      color: kCanvasColor,
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 20,
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: kCanvasColor,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: kPrimaryGrey),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedLocation01,
                          color: kPrimaryColor,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.deliveryLocation,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 197, 197, 197)),
                            ),
                            Text(
                              orderDetails.deliveryAddress != null
                                  ? '${orderDetails.deliveryAddress!.city},${orderDetails.deliveryAddress!.description}'
                                  : '',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        )
                      ],
                    )),
                SizedBox(
                  height: 120,
                )
              ],
            ),
          ),
          if (orderDetails.status == OrderStatus.newOrder ||
              orderDetails.status == OrderStatus.processing ||
              orderDetails.status == OrderStatus.shipped)
            Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              child: ConstrainedBox(
                constraints: BoxConstraints(),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: SafeArea(
                      child: ElevatedButton(
                    onPressed: () async {
                      if (orderDetails.status != OrderStatus.delivered) {
                        await showModalBottomSheet(
                          context: context,
                          isScrollControlled: false,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            OrderStatus? selectedStatus;
                            return DraggableScrollableSheet(
                              initialChildSize: 1,
                              maxChildSize: 1,
                              builder: (context, scrollController) {
                                return Material(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                  child: Ink(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20)),
                                      ),
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Container(
                                              width: 40,
                                              height: 5,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .updateOrderStatus,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .chooseNewStatus,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600]),
                                          ),
                                          const SizedBox(height: 20),
                                          Expanded(
                                            child: ListView.separated(
                                              controller: scrollController,
                                              itemCount:
                                                  OrderStatus.values.length,
                                              separatorBuilder:
                                                  (context, index) {
                                                return Divider(
                                                  height: 0,
                                                  color: kPrimaryGrey,
                                                );
                                              },
                                              itemBuilder: (context, index) {
                                                final status =
                                                    OrderStatus.values[index];
                                                return InkWell(
                                                  onTap: () async {
                                                    selectedStatus = status;
                                                    Navigator.of(context).pop();
                                                    bool? isUpdated =
                                                        await vendorOrdersController
                                                            .updateOrder(
                                                      orderDetails.id
                                                          .toString(),
                                                      selectedStatus!.rawValue,
                                                    );
                                                    if (isUpdated != null &&
                                                        isUpdated) {
                                                      setState(() {
                                                        orderDetails =
                                                            vendorOrdersController
                                                                .myOrders
                                                                .firstWhere((item) =>
                                                                    item.id ==
                                                                    orderDetails
                                                                        .id);
                                                      });
                                                    }
                                                  },
                                                  child: ListTile(
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    leading: HugeIcon(
                                                      icon: status.icon,
                                                      color: status.color,
                                                    ),
                                                    title: Text(
                                                      _getLabelForStatus(
                                                          status, context),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: kCardTitleColor,
                                                      ),
                                                    ),
                                                    trailing: orderDetails
                                                                .status ==
                                                            status
                                                        ? Icon(
                                                            Icons.check,
                                                            color: Colors.green,
                                                          )
                                                        : null,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      foregroundColor: Colors.white,
                      alignment: Alignment.center,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.updateOrder,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                  )),
                ),
              ),
            )
        ],
      ),
    );
  }

  String _getAssetForStatus(OrderStatus status) {
    switch (status) {
      case OrderStatus.newOrder:
        return 'assets/images/order_placed.png';
      case OrderStatus.processing:
        return 'assets/images/order_confirmed.png';
      case OrderStatus.shipped:
        return 'assets/images/order_processed.png';
      case OrderStatus.delivered:
        return 'assets/images/order_delivered.png';
      case OrderStatus.cancelled:
        return 'assets/images/order_cancelled.png';
      default:
        return '';
    }
  }

  String _getMessageForStatus(BuildContext context, OrderStatus status) {
    switch (status) {
      case OrderStatus.newOrder:
        return AppLocalizations.of(context)!.vendorNewOrderMessage;
      case OrderStatus.processing:
        return AppLocalizations.of(context)!.vendorProcessingMessage;
      case OrderStatus.shipped:
        return AppLocalizations.of(context)!.vendorShippedMessage;
      case OrderStatus.delivered:
        return AppLocalizations.of(context)!.vendorDeliveredMessage;
      case OrderStatus.cancelled:
        return AppLocalizations.of(context)!.vendorCancelledMessage;
      default:
        return '';
    }
  }

  String _getLabelForStatus(OrderStatus status, BuildContext context) {
    switch (status) {
      case OrderStatus.newOrder:
        return AppLocalizations.of(context)!.orderPlaced;
      case OrderStatus.processing:
        return AppLocalizations.of(context)!.confirmed;
      case OrderStatus.shipped:
        return AppLocalizations.of(context)!.shipped;
      case OrderStatus.delivered:
        return AppLocalizations.of(context)!.delivered;
      case OrderStatus.cancelled:
        return AppLocalizations.of(context)!.cancelled;
      default:
        return '';
    }
  }

  List<OrderStatus> _getTimelineItems(Order orderDetails) {
    if (orderDetails.status == OrderStatus.cancelled) {
      // For cancelled orders, show only "Cancelled" status
      return [OrderStatus.newOrder, OrderStatus.cancelled];
    } else {
      // Regular timeline for non-cancelled orders
      return [
        OrderStatus.newOrder,
        OrderStatus.processing,
        OrderStatus.shipped,
        OrderStatus.delivered
      ];
    }
  }
}

class _RightChild extends StatelessWidget {
  const _RightChild({
    Key? key,
    required this.asset,
    required this.title,
    required this.message,
    this.disabled = false,
  }) : super(key: key);

  final String asset;
  final String title;
  final String message;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Opacity(
            opacity: disabled ? 0.5 : 1,
            child: Image.asset(asset, height: 30),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: disabled
                      ? const Color(0xFFBABABA)
                      : const Color(0xFF636564),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                message,
                style: TextStyle(
                  color: disabled
                      ? const Color(0xFFD5D5D5)
                      : const Color(0xFF636564),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
