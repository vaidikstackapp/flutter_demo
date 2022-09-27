import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/common/widget/app_toast.dart';
import 'package:flutter_demo/service/user_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
        UserModel userModel = UserModel(
          email: email,
          gender: gender,
          birthdate: birthdate,
          name: name,
          phoneNumber: phoneNumber,
          profileImage: "",
          uid: credential.user!.uid,
        );
        await userService.createUser(userModel);
        appToast("Sign up successfully");
      }
      EasyLoading.dismiss();
    } on FirebaseAuthException catch (e) {
      appToast(e.code.toString());

      EasyLoading.dismiss();
    } catch (e) {
      appToast(e.toString());
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

      log("signInWithEmailPassword credential----->${credential.user}");

      if (credential.user != null) {
        log("admin----------->$admin");
        if (admin!) {
          tabController!.animateTo(tabController.index + 1);
        } else {
          tabController!.animateTo(tabController.index + 2);
        }
      }
      EasyLoading.dismiss();
    } on FirebaseAuthException catch (e) {
      appToast(e.code.toString());
      EasyLoading.dismiss();
    } finally {
      EasyLoading.dismiss();
    }
    EasyLoading.dismiss();
  }

  // ===================signInWithGoogle=================//

  Future<UserCredential?> signInWithGoogle(
      TabController tabController, bool isAdmin) async {
    // Trigger the authentication flow
    EasyLoading.show(
        indicator: SpinKitCircle(
      color: ColorConstants.commonColor,
    ));
    try {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: ['profile', 'email']).signIn();
      log("googleUser----->$googleUser");
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        log("googleAuth---->${googleAuth.accessToken}");

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        UserCredential authResult =
            await auth!.signInWithCredential(credential);

        List<UserModel?>? l = await userService.getAllUser();

        log("list length-------->${l!.length}");
        log("current user--------->${auth!.currentUser}");
        UserModel? userModel = l.firstWhere(
          (element) => element!.uid != auth!.currentUser!.uid,
          orElse: () => UserModel(),
        );
        userModel = UserModel(
            uid: auth!.currentUser!.uid,
            name: googleUser.displayName,
            gender: "",
            phoneNumber: "",
            birthdate: "",
            email: googleUser.email,
            profileImage: googleUser.photoUrl);
        userService.createUser(userModel);
        if (isAdmin) {
          tabController.animateTo(tabController.index + 1);
        } else {
          tabController.animateTo(tabController.index + 2);
        }
        return authResult;
      }
      return null;
    } on FirebaseException catch (e) {
      appToast(e.code.toString());
    } finally {
      EasyLoading.dismiss();
    }
    return null;
  }

  signOutWithGoogle(TabController? tabController) async {
    try {
      await googleSignIn.signOut();
      await auth!.signOut();
    } on FirebaseException catch (e) {
      log('Catch exception of signOutWithGoogle : ${e.message}');
      appToast(e.code.toString());
    }
    tabController!.animateTo(tabController.index - 2);
  }

  // ===================signOutWithEmailPassword=================//

  signOutWithEmailPassword(TabController? tabController) async {
    try {
      await auth!.signOut();
    } on FirebaseException catch (e) {
      // TODO
      log('Catch exception of signOutWithEmailPassword : ${e.message}');
      appToast(e.code.toString());
    }
    tabController!.animateTo(tabController.index - 2);
  }

  signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance
        .login(permissions: ['email', 'public_profile']);

    try {
      switch (loginResult.status) {
        case LoginStatus.success:
          {
            final OAuthCredential facebookAuthCredential =
                FacebookAuthProvider.credential(loginResult.accessToken!.token);
            // Once signed in, return the UserCredential
            UserCredential authResult = await FirebaseAuth.instance
                .signInWithCredential(facebookAuthCredential);
            return authResult;
          }
        case LoginStatus.cancelled:
          {
            throw FirebaseAuthException(
                code: 'ERROR_ABORTED_BY_USER',
                message: "error aborted by user");
          }
        case LoginStatus.failed:
          {
            throw FirebaseAuthException(
                code: 'ERROR_FACEBOOK_LOGIN_FAILED',
                message: "error facebook login failed");
          }
        default:
          {
            UnimplementedError();
          }
      }
    } on FirebaseException catch (e) {
      appToast(e.code.toString());
    }
  }

  Future<void> signOut(TabController? tabController) async {
    try {
      EasyLoading.show(
          indicator: SpinKitCircle(
        color: ColorConstants.commonColor,
      ));
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signOut();

      GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      tabController!.animateTo(0);
    } on FirebaseException catch (e) {
      appToast(e.code.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }
}
