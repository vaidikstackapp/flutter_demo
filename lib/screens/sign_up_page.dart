import 'package:flutter/material.dart';
import 'package:flutter_demo/common/widget/app_text.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          ListView(
            shrinkWrap: true,
            children: const [
              AppText(
                text: "Sign Up",
                fontSize: 20,
              )
            ],
          )
        ],
      ),
    );
  }
}
