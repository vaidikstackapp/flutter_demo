import 'package:flutter/material.dart';
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
  //bool radio2 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return StringConstants.isEmailEmpty;
                    } else if (!StringConstants.emailPatten.hasMatch(value)) {
                      return StringConstants.isEmailNotMatch;
                    }
                    return null;
                  },
                  controller: tEmail,
                  cursorColor: ColorConstants.commonColor,
                  decoration: InputDecoration(
                    label: Text(
                      StringConstants.email,
                      style: TextStyle(color: ColorConstants.commonColor),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorConstants.commonColor,
                      ),
                    ),
                    enabledBorder: outLineInputBorder(),
                    disabledBorder: outLineInputBorder(),
                    focusedBorder: outLineInputBorder(),
                    errorBorder:
                        outLineInputBorder(color: ColorConstants.errorColor),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  obscureText: visible,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return StringConstants.isPasswordEmpty;
                    } else if (!StringConstants.passPatten.hasMatch(value)) {
                      return StringConstants.isPasswordNotMatch;
                    }
                    return null;
                  },
                  controller: tPassword,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          visible = !visible;
                          setState(() {});
                        },
                        icon: (visible)
                            ? Icon(
                                Icons.visibility_off,
                                color: ColorConstants.commonColor,
                              )
                            : Icon(Icons.visibility,
                                color: ColorConstants.commonColor)),
                    label: Text(
                      StringConstants.password,
                      style: TextStyle(
                        color: ColorConstants.commonColor,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorConstants.commonColor,
                      ),
                    ),
                    enabledBorder: outLineInputBorder(),
                    disabledBorder: outLineInputBorder(),
                    focusedBorder: outLineInputBorder(),
                    errorBorder:
                        outLineInputBorder(color: ColorConstants.errorColor),
                  ),
                  cursorColor: ColorConstants.commonColor,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("User Type :-"),
                  Radio(
                    value: false,
                    groupValue: isAdmin,
                    onChanged: (value) {
                      isAdmin = !isAdmin;
                      //print("Normal : $isAdmin");
                      setState(() {});
                    },
                  ),
                  const Text('Normal'),
                  Radio(
                    value: true,
                    groupValue: isAdmin,
                    onChanged: (value) {
                      isAdmin = !isAdmin;
                      //  print("admin : $isAdmin");
                      setState(() {});
                    },
                  ),
                  const Text('Admin'),
                ],
              ),
              ElevatedButton(
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (_formKey.currentState!.validate()) {
                      AuthService().authentication(
                          tEmail, tPassword, isAdmin, widget.tabController);
                    }
                  },
                  child: Text(StringConstants.signIn)),
              InkWell(
                onTap: () async {
                  AuthService().signInWithGoogle(widget.tabController);
                },
                child: Container(
                  height: 40,
                  width: 160,
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
                    children: [
                      Image.asset(
                        "images/google.png",
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
            ],
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
