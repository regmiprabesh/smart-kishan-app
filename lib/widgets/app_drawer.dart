import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';

class AppDrawerItem {
  final List<List<dynamic>> icon;
  final String title;
  final VoidCallback onTap;
  AppDrawerItem({required this.icon, required this.title, required this.onTap});
}

class AppDrawer extends StatelessWidget {
  final List<AppDrawerItem> items;
  const AppDrawer({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(authController.user.value?.name ?? '',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            accountEmail: Text(authController.user.value?.phone ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundImage:
                  const AssetImage("assets/images/profileimage.png"),
              backgroundColor: Colors.grey[200],
            ),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: items
                  .map((item) => ListTile(
                        leading:
                            HugeIcon(icon: item.icon, color: kCardDescColor),
                        title: Text(item.title,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: kCardTitleColor,
                                fontFamily: 'Poppins')),
                        onTap: item.onTap,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
