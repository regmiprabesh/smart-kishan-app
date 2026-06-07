import 'package:flutter/material.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/screens/vendor/orders/active_orders.dart';
import 'package:smart_kishan/screens/vendor/orders/inactive_orders.dart';
import 'package:smart_kishan/size_config.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
        title: const Text('मेरो अर्डर',
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
                    text: 'सक्रिय अर्डर',
                  ),
                  Tab(
                    text: 'निष्क्रिय अर्डर',
                  ),
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
              ActiveOrders(),
              InactiveOrders(),
            ],
          ),
        ),
      ]),
    );
  }
}
