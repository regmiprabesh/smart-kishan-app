import 'package:flutter/cupertino.dart';
import 'package:smart_kishan/screens/marketplace/widgets/buyers_card.dart';
import 'package:smart_kishan/size_config.dart';

class BuyersScreen extends StatelessWidget {
  const BuyersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 4,
      padding: EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
      itemBuilder: (context, index) {
        return BuyersCard();
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: getProportionateScreenWidth(15),
        );
      },
    );
  }
}
