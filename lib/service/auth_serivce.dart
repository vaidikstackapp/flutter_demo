import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/common/constants/constants.dart';
import 'package:flutter_demo/common/utills/shared_preferance.dart';
import 'package:flutter_demo/service/user_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../model/user_model.dart';

class AuthService {
  UserService userService = UserService();
  GoogleSignIn googleSignIn = GoogleSignIn();
  void authentication(
      TextEditingController tEmail,
      TextEditingController tPassword,
      bool isAdmin,
      TabController tabController) async {
    String s = '';
    String admin = '';
    String email = tEmail.text;
    String password = tPassword.text;
    if (kDebugMode) {
      print("email : $email");
    }

    if (isAdmin) {
      admin = 'True';
    } else {
      admin = 'False';
    }
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
            uid: user.uid,
            admin: admin);
        await userService.createUser(userModel);
      }
    } on FirebaseAuthException catch (e) {
      s = e.code;
      if (kDebugMode) {
        print("e code = $s");
      }
      if (e.code == 'weak-password') {
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: "The account already exists for that email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: ColorConstants.errorColor,
            textColor: ColorConstants.textColor,
            fontSize: 16.0);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    if (s != 'email-already-in-use') {
      setPrefBoolValue(isLogin, true);
      if (isAdmin) {
        tabController.animateTo(tabController.index + 1);
      } else {
        tabController.animateTo(tabController.index + 2);
      }
    }
  }

  Future<UserCredential> signInWithGoogle(
      TabController tabController, bool isAdmin) async {
    String admin = '';
    if (isAdmin) {
      admin = 'True';
    } else {
      admin = 'false';
    }

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    GoogleSignInAccount user = googleUser;
    if (user.toString().isNotEmpty) {
      UserModel userModel = UserModel(
          uid: user.id,
          profileImage: user.photoUrl ?? "",
          name: user.displayName,
          email: user.email,
          admin: admin,
          phoneNumber: '');
      //print("UserID = ${userModel.uid}");
      await userService.createUser(userModel);
      //StringConstants.status = true;
    }
    if (isAdmin) {
      tabController.animateTo(tabController.index + 1);
    } else {
      tabController.animateTo(tabController.index + 2);
    }
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    //print('credential :- $credential');
    return userCredential;
  }

  signOutWithGoogle(TabController? tabController) {
    googleSignIn.signOut();
    tabController!.animateTo(tabController.index - 2);
  }

  signOutWithEmailPassword(TabController? tabController) async {
    await FirebaseAuth.instance.signOut();
    tabController!.animateTo(tabController.index - 2);
  }
}
