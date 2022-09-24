import 'package:flutter/material.dart';
import 'package:flutter_demo/common/widget/app_text.dart';
import 'package:flutter_demo/model/user_model.dart';
import 'package:flutter_demo/service/user_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../common/constants/color_constant.dart';

class GetAllUser extends StatefulWidget {
  const GetAllUser({Key? key}) : super(key: key);

  @override
  State<GetAllUser> createState() => _GetAllUserState();
}

class _GetAllUserState extends State<GetAllUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: UserService().getAllUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<UserModel>? list = snapshot.data;
              if (list!.isNotEmpty) {
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: AppText(text: list[index].name),
                      trailing: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  title: const AppText(
                                    text: "Delete Dialog",
                                    color: Colors.black,
                                  ),
                                  content: const AppText(
                                    text: "Do you want to delete this user?",
                                    color: Colors.black,
                                  ),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          UserService userService =
                                              UserService();
                                          userService
                                              .deleteUser(list[index].uid);
                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                        child: AppText(
                                          text: "Yes",
                                          color: ColorConstants.textColor,
                                        )),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: AppText(
                                          text: "No",
                                          color: ColorConstants.textColor,
                                        )),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(
                            Icons.delete,
                            color: ColorConstants.commonColor,
                          )),
                    );
                  },
                );
              }
              return const Center(
                child: AppText(
                  text: "No data  found",
                ),
              );
            }
          }
          return SpinKitCircle(
            color: ColorConstants.commonColor,
          );
        },
      ),
    );
  }
}
