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

  CommonFuntion commonFuntion = CommonFuntion();
  bool check = false;
  UserService userService = UserService();
  String s = "";

  emaliPassAuth(String email, String password) async {
    if (email.isNotEmpty &&
        password.isNotEmpty &&
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
              name: user.displayName ?? "",
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
      tEmail.clear();
      tPassword.clear();
      if (s != 'email-already-in-use') {
        widget.tabController.animateTo(widget.tabController.index + 1);
        Variable.preferences!.setBool('login', true);
      }
    }
  }

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
                maxLength: 8,
                decoration: InputDecoration(
                    label: const Text("password"),
                    border: const OutlineInputBorder(),
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
                  check = true;
                  setState(() {});
                  emaliPassAuth(email, password);
                },
                child: const Text("Submit")),
            InkWell(
              onTap: () async {
                commonFuntion.signInWithGoogle(widget.tabController);
                //await FirebaseAuth.instance.signOut();
              },
              child: Container(
                height: 50,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://onymos.com/wp-content/uploads/2020/10/google-signin-button.png'))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
