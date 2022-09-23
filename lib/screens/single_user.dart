import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/common/constants/string_constsnt.dart';
import 'package:flutter_demo/common/widget/app_button.dart';
import 'package:flutter_demo/common/widget/app_snackbar.dart';
import 'package:flutter_demo/common/widget/app_text.dart';
import 'package:flutter_demo/common/widget/app_textfield.dart';
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

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();
  TextEditingController genderController = TextEditingController();

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
      userModel = await userService!.getCurrentUser(id: user!.uid);
      if (kDebugMode) {
        print("userModel===============>${userModel!.toJson()}");
      }

      nameController.text = userModel!.name!;
      emailController.text = userModel!.email!;
      contactController.text = userModel!.phoneNumber!;
      birthdateController.text = userModel!.birthdate!;
      genderController.text = userModel!.gender!;
    }
    user!.reload();
    statusCheck = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (statusCheck)
          ? Center(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    AppText(
                      text: "Profile",
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: ColorConstants.black,
                    ),
                    (user?.photoURL == null)
                        ? Container(
                            height: 100,
                            width: 100,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              'assets/images/user.png',
                              fit: BoxFit.contain,
                            ),
                          )
                        : Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 1.5,
                                    color: ColorConstants.commonColor)),
                            child: ClipRRect(
                                borderRadius:
                                    BorderRadiusDirectional.circular(80),
                                child: Image.network(
                                  height: 100,
                                  width: 100,
                                  "${userModel!.profileImage}",
                                  fit: BoxFit.cover,
                                )),
                          ),
                    AppTextField(
                        readonly: true,
                        lable: "Name",
                        textEditingController: nameController),
                    if (userModel!.email != null &&
                        userModel!.email!.isNotEmpty)
                      AppTextField(
                          readonly: true,
                          lable: "Email",
                          textEditingController: emailController),
                    if (userModel!.phoneNumber != null &&
                        userModel!.phoneNumber!.isNotEmpty)
                      AppTextField(
                          readonly: true,
                          lable: "contact",
                          textEditingController: contactController),
                    if (userModel!.birthdate != null &&
                        userModel!.birthdate!.isNotEmpty)
                      AppTextField(
                          readonly: true,
                          lable: "Birth date",
                          textEditingController: birthdateController),
                    if (userModel!.gender != null &&
                        userModel!.gender!.isNotEmpty)
                      AppTextField(
                        readonly: true,
                        lable: "Gender",
                        textEditingController: genderController,
                      ),
                    (user!.photoURL == null)
                        ? AppButton(
                            ontap: () {
                              AuthService().signOutWithEmailPassword(
                                  widget.tabController);

                              appSnackBar(context,
                                  text: "Log out successfully!");
                            },
                            text: StringConstants.logoutButtonText,
                          )
                        : AppButton(
                            ontap: () {
                              AuthService()
                                  .signOutWithGoogle(widget.tabController);
                              appSnackBar(context,
                                  text: "Log out successfully!");
                            },
                            text: StringConstants.logoutGoogleButtonText,
                          )
                  ],
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
