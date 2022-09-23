import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/common/constants/string_constsnt.dart';
import 'package:flutter_demo/common/widget/app_button.dart';
import 'package:flutter_demo/common/widget/app_snackbar.dart';
import 'package:flutter_demo/common/widget/app_text.dart';
import 'package:flutter_demo/model/user_model.dart';
import 'package:flutter_demo/service/auth_serivce.dart';
import 'package:flutter_demo/service/user_service.dart';

import '../common/constants/color_constant.dart';
import '../common/constants/image_constant.dart';

// ignore: must_be_immutable
class SingleUser extends StatefulWidget {
  TabController? tabController;
  String? uid;

  SingleUser({super.key, this.tabController});

  @override
  State<SingleUser> createState() => _SingleUserState();
}

class _SingleUserState extends State<SingleUser> {
  bool status = false;
  User? user;
  UserService userService = UserService();
  bool statusCheck = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  UserModel? userModel;

  Future<void> getCurrentUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    user = auth.currentUser;
    if (user != null) {
      userModel = await userService.getCurrentUser(id: user!.uid);
      if (kDebugMode) {
        print("userModel===============>${userModel!.toJson()}");
      }
    }
    statusCheck = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (statusCheck)
          ? Center(
              child: Column(
                children: [
                  (user?.photoURL == null)
                      ? CircleAvatar(
                          backgroundImage:
                              NetworkImage(ImageConstants.networkImage),
                          radius: 50,
                          backgroundColor: ColorConstants.commonColor,
                        )
                      : CircleAvatar(
                          backgroundImage:
                              NetworkImage('${userModel!.profileImage}'),
                        ),
                  AppText(
                    text: "Name : ${userModel!.name}",
                    fontSize: 18,
                    color: ColorConstants.black,
                  ),
                  AppText(
                    text: "Email : ${userModel!.email}",
                    fontSize: 18,
                    color: ColorConstants.black,
                  ),
                  AppText(
                    text: "phone number : ${userModel!.phoneNumber}",
                    fontSize: 18,
                    color: ColorConstants.black,
                  ),
                  AppText(
                    text: "birthdate : ${userModel!.birthdate}",
                    fontSize: 18,
                    color: ColorConstants.black,
                  ),
                  AppText(
                    text: "gender : ${userModel!.gender}",
                    fontSize: 18,
                    color: ColorConstants.black,
                  ),
                  (user!.photoURL == null)
                      ? AppButton(
                          ontap: () {
                            AuthService()
                                .signOutWithEmailPassword(widget.tabController);

                            appSnackBar(context, text: "Log out successfully!");
                          },
                          text: StringConstants.logoutButtonText,
                        )
                      : AppButton(
                          ontap: () {
                            AuthService()
                                .signOutWithGoogle(widget.tabController);
                            appSnackBar(context, text: "Log out successfully!");
                          },
                          text: StringConstants.logoutGoogleButtonText,
                        )
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
