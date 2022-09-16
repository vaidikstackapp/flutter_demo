import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/widget/dialog.dart';

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
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("users").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xff1ba294),),
                );
              }
              return ListView.builder(physics: BouncingScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = snapshot.data!.docs[index];

                  print("Document : ${document['name']}");
                  return ListTile(
                    trailing: IconButton(
                        onPressed: () {
                          dialog(context, document.id);
                        },
                        icon: const Icon(Icons.delete)),
                    title:
                      Text("${document['name']}"),
                    leading: CircleAvatar(
                        backgroundImage: (document['profileImage']
                                .toString()
                                .isNotEmpty)
                            ? NetworkImage('${document['profileImage']}',
                                scale: 50)
                            : const NetworkImage(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQNvWDvQb_rCtRL-p_w329CtzHmfzfWP0FIw&usqp=CAU',
                                scale: 20)),
                    subtitle: (document['email'].toString().isNotEmpty) ? Text("${document['email']}") : const Text("No Email"),
                  );
                },
              );
            },
          ),
        ),
        ElevatedButton(
            onPressed: () {
              widget.tabController.animateTo(widget.tabController.index - 1);
            },
            child: const Icon(Icons.navigate_before))
      ],
    );
  }
}
