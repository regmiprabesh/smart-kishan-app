import 'package:flutter/material.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/models/orderItem.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.orderItem});
  final OrderItem orderItem;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(15)),
      decoration: BoxDecoration(
        color: kCanvasColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: kPrimaryGrey),
      ),
      child: Column(
        children: [
          _buildCardHeader(context),
          // _buildCardFooter(),
        ],
      ),
    );
  }

  // Header section with crop details and image
  Widget _buildCardHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCropDetails(context),
          _buildCropImage(),
        ],
      ),
    );
  }

  // Crop details with quantity and rate
  Widget _buildCropDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${orderItem.product != null ? orderItem.product!.name : ''}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            _buildQuantityColumn(context),
            SizedBox(width: 20),
            _buildRateColumn(context),
          ],
        ),
      ],
    );
  }

  // Crop image
  Widget _buildCropImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
      child: Image(
        image: NetworkImage(orderItem.product != null &&
                orderItem.product!.imageUrls != null &&
                orderItem.product!.imageUrls!.isNotEmpty
            ? '$imgUrl${orderItem.product!.imageUrls![0]}'
            : ''),
        height: getProportionateScreenWidth(80),
        width: getProportionateScreenWidth(80),
        fit: BoxFit.cover,
      ),
    );
  }

  // Quantity column
  Widget _buildQuantityColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.quantity,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w300,
            color: kCardDescColor,
          ),
        ),
        Row(
          children: [
            Text(
              '${convertToLocalizedNumber(orderItem.quantity.toString(), context)} ',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            Text(
              '${orderItem.product != null && orderItem.product!.unit != null ? orderItem.product!.unit!.code : ''}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: kCardDescColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

// Rate column
  Widget _buildRateColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.rate,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w300,
            color: kCardDescColor,
          ),
        ),
        Row(
          children: [
            Text(
              '${AppLocalizations.of(context)!.currency}${convertToLocalizedNumber(orderItem.unitPrice, context)} ',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            Text(
              '/ ${orderItem.product != null && orderItem.product!.unit != null ? orderItem.product!.unit!.code : ''}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: kCardDescColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
