import 'package:flutter/material.dart';
import 'package:flutter_demo/common/widget/app_button.dart';
import 'package:flutter_demo/common/widget/app_text.dart';
import 'package:flutter_demo/common/widget/app_textfield.dart';
import 'package:flutter_demo/service/auth_serivce.dart';
import 'package:intl/intl.dart';
import '../common/constants/color_constant.dart';
import '../common/constants/string_constsnt.dart';
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
  TextEditingController emailController = TextEditingController();
  TextEditingController tPassword = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController conformPasswordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController datePickerController = TextEditingController();
  bool check = false;
  UserService userService = UserService();
  final _loginKey = GlobalKey<FormState>();
  final _signUp = GlobalKey<FormState>();

  bool visible = true;
  bool visible1 = true;
  bool visible2 = true;
  bool isAdmin = false;
  bool signUp = false;
  bool gender = true;

  AuthService service = AuthService();

  String genderStore = 'Male';

  @override
  Widget build(BuildContext context) {
    return (signUp)
        ? Scaffold(
            body: Form(
              key: _signUp,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Center(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      AppText(
                        textAlign: TextAlign.center,
                        text: "Sign Up Now",
                        color: ColorConstants.black,
                        fontSize: 20,
                      ),
                      AppText(
                        textAlign: TextAlign.center,
                        text: "Please fill the details and create account",
                        color: ColorConstants.black,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AppTextField(
                        lable: 'Name',
                        textEditingController: userNameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter name";
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            text: "Gender :",
                            color: ColorConstants.black,
                          ),
                          Radio(
                            value: true,
                            groupValue: gender,
                            onChanged: (value) {
                              gender = !gender;
                              genderStore = "Male";
                              setState(() {});
                            },
                          ),
                          AppText(
                            text: "Male",
                            color: ColorConstants.black,
                          ),
                          Radio(
                            value: false,
                            groupValue: gender,
                            onChanged: (value) {
                              gender = !gender;
                              genderStore = "Female";
                              setState(() {});
                            },
                          ),
                          AppText(
                            text: "Female",
                            color: ColorConstants.black,
                          ),
                        ],
                      ),
                      AppTextField(
                        textEditingController: emailController,
                        lable: StringConstants.email,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return StringConstants.isEmailEmpty;
                          } else if (!StringConstants.emailPatten
                              .hasMatch(value)) {
                            return StringConstants.isEmailNotMatch;
                          }
                          return null;
                        },
                      ),
                      AppTextField(
                        textEditingController: contactController,
                        textInputType: TextInputType.phone,
                        lable: StringConstants.phoneNumber,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter phone number";
                          } else if (!StringConstants.phonePatten
                              .hasMatch(value)) {
                            return "Enter correct phone number";
                          }
                          return null;
                        },
                      ),
                      AppTextField(
                        textEditingController: datePickerController,
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
                                datePickerController.text =
                                    "${pickDate.day} ${DateFormat.yMMM().format(pickDate)}";
                              }
                              setState(() {});
                            },
                            child: Icon(
                              Icons.calendar_today,
                              color: ColorConstants.commonColor,
                            )),
                      ),
                      AppTextField(
                        textEditingController: passwordController,
                        obscureText: visible1,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return StringConstants.isPasswordEmpty;
                          } else if (!StringConstants.passPatten
                              .hasMatch(value)) {
                            return StringConstants.isPasswordNotMatch;
                          }
                          return null;
                        },
                        suffixIcon: GestureDetector(
                            onTap: () {
                              visible1 = !visible1;
                              setState(() {});
                            },
                            child: (visible1)
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
                      ),
                      AppTextField(
                        textEditingController: conformPasswordController,
                        obscureText: visible2,
                        suffixIcon: GestureDetector(
                            onTap: () {
                              visible2 = !visible2;
                              setState(() {});
                            },
                            child: (visible2)
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
                        lable: "Conform password",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return StringConstants.isPasswordEmpty;
                          } else if (passwordController.text != value) {
                            return 'Enter correct password';
                          }
                          return null;
                        },
                      ),
                      AppButton(
                        ontap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (_signUp.currentState!.validate()) {
                            genderStore = "Male";
                            // signUp = false;
                            // visible1 = true;
                            // visible2 = true;
                            // gender = true;
                            // userNameController.clear();
                            // emailController.clear();
                            // contactController.clear();
                            // datePickerController.clear();
                            // passwordController.clear();
                            // conformPasswordController.clear();

                            String name = userNameController.text;
                            String email = emailController.text;
                            String password = passwordController.text;
                            String birthdate = datePickerController.text;
                            String phoneNumber = contactController.text;

                            service.signUpWithEmailPassword(
                                gender: genderStore,
                                name: name,
                                email: email,
                                password: password,
                                tabController: widget.tabController,
                                birthdate: birthdate,
                                phoneNumber: phoneNumber);
                            signUp = false;
                          }
                          setState(() {});
                        },
                        text: 'sign up',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            body: Form(
              key: _loginKey,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Center(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      AppText(
                        text: "Log In Now",
                        color: ColorConstants.black,
                        textAlign: TextAlign.center,
                        fontSize: 25,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: AppText(
                            text: "please login to continue using our app",
                            color: ColorConstants.black,
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
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(text: "Type :", color: ColorConstants.black),
                          Radio(
                            value: false,
                            groupValue: isAdmin,
                            onChanged: (value) {
                              isAdmin = !isAdmin;
                              setState(() {});
                            },
                          ),
                          AppText(
                            text: "User",
                            color: ColorConstants.black,
                          ),
                          Radio(
                            value: true,
                            groupValue: isAdmin,
                            onChanged: (value) {
                              isAdmin = !isAdmin;
                              setState(() {});
                            },
                          ),
                          AppText(text: "Admin", color: ColorConstants.black),
                        ],
                      ),
                      AppButton(
                        text: 'sign in',
                        ontap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (_loginKey.currentState!.validate()) {
                            String email = tEmail.text;
                            String password = tPassword.text;
                            service.signInWithEmailPassword(tEmail, tPassword,
                                tabController: widget.tabController,
                                email: email,
                                password: password);
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
                          margin: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 5),
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
                                  style: TextStyle(
                                      color: ColorConstants.textColor)),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          signUp = true;
                          tEmail.clear();
                          tPassword.clear();
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppText(
                                textAlign: TextAlign.center,
                                color: ColorConstants.black,
                                text: "Don't have and account? ",
                              ),
                              AppText(
                                textAlign: TextAlign.center,
                                color: ColorConstants.commonColor,
                                text: "Sign up",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
