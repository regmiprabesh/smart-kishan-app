import 'package:flutter/material.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/screens/marketplace/buyers_screen.dart';
import 'package:smart_kishan/screens/marketplace/my_listing_screen.dart';
import 'package:smart_kishan/screens/marketplace/sellers_screen.dart';
import 'package:smart_kishan/size_config.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text('बजार',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
      body: Column(children: [
        Material(
            color: kPrimaryLightColor,
            child: Theme(
              data: ThemeData().copyWith(splashColor: kPrimaryColor),
              child: TabBar(
                labelStyle: TextStyle(
                    fontSize: getProportionateScreenWidth(13),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins'),
                labelColor: Colors.black,
                indicatorColor: kPrimaryColor,
                tabs: const [
                  Tab(
                    text: 'खरिदकर्ता',
                  ),
                  Tab(
                    text: 'बिक्रेता',
                  ),
                  Tab(
                    text: 'मेरो बिक्री सूची',
                  )
                ],
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
              ),
            )),
        Expanded(
          child: TabBarView(
            physics: const BouncingScrollPhysics(),
            controller: _tabController,
            children: const [
              BuyersScreen(),
              SellersScreen(),
              MyListingScreen()
            ],
          ),
        ),
      ]),
    );
  }
}
