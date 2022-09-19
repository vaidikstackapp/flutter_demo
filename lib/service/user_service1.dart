import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

class UserService1 {
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('user1');

  Future<void> setUser(UserModel userModel) async {
    try {
      await collectionReference.doc(userModel.uid).set(userModel.toJson());
    } on FirebaseException catch (e) {
      print("Catch exception on setUser : $e");
    }
  }
}
