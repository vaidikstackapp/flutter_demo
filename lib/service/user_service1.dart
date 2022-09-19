import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../model/user_model.dart';

class UserService1 {
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('user1');

  Future<void> setUser(UserModel userModel, BuildContext context) async {
    try {
      await collectionReference.doc(userModel.uid).set(userModel.toJson());
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Catch exception on setUser : $e");
      }
    }
  }
}
