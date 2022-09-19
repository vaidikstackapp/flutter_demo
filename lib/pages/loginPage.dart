import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/common/functions/function.dart';
import 'package:flutter_demo/common/variable/variable.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../model/user_model.dart';
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

  emaliPassAuth(
    String email,
    String password,
    String userName,
  ) async {
    if (email.isNotEmpty &&
        userName.isNotEmpty &&
        password.isNotEmpty &&
        password.length > 8 &&
        Variable.emailPatten.hasMatch(email) &&
        Variable.passValid.hasMatch(password)) {
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (credential.user != null) {
          User? user = credential.user;
          UserModel userModel = UserModel(
              email: user!.email,
              name: userName,
              phoneNumber: user.phoneNumber ?? "",
              profileImage: user.photoURL ?? "",
              uid: user.uid);
          await userService.createUser(userModel);
        }
      } on FirebaseAuthException catch (e) {
        s = e.code;
        if (e.code == 'weak-password') {
        } else if (e.code == 'email-already-in-use') {
          Fluttertoast.showToast(
              msg: "The account already exists for that email",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
      if (s != 'email-already-in-use') {
        tEmail.clear();
        tPassword.clear();
        tUsername.clear();
        widget.tabController.animateTo(widget.tabController.index + 1);
      }
    }
  }

  bool visible = true;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                    label: const Text("User Name"),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff1ba294),
                      ),
                    ),
                    errorText: (check)
                        ? (tUsername.text.isEmpty)
                            ? "Enter User Name"
                            : null
                        : null),
                controller: tUsername,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                    label: const Text("E-mail"),
                    border: const OutlineInputBorder(),
                    errorText:
                        (check) ? commonFuntion.emailValid(tEmail.text) : null),
                controller: tEmail,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                obscureText: visible,
                decoration: InputDecoration(
                    label: const Text("password"),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                        onPressed: () {
                          visible = !visible;
                          setState(() {});
                        },
                        icon: (visible)
                            ? const Icon(Icons.visibility)
                            : Icon(Icons.visibility_off)),
                    errorText: (check)
                        ? commonFuntion.passwordValid(tPassword.text)
                        : null),
                controller: tPassword,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  String email = tEmail.text;
                  String password = tPassword.text;
                  String userName = tUsername.text;
                  check = true;
                  setState(() {});
                  emaliPassAuth(email, password, userName);
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
}
