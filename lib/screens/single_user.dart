import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/common/constants/string_constsnt.dart';
import 'package:flutter_demo/common/widget/app_button.dart';
import 'package:flutter_demo/common/widget/app_snackbar.dart';
import 'package:flutter_demo/common/widget/app_text.dart';
import 'package:flutter_demo/common/widget/app_textfield.dart';
import 'package:flutter_demo/model/user_model.dart';
import 'package:flutter_demo/service/auth_serivce.dart';
import 'package:flutter_demo/service/user_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../common/constants/color_constant.dart';

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
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  bool? checkGender;
  String gender = '';
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  UserModel? userModel;

  Future<void> getCurrentUser() async {
    print("uid------------>${auth.currentUser}");
    if (auth.currentUser!.uid.isNotEmpty) {
      userModel = await userService.getCurrentUser(id: auth.currentUser!.uid);
    }
    //auth.currentUser!.reload();
    nameController.text = userModel!.name!;
    emailController.text = userModel!.email!;
    contactController.text = userModel!.phoneNumber!;
    birthdateController.text = userModel!.birthdate!;
    gender = userModel!.gender!;

    if (gender == 'Male') {
      checkGender = true;
    } else {
      checkGender = false;
    }
    statusCheck = true;
    setState(() {});
  }

  bool readonly = true;

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
                    (userModel!.profileImage != null)
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
                        readonly: readonly,
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
                          readonly: readonly,
                          lable: "contact",
                          textEditingController: contactController),
                    if (userModel!.birthdate != null &&
                        userModel!.birthdate!.isNotEmpty)
                      AppTextField(
                        textEditingController: birthdateController,
                        readonly: true,
                        lable: 'Birthdate',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Select birth date";
                          }
                          return null;
                        },
                        suffixIcon: GestureDetector(
                            onTap: () async {
                              DateTime? pickDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1995),
                                lastDate: DateTime.now(),
                                builder: (context, child) {
                                  return Theme(
                                      data: Theme.of(context).copyWith(
                                          colorScheme: ColorScheme.light(
                                              primary:
                                                  ColorConstants.commonColor)),
                                      child: child!);
                                },
                              );
                              if (pickDate != null) {
                                birthdateController.text =
                                    "${pickDate.day} ${DateFormat.yMMM().format(pickDate)}";
                              }
                              setState(() {});
                            },
                            child: Icon(
                              Icons.calendar_today,
                              color: ColorConstants.commonColor,
                            )),
                      ),
                    if (userModel!.gender != null &&
                        userModel!.gender!.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            text: "Gender :",
                            color: ColorConstants.black,
                          ),
                          Radio(
                            value: true,
                            groupValue: checkGender,
                            onChanged: (value) {
                              checkGender = !checkGender!;
                              gender = "Male";
                              setState(() {});
                            },
                          ),
                          AppText(
                            text: "Male",
                            color: ColorConstants.black,
                          ),
                          Radio(
                            value: false,
                            groupValue: checkGender,
                            onChanged: (value) {
                              checkGender = !checkGender!;
                              gender = "Female";
                              setState(() {});
                            },
                          ),
                          AppText(
                            text: "Female",
                            color: ColorConstants.black,
                          ),
                        ],
                      ),
                    (readonly)
                        ? AppButton(
                            text: "Edit",
                            ontap: () {
                              readonly = false;
                              Fluttertoast.showToast(
                                  msg: "Edit your details",
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red);
                              setState(() {});
                            },
                          )
                        : AppButton(
                            text: "Update",
                            ontap: () {
                              String name = nameController.text;
                              String email = emailController.text;
                              String contact = contactController.text;
                              String birthdate = birthdateController.text;

                              UserModel updateModel = UserModel(
                                  profileImage: "",
                                  gender: gender,
                                  uid: userModel!.uid,
                                  email: email,
                                  name: name,
                                  birthdate: birthdate,
                                  phoneNumber: contact);

                              print(
                                  "updateModel------------------->${updateModel.toJson()}");
                              userService.updateData(
                                  uid: userModel!.uid, userModel: updateModel);
                              readonly = true;
                              //nameController.clear();
                              setState(() {});
                            },
                          ),
                    (userModel!.profileImage != null)
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
                          ),
                  ],
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
