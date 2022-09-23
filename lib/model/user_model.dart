// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

List<UserModel> userModelFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  UserModel({
    this.uid,
    this.name,
    this.email,
    this.phoneNumber,
    this.profileImage,
    this.gender,
    this.birthdate,
  });

  String? uid;
  String? name;
  String? email;
  String? phoneNumber;
  String? profileImage;
  String? gender;
  String? birthdate;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      uid: json["uid"],
      name: json["name"],
      email: json["email"],
      phoneNumber: json["phoneNumber"],
      profileImage: json["profileImage"],
      gender: json["gender"],
      birthdate: json["birthdate"]);

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
        "profileImage": profileImage,
        "gender": gender,
        "birthdate": birthdate,
      };
}
