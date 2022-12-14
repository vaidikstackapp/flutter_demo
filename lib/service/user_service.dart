import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_demo/common/constants/color_constant.dart';
import 'package:flutter_demo/common/widget/app_toast.dart';
import 'package:flutter_demo/model/user_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UserService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  //-------------------------------Create User------------------------------------------//
  Future<void> createUser(UserModel userModel) async {
    log('CREATE USER----------->${userModel.toJson()}');
    try {
      await userCollection.doc(userModel.uid).set(userModel.toJson());
    } on FirebaseException catch (e) {
      appToast(e.code.toString());
    }
  }

//-------------------------------Get all user------------------------------------------//
  Future<List<UserModel>?> getAllUser() async {
    try {
      List<UserModel> allUser = [];
      QuerySnapshot snapshot = await userCollection.get();

      for (var document in snapshot.docs) {
        Map<String, dynamic> map = document.data() as Map<String, dynamic>;

        UserModel model = UserModel.fromJson(map);
        allUser.add(model);
      }
      return allUser;
    } on FirebaseException catch (e) {
      log("Catch Exception in getAllUser : ${e.message}");
      appToast(e.code.toString());

      return null;
    }
  }

//-------------------------------Get current user------------------------------------------//
  Future<UserModel?> getCurrentUser({String? id}) async {
    UserModel? userModel;
    // print("getCurrentUser id---------->$id");
    try {
      DocumentSnapshot? doc = await userCollection.doc(id).get();

      if (doc.data() != null) {
        userModel = UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return userModel;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Catch Exception in getCurrentUser : ${e.message}");
        appToast(e.code.toString());
      }
      return null;
    }
  }

//-------------------------------delete User------------------------------------------//
  Future<void> deleteUser(String? id) async {
    try {
      await userCollection.doc(id).delete();
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Catch Exception in deleteUser : ${e.message}");
        appToast(e.code.toString());
      }
    }
  }

  Future<void> updateData({String? uid, UserModel? userModel}) async {
    try {
      EasyLoading.show(
          indicator: SpinKitCircle(
        color: ColorConstants.commonColor,
      ));
      Map<String, dynamic> map = userModel!.toJson();
      log("userMap------------->$map");
      await userCollection.doc(uid).update(map);
      appToast('Update Successfully');
    } on FirebaseException catch (e) {
      log("Catch exception upDateData-------->${e.code}");
      appToast(e.code.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }
}
