import 'package:flutter/material.dart';
import 'package:flutter_demo/common/widget/app_button.dart';
import 'package:flutter_demo/common/widget/app_text.dart';
import 'package:flutter_demo/common/widget/app_textfield.dart';
import 'package:flutter_demo/service/auth_serivce.dart';
import '../common/constants/constants.dart';
import '../service/user_service.dart';

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  TabController tabController;

  LoginPage(this.tabController, {super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController tEmail = TextEditingController();
  TextEditingController tPassword = TextEditingController();
  TextEditingController tUsername = TextEditingController();
  bool check = false;
  UserService userService = UserService();
  final _formKey = GlobalKey<FormState>();

  bool visible = true;
  bool isAdmin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Center(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                const AppText(
                  text: "Log In Now",
                  color: Colors.black,
                  textAlign: TextAlign.center,
                  fontSize: 25,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: const AppText(
                      text: "please  login to continue using our app",
                      color: Colors.black54,
                      textAlign: TextAlign.center),
                ),
                const SizedBox(
                  height: 20,
                ),
                AppTextField(
                  textEditingController: tEmail,
                  lable: StringConstants.email,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return StringConstants.isEmailEmpty;
                    } else if (!StringConstants.emailPatten.hasMatch(value)) {
                      return StringConstants.isEmailNotMatch;
                    }
                    return null;
                  },
                ),
                AppTextField(
                  textEditingController: tPassword,
                  obscureText: visible,
                  suffixIcon: GestureDetector(
                      onTap: () {
                        visible = !visible;
                        setState(() {});
                      },
                      child: (visible)
                          ? Icon(
                              Icons.visibility_off,
                              size: 18,
                              color: ColorConstants.commonColor,
                            )
                          : Icon(
                              Icons.visibility,
                              size: 18,
                              color: ColorConstants.commonColor,
                            )),
                  lable: "Password",
                  validator: (value) {
                    if (value!.isEmpty) {
                      return StringConstants.isPasswordEmpty;
                    } else if (!StringConstants.passPatten.hasMatch(value)) {
                      return StringConstants.isPasswordNotMatch;
                    }
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppText(text: "Type :", color: Colors.black),
                    Radio(
                      value: false,
                      groupValue: isAdmin,
                      onChanged: (value) {
                        isAdmin = !isAdmin;
                        setState(() {});
                      },
                    ),
                    const AppText(
                      text: "User",
                      color: Colors.black,
                    ),
                    Radio(
                      value: true,
                      groupValue: isAdmin,
                      onChanged: (value) {
                        isAdmin = !isAdmin;
                        //  print("admin : $isAdmin");
                        setState(() {});
                      },
                    ),
                    const AppText(text: "Admin", color: Colors.black),
                  ],
                ),
                AppButton(
                  text: 'sign in',
                  ontap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (_formKey.currentState!.validate()) {
                      AuthService().authentication(
                          tEmail, tPassword, isAdmin, widget.tabController);
                    }
                  },
                ),
                GestureDetector(
                  onTap: () async {
                    AuthService()
                        .signInWithGoogle(widget.tabController, isAdmin);
                  },
                  child: Container(
                    height: 40,
                    width: 160,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                    decoration: BoxDecoration(
                        color: ColorConstants.commonColor,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                              color: ColorConstants.borderColor,
                              offset: const Offset(0, 5),
                              blurRadius: 5),
                        ]),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/google.png",
                          height: 20,
                          width: 20,
                          fit: BoxFit.cover,
                        ),
                        Text(StringConstants.signInWithGoogle,
                            style: TextStyle(color: ColorConstants.textColor)),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      AppText(
                        textAlign: TextAlign.center,
                        color: Colors.black,
                        text: "Don't have and account? ",
                      ),
                      AppText(
                        textAlign: TextAlign.center,
                        color: Colors.blue,
                        text: "Sign up",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder outLineInputBorder({Color? color}) => OutlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          color: color ?? ColorConstants.commonColor,
        ),
      );
}
