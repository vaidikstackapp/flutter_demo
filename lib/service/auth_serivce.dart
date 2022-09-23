import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/common/utills/shared_preferance.dart';
import 'package:flutter_demo/service/user_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../common/constants/color_constant.dart';
import '../model/user_model.dart';

class AuthService {
  UserService userService = UserService();
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseAuth auth = FirebaseAuth.instance;

  void signUpWithEmailPassword(
      {String? email,
      String? password,
      String? name,
      String? gender,
      String? birthdate,
      String? phoneNumber,
      TabController? tabController}) async {
    String s = '';
    if (kDebugMode) {
      print("email : $email");
    }

    try {
      EasyLoading.show(
          indicator: SpinKitCircle(
        color: ColorConstants.commonColor,
      ));
      final credential = await auth.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      if (credential.user != null) {
        User? user = credential.user;
        UserModel userModel = UserModel(
          email: user!.email,
          gender: gender,
          birthdate: birthdate,
          name: name,
          phoneNumber: phoneNumber,
          profileImage: user.photoURL ?? "",
          uid: user.uid,
        );
        await userService.createUser(userModel);
      }
      EasyLoading.dismiss();
    } on FirebaseAuthException catch (e) {
      s = e.code;
      if (kDebugMode) {
        print("authentication======================>$s");
      }
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
      EasyLoading.dismiss();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    EasyLoading.dismiss();
    // if (s == 'network-request-failed') {
    //   Fluttertoast.showToast(
    //       msg: "network require",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.CENTER,
    //       timeInSecForIosWeb: 1,
    //       backgroundColor: ColorConstants.errorColor,
    //       textColor: ColorConstants.textColor,
    //       fontSize: 16.0);
    // } else if (s != 'email-already-in-use') {
    //   setPrefBoolValue(isLogin, true);
    //   if (isAdmin) {
    //     tabController.animateTo(tabController.index + 1);
    //   } else {
    //     tabController.animateTo(tabController.index + 2);
    //   }
    // }
  }

  Future<void> signInWithEmailPassword(
      TextEditingController tEmail, TextEditingController tPassword,
      {TabController? tabController, String? email, String? password}) async {
    try {
      EasyLoading.show(
          indicator: SpinKitCircle(
        color: ColorConstants.commonColor,
      ));
      final credential = await auth.signInWithEmailAndPassword(
          email: email!, password: password!);
      print(
          "signInWithEmailPassword credential======================>${credential.user}");

      if (credential.user != null) {
        tabController!.animateTo(tabController.index + 2);
      }
      EasyLoading.dismiss();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        Fluttertoast.showToast(
            msg: "No user found for that email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: ColorConstants.errorColor,
            textColor: ColorConstants.textColor,
            fontSize: 16.0);
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(
            msg: "wrong-password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: ColorConstants.errorColor,
            textColor: ColorConstants.textColor,
            fontSize: 16.0);
      }
      EasyLoading.dismiss();
    }
    EasyLoading.dismiss();
  }

  Future<UserCredential> signInWithGoogle(
      TabController tabController, bool isAdmin) async {
    //String admin = '';
    if (isAdmin) {
      // admin = 'True';
    } else {
      // admin = 'False';
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
          phoneNumber: '');
      await userService.createUser(userModel);
    }
    if (isAdmin) {
      tabController.animateTo(tabController.index + 1);
    } else {
      tabController.animateTo(tabController.index + 2);
    }
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return userCredential;
  }

  signOutWithGoogle(TabController? tabController) {
    googleSignIn.signOut();
    tabController!.animateTo(tabController.index - 2);
  }

  signOutWithEmailPassword(TabController? tabController) async {
    await auth.signOut();
    tabController!.animateTo(tabController.index - 2);
  }
}
