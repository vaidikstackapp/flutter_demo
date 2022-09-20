import 'package:flutter/material.dart';

class StringConstants {
  static RegExp emailPatten = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static RegExp passPatten = RegExp(
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$");

  static String email = "Email";
  static String password = "Password";
  static String signIn = "Sign in";
  static String signInWithGoogle = " - Sign in with google";
  static String isEmailEmpty = "Enter email";
  static String isPasswordEmpty = "Enter password";
  static String isEmailNotMatch = "Enter valid email";
  static String isPasswordNotMatch = """
Minimum 8 characters, 
at least one uppercase letter, 
one lowercase letter, 
one number and one special character""";
}

class ColorConstants {
  static Color commonColor = const Color(0xff1ba294);
  static Color textColor = Colors.white;
  static Color errorColor = Colors.red;
  static Color borderColor = Colors.black26;
}
