import 'package:flutter/material.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/models/order.dart';
import 'package:smart_kishan/models/orderItem.dart';
import 'package:smart_kishan/models/searchHistory.dart';
import 'package:smart_kishan/screens/vendor/orders/order_details_screen.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/widgets/order_status_tag.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class OrderGroupCard extends StatelessWidget {
  const OrderGroupCard({super.key, required this.order});
  final Order order;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Material(
        color: kCanvasColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          splashColor: kPrimaryColor.withOpacity(0.1),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderDetailsScreen(
                        orderDetails: order,
                      )),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: kPrimaryGrey),
            ),
            child: Column(
              children: [
                _buildCardHeader(context),
                _buildCardTotal(context),
                Divider(
                  height: 1,
                  color: kPrimaryGrey.withOpacity(0.5),
                ),
                order.items != null
                    ? ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          OrderItem currentItem = order.items![index];
                          return _buildItemDetail(currentItem, context);
                        },
                        itemCount: order.items!.length)
                    : SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Header section with crop details and image
  Widget _buildCardTotal(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(15),
          vertical: getProportionateScreenWidth(10)),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.total,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 15),
          Text(
            '${AppLocalizations.of(context)!.currency}${convertToLocalizedNumber(order.totalPrice.toString(), context)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          order.status != null ? StatusTag(status: order.status!) : SizedBox()
        ],
      ),
    );
  }

  // Footer section with seller details and call button
  Widget _buildCardHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  '#${order.number}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 15),
                Flexible(
                  child: Text(
                    '${order.customer != null ? order.customer!.name : AppLocalizations.of(context)!.customerNotAvailable}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 15),
              ],
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.calendar_month,
                color: kCardDescColor,
                size: 16,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                formatDate(DateTime.parse(order.createdAt!),
                    AppLocalizations.of(context)!.localeName),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Crop details with quantity and rate
  Widget _buildItemDetail(OrderItem item, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          Text(
            '${convertToLocalizedNumber(item.quantity.toString(), context)} ${item.product != null && item.product!.unit != null ? item.product!.unit!.code : ''}',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          SizedBox(width: 10),
          Text(
            'x',
          ),
          SizedBox(width: 10),
          ClipRRect(
            borderRadius:
                BorderRadius.circular(20), // Adjust the radius as needed
            child: Image(
              image: NetworkImage(item.product != null &&
                      item.product!.imageUrls != null &&
                      item.product!.imageUrls!.isNotEmpty
                  ? '$imgUrl${item.product!.imageUrls![0]}'
                  : ''),
              height: getProportionateScreenWidth(25),
              width: getProportionateScreenWidth(25),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10),
          Text(
            '${item.product != null ? item.product!.name : AppLocalizations.of(context)!.productNotAvailable}',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
