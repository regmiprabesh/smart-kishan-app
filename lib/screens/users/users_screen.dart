import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/helpers/l10n.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/size_config.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          automaticallyImplyLeading: false,
          title: Text(l10n.users,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Get.toNamed(AppRoute.addUserScreen);
            userController.isEdit(false);
          },
          backgroundColor: kPrimaryColor,
          child: const Icon(Icons.add),
        ),
        body: Obx(
          () => userController.users.isNotEmpty
              ? ListView.separated(
                  itemCount: userController.users.length,
                  itemBuilder: (context, index) => ListTile(
                    onTap: () {
                      userController.selectedUser(userController.users[index]);
                      userController.isEdit(true);
                      Get.toNamed(AppRoute.addUserScreen);
                    },
                    contentPadding:
                        const EdgeInsets.only(left: 0.0, right: 15, top: 10),
                    leading: CircleAvatar(
                      radius: 50,
                      backgroundColor: kPrimaryColor,
                      foregroundColor: Colors.white,
                      child: Text(userController.users[index].name![0]),
                    ),
                    title: Text(userController.users[index].name!),
                    subtitle: Text(userController.users[index].phone!),
                    trailing: IconButton(
                        icon: const Icon(CupertinoIcons.delete),
                        onPressed: (() async {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  l10n.confirmDelete,
                                  style: TextStyle(
                                    fontSize: getProportionateScreenWidth(16),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                content: Text(
                                  l10n.deleteUserConfirm,
                                  style: TextStyle(
                                      fontSize: getProportionateScreenWidth(14),
                                      fontWeight: FontWeight.w500,
                                      color: kCardDescColor),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () async {
                                      userController.deleteUser(
                                          userController.users[index].id!);
                                    },
                                    child: Text(l10n.delete),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: Text(l10n.cancel),
                                  ),
                                ],
                              );
                            },
                          );
                        })),
                  ),
                  separatorBuilder: (context, index) {
                    return const Divider(
                      height: 5,
                    );
                  },
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(l10n.noUsersYet,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      SizedBox(
                        height: getProportionateScreenHeight(15),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              minimumSize: Size(getProportionateScreenWidth(20),
                                  getProportionateScreenWidth(40))),
                          onPressed: () {
                            userController.isEdit(false);
                            Get.toNamed(AppRoute.addUserScreen);
                          },
                          child: Text(l10n.addUser))
                    ],
                  ),
                ),
        ));
  }
}
