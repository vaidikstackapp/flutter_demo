import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/model/user_model.dart';
import 'package:flutter_demo/widget/dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../common/constants/constants.dart';

// ignore: must_be_immutable
class UserPage extends StatefulWidget {
  TabController tabController;

  UserPage(this.tabController, {super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("users").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitCircle(
                      color: ColorConstants.commonColor,
                    ),
                  );
                } else if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("NO DATA FOUND"),
                  );
                }
                return RawScrollbar(
                  thumbColor: ColorConstants.commonColor,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = snapshot.data!.docs[index];
                      UserModel userModel = UserModel.fromJson(
                          document.data() as Map<String, dynamic>);
                      return ListTile(
                        trailing: IconButton(
                            onPressed: () {
                              dialog(context, document.id);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: ColorConstants.commonColor,
                            )),
                        leading: CircleAvatar(
                            backgroundColor: ColorConstants.commonColor,
                            backgroundImage:
                                (userModel.profileImage.toString().isNotEmpty)
                                    ? NetworkImage('${userModel.profileImage}',
                                        scale: 50)
                                    : NetworkImage(ImageConstants.networkImage,
                                        scale: 20)),
                        title: (userModel.email.toString().isNotEmpty)
                            ? Text("${userModel.email}")
                            : const Text("No Email"),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
