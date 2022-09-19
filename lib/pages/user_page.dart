import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/model/user_model.dart';
import 'package:flutter_demo/widget/dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
                  return const Center(
                    child: SpinKitCircle(
                      color: Color(0xff1ba294),
                    ),
                  );
                }
                return RawScrollbar(
                  thumbColor: const Color(0xff1ba294),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = snapshot.data!.docs[index];
                      UserModel userModel = UserModel.fromJson(
                          document.data() as Map<String, dynamic>);
                      // print("document : $document");
                      //print("Document : ${document['name']}");
                      return ListTile(
                        trailing: IconButton(
                            onPressed: () {
                              dialog(context, document.id);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Color(0xff1ba294),
                            )),
                        title: Text("${userModel.name}"),
                        leading: CircleAvatar(
                            backgroundColor: const Color(0xff1ba294),
                            backgroundImage: (userModel.profileImage
                                    .toString()
                                    .isNotEmpty)
                                ? NetworkImage('${userModel.profileImage}',
                                    scale: 50)
                                : const NetworkImage(
                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQNvWDvQb_rCtRL-p_w329CtzHmfzfWP0FIw&usqp=CAU',
                                    scale: 20)),
                        subtitle: (userModel.email.toString().isNotEmpty)
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff1ba294),
        onPressed: () {
          widget.tabController.animateTo(widget.tabController.index - 1);
        },
        child: const Icon(
          Icons.navigate_before,
          //color: Color(0xff1ba294),
        ),
      ),
    );
  }
}
