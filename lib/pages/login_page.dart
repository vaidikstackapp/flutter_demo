import 'package:flutter/material.dart';
import 'package:flutter_demo/common/functions/function.dart';
import 'package:flutter_demo/common/variable/variable.dart';
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

  CommonFuntion commonFuntion = CommonFuntion();
  bool check = false;
  UserService userService = UserService();
  String s = "";

  final _formKey = GlobalKey<FormState>();

  bool visible = true;

  @override
  Widget build(BuildContext context) {
    return Form(
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
                    return "enter username";
                  }
                  return null;
                },
                controller: tUsername,
                cursorColor: const Color(0xff1ba294),
                decoration: InputDecoration(
                    label: const Text(
                      "User Name",
                      style: TextStyle(color: Color(0xff1ba294)),
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff1ba294),
                      ),
                    ),
                    enabledBorder: outLineInputBorder(),
                    disabledBorder: outLineInputBorder(),
                    focusedBorder: outLineInputBorder(),
                    errorBorder: outLineInputBorder(color: Colors.red)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter email";
                  } else if (!Variable.emailPatten.hasMatch(value)) {
                    return "Enter valid email";
                  }
                  return null;
                },
                controller: tEmail,
                cursorColor: const Color(0xff1ba294),
                decoration: InputDecoration(
                  label: const Text(
                    "Email",
                    style: TextStyle(color: Color(0xff1ba294)),
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff1ba294),
                    ),
                  ),
                  enabledBorder: outLineInputBorder(),
                  disabledBorder: outLineInputBorder(),
                  focusedBorder: outLineInputBorder(),
                  errorBorder: outLineInputBorder(color: Colors.red),
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
                    return "enter password";
                  } else if (!Variable.passPatten.hasMatch(value)) {
                    return """
                              Minimum 8 characters, 
                              at least one uppercase letter, 
                              one lowercase letter, 
                              one number and one special character""";
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
                          ? const Icon(
                              Icons.visibility_off,
                              color: Color(0xff1ba294),
                            )
                          : const Icon(Icons.visibility,
                              color: Color(0xff1ba294))),
                  label: const Text(
                    "Password",
                    style: TextStyle(
                      color: Color(0xff1ba294),
                    ),
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff1ba294),
                    ),
                  ),
                  enabledBorder: outLineInputBorder(),
                  disabledBorder: outLineInputBorder(),
                  focusedBorder: outLineInputBorder(),
                  errorBorder: outLineInputBorder(color: Colors.red),
                ),
                cursorColor: const Color(0xff1ba294),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (_formKey.currentState!.validate()) {
                    CommonFuntion().authentication(
                        tEmail, tUsername, tPassword, widget.tabController);
                  }
                },
                child: const Text("Submit")),
            InkWell(
              onTap: () async {
                commonFuntion.signInWithGoogle(widget.tabController);
              },
              child: Container(
                height: 40,
                width: 160,
                decoration: BoxDecoration(
                    color: const Color(0xff1ba294),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 5),
                          blurRadius: 5),
                    ]),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Image.asset(
                      "images/google (1).png",
                      height: 20,
                      width: 20,
                      fit: BoxFit.cover,
                    ),
                    const Text(" - Sign in with google",
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  OutlineInputBorder outLineInputBorder({Color? color}) => OutlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          color: color ?? const Color(0xff1ba294),
        ),
      );
}
