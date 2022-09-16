import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/widget/dialog.dart';

// ignore: must_be_immutable
class UserPage extends StatefulWidget {
  TabController tabController;
  UserPage(this. tabController, {super.key});


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
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = snapshot.data!.docs[index];
                  return ListTile(
                    trailing: IconButton(
                        onPressed: () {
                          dialog(context, document.id);
                        },
                        icon: const Icon(Icons.delete)),
                    title: (document['name']
                        .toString()
                        .isNotEmpty)
                        ? Text("${document['name']}")
                        : const Text("Not Exits"),
                    leading: CircleAvatar(
                        backgroundImage: (document['profileImage']
                            .toString()
                            .isNotEmpty)
                            ? NetworkImage('${document['profileImage']}',
                            scale: 50)
                            : const NetworkImage(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQNvWDvQb_rCtRL-p_w329CtzHmfzfWP0FIw&usqp=CAU',
                            scale: 20)),
                    subtitle: Text("${document['email']}"),
                  );
                },
              );
            },
          ),
        ),
        ElevatedButton(
            onPressed: () {
              widget.tabController!.animateTo(widget.tabController!.index - 1);
            },
            child: const Icon(Icons.navigate_before))
      ],
    );
  }
}
