import 'package:flutter/material.dart';
import 'package:flutter_demo/model/user_model.dart';
import 'package:flutter_demo/service/user_service.dart';
class UserPage extends StatefulWidget {
  TabController tabController;

  UserPage(this.tabController, {super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List getUser = [];
  UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<List<UserModel>?> l = Future.value();
  bool status = false;
  Future<void> getData() async {
    l = userService.getAllUsers();
    getUser = (await l)!;
    setState(() {
      status = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (status)
        ? ListView.builder(
            itemCount: getUser.length,
            itemBuilder: (context, index) {
              UserModel userModel = getUser[index];
              return ListTile(title: Text("${userModel.email}"));
            },
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
    // Expanded(
    //   child: StreamBuilder(
    //     stream: FirebaseFirestore.instance.collection("users").snapshots(),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return const Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       }
    //       return ListView.builder(
    //         itemCount: snapshot.data!.docs.length,
    //         itemBuilder: (context, index) {
    //           DocumentSnapshot document = snapshot.data!.docs[index];
    //           return ListTile(
    //             trailing: IconButton(
    //                 onPressed: () {
    //                   dialog(context, document.id);
    //                 },
    //                 icon: const Icon(Icons.delete)),
    //             title: (document['name'].toString().isNotEmpty)
    //                 ? Text("${document['name']}")
    //                 : const Text("Not Exits"),
    //             leading: CircleAvatar(
    //                 backgroundImage: (document['profileImage']
    //                         .toString()
    //                         .isNotEmpty)
    //                     ? NetworkImage('${document['profileImage']}',
    //                         scale: 50)
    //                     : const NetworkImage(
    //                         'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQNvWDvQb_rCtRL-p_w329CtzHmfzfWP0FIw&usqp=CAU',
    //                         scale: 20)),
    //             subtitle: Text("${document['email']}"),
    //           );
    //         },
    //       );
    //     },
    //   ),
    // ),
    // ElevatedButton(
    //     onPressed: () {
    //       widget.tabController.animateTo(widget.tabController.index - 1);
    //     },
    //     child: const Icon(Icons.navigate_before))
  }
}
