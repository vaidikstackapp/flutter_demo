import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/model/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  //-------------------------------Create User------------------------------------------//
  Future<void> createUser(UserModel userModel) async {
    try {
      await userCollection.doc(userModel.uid).set(userModel.toJson());
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Catch Exception in createUser : ${e.message}");
      }
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
      print("Catch Exception in getAllUser : ${e.message}");

      return null;
    }
  }

//-------------------------------Get current user------------------------------------------//
  Future<UserModel?> getCurrentUser({String? id}) async {
    UserModel? userModel;
    print("getCurrentUser id---------->$id");
    try {
      DocumentSnapshot? doc = await userCollection.doc(id).get();

      if (doc.data() != null) {
        userModel = UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return userModel;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Catch Exception in getCurrentUser : ${e.message}");
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
      }
    }
  }

  Future<void> updateData({String? uid, UserModel? userModel}) async {
    try {
      Map<String, dynamic> map = userModel!.toJson();
      print("userMap------------->$map");
      await userCollection.doc(uid).update(map);
      Fluttertoast.showToast(
          msg: "Update Successfully",
          backgroundColor: Colors.red,
          gravity: ToastGravity.CENTER);
    } on FirebaseException catch (e) {
      print("Catch exception upDateData-------->${e.code}");
    }
  }
}
