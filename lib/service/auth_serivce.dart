import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/common/widget/app_toast.dart';
import 'package:flutter_demo/service/user_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
        appToast("Sign up successfully");
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
        appToast("The account already exists for that email");
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
        print("signInWithEmailPassword credential----->${credential.user}");
      }

      if (credential.user != null) {
        print("admin----------->$admin");
        if (admin!) {
          tabController!.animateTo(tabController.index + 1);
        } else {
          tabController!.animateTo(tabController.index + 2);
        }
      }
      EasyLoading.dismiss();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        appToast("No user found for that email");
      } else if (e.code == 'wrong-password') {
        appToast("wrong-password");
      }
      EasyLoading.dismiss();
    } finally {
      EasyLoading.dismiss();
    }
    EasyLoading.dismiss();
  }

  // ===================signInWithGoogle=================//

  Future<UserCredential> signInWithGoogle(
      TabController tabController, bool isAdmin) async {
    // Trigger the authentication flow
    // EasyLoading.show(
    //     indicator: SpinKitCircle(
    //   color: ColorConstants.commonColor,
    // ));
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // print("CURRENT--------->${auth!.currentUser!.uid}");

        List<UserModel?>? l = await userService.getAllUser();

        if (l != null) {
          UserModel? userModel = l.firstWhere(
            (element) => element!.uid != auth!.currentUser!.uid,
            orElse: () => UserModel(),
          );
          print("Goggle_user_model---->${userModel!.toJson()}");
          UserService().createUser(UserModel(
              uid: auth!.currentUser!.uid,
              name: googleUser.displayName,
              gender: "",
              phoneNumber: "",
              birthdate: "",
              email: googleUser.email,
              profileImage: googleUser.photoUrl));
        }
        if (isAdmin) {
          tabController.animateTo(tabController.index + 1);
        } else {
          tabController.animateTo(tabController.index + 2);
        }
        return await FirebaseAuth.instance.signInWithCredential(credential);
      } else {
        throw FirebaseAuthException(
            code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
            message: 'missing google id token');
      }
    } else {
      throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER', message: "sign in aborted by user");
    }
  }

  signOutWithGoogle(TabController? tabController) async {
    try {
      await googleSignIn.signOut();
      await auth!.signOut();
    } on FirebaseException catch (e) {
      print('Cath exception of signOutWithGoogle : ${e.message}');
    }
    tabController!.animateTo(tabController.index - 2);
  }

  // ===================signOutWithEmailPassword=================//

  signOutWithEmailPassword(TabController? tabController) async {
    await auth!.signOut();
    //tabController!.animateTo(tabController.index - 2);
  }
}
