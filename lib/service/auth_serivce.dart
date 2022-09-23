import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  FirebaseAuth? auth = FirebaseAuth.instance;

  // ===================signUpWithEmailPassword=================//

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
      final credential = await auth!.createUserWithEmailAndPassword(
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
  }

  // ===================signInWithEmailPassword=================//

  Future<void> signInWithEmailPassword(
      TextEditingController tEmail, TextEditingController tPassword,
      {TabController? tabController,
      String? email,
      String? password,
      bool? admin}) async {
    try {
      EasyLoading.show(
          indicator: SpinKitCircle(
        color: ColorConstants.commonColor,
      ));
      final credential = await auth!
          .signInWithEmailAndPassword(email: email!, password: password!);
      if (kDebugMode) {
        print(
            "signInWithEmailPassword credential======================>${credential.user}");
      }

      if (credential.user != null) {
        print("admin===============>${admin}");
        // if (admin!) {
        //   tabController!.animateTo(tabController.index + 2);
        // }
        // else {
        tabController!.animateTo(tabController.index + 2);
        //}
      }
      EasyLoading.dismiss();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        if (kDebugMode) {
          print('No user found for that email.');
        }
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

  // ===================signInWithGoogle=================//

  Future<UserCredential> signInWithGoogle(
      TabController tabController, bool isAdmin) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // print("idToken --> ${auth.currentUser!.uid}");
    if (googleUser != null && auth!.currentUser != null) {
      // print("google User===================>${googleUser.id}");
      UserModel userModel = UserModel(
        phoneNumber: '',
        birthdate: '',
        name: googleUser.displayName,
        email: googleUser.email,
        uid: auth!.currentUser!.uid,
        gender: '',
        profileImage: googleUser.photoUrl,
      );
      UserService().createUser(userModel);
      if (isAdmin) {
        tabController.animateTo(tabController.index + 1);
      } else {
        tabController.animateTo(tabController.index + 2);
      }
    }

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  signOutWithGoogle(TabController? tabController) {
    googleSignIn.signOut();
    tabController!.animateTo(tabController.index - 2);
  }

  // ===================signOutWithEmailPassword=================//

  signOutWithEmailPassword(TabController? tabController) async {
    await auth!.signOut();
    tabController!.animateTo(tabController.index - 2);
  }
}
