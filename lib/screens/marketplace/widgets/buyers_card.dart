import 'package:flutter/material.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/size_config.dart';

class BuyersCard extends StatelessWidget {
  const BuyersCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(15)),
      decoration: BoxDecoration(
        color: kCanvasColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          _buildCardHeader(),
          _buildCardFooter(),
        ],
      ),
    );
  }

  // Header section with crop details and image
  Widget _buildCardHeader() {
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCropDetails(),
          _buildCropImage(),
        ],
      ),
    );
  }

  // Footer section with seller details and call button
  Widget _buildCardFooter() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage("assets/images/profileimage.png"),
          ),
          SizedBox(width: 10),
          _buildSellerDetails(),
          Spacer(),
          _buildCallButton(),
        ],
      ),
    );
  }

  // Crop details with quantity and rate
  Widget _buildCropDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cabbage',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            _buildQuantityColumn(),
            SizedBox(width: 20),
            _buildRateColumn(),
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
        image: AssetImage("assets/images/profileimage.png"),
        height: getProportionateScreenWidth(80),
        width: getProportionateScreenWidth(80),
        fit: BoxFit.cover,
      ),
    );
  }

  // Quantity column
  Widget _buildQuantityColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quantity',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w300,
            color: kCardDescColor,
          ),
        ),
        Row(
          children: [
            Text(
              '40',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            Text(
              ' Kg',
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
  Widget _buildRateColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rate',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w300,
            color: kCardDescColor,
          ),
        ),
        Row(
          children: [
            Text(
              '\$120 ',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            Text(
              '/ Kg',
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

  // Seller details with name and location
  Widget _buildSellerDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Anthony Gonsalves',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          'Koteshwor, Kathmandu',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w300,
            color: kCardDescColor,
          ),
        ),
      ],
    );
  }

  // Call button
  Widget _buildCallButton() {
    return ClipOval(
      child: Material(
        color: kPrimaryColor, // Button color
        child: InkWell(
          splashColor: Colors.greenAccent, // Splash color
          onTap: () {
            // Implement call action here
          },
          child: SizedBox(
            width: 35,
            height: 35,
            child: Icon(
              Icons.phone,
              size: 16,
              color: kCanvasColor,
            ),
          ),
        ),
      ),
    );
  }
}
