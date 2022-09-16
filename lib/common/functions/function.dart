import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/material/tab_controller.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../model/user_model.dart';
import '../../service/user_service.dart';

class CommonFuntion{
  RegExp emailPatten = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  RegExp passValid = RegExp(
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$");
  bool check = false;

  passwordValid(String password) {
    if (password.isEmpty) {
      return "Enter password";
    } else if (!passValid.hasMatch(password)) {
      return """
      Minimum 8 characters, 
      at least one uppercase letter, 
      one lowercase letter, 
      one number and one special character""";
    } else {
      return null;
    }
  }

  emailValid(String email) {
    if (email.isEmpty) {
      return "Enter email";
    } else if (!emailPatten.hasMatch(email)) {
      return "Enter valid email";
    } else {
      return null;
    }
  }

  UserService userService = UserService();

  Future<UserCredential> signInWithGoogle(TabController tabController) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
    await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    GoogleSignInAccount user = googleUser;
    UserModel userModel = UserModel(
        uid: user.id,
        profileImage: user.photoUrl ?? "",
        name: user.displayName,
        email: user.email,
        phoneNumber: "");
    userService.createUser(userModel);
     tabController.animateTo(tabController.index + 1);
    UserCredential userCredential =
    await FirebaseAuth.instance.signInWithCredential(credential);
    return userCredential;
  }

}