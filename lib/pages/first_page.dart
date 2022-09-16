import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/model/user_model.dart';
import 'package:flutter_demo/service/user_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../widget/dialog.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 2, vsync: this);
  TextEditingController tEmail = TextEditingController();
  TextEditingController tPassword = TextEditingController();

  RegExp emailPatten = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  RegExp passValid = RegExp(
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$");
  bool check = false;

  passwordValid() {
    String password = tPassword.text;
    if (password.isEmpty) {
      return "Enter Password";
    } else if (!passValid.hasMatch(password)) {
      return "Enter Valid Password";
    } else {
      return null;
    }
  }

  emailValid() {
    String email = tEmail.text;
    if (email.isEmpty) {
      return "Enter Email";
    } else if (!emailPatten.hasMatch(email)) {
      return "Enter Valid Email";
    } else {
      return null;
    }
  }

  UserService userService = UserService();

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    GoogleSignInAccount user = googleUser;
    UserModel userModel = UserModel(
        uid: user.id,
        profileImage: user.photoUrl ?? "",
        name: user.displayName,
        email: user.email,
        phoneNumber: "");
    userService.createUser(userModel);
    _tabController.animateTo(_tabController.index + 1);
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return userCredential;
  }

  emaliPassAuth(String email, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //print("UID : ${credential.user}");

      if (credential.user != null) {
        User? user = credential.user;
        UserModel userModel = UserModel(
            email: user!.email,
            name: user.displayName ?? "",
            phoneNumber: user.phoneNumber ?? "",
            profileImage: user.photoURL ?? "",
            uid: user.uid);
        await userService.createUser(userModel);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: "The account already exists for that email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        tEmail.clear();
        tPassword.clear();
      }
    } catch (e) {
      //print(e);
    }
    tEmail.clear();
    tPassword.clear();
    _tabController.animateTo(_tabController.index + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase_demo"),
        centerTitle: true,
        bottom: TabBar(controller: _tabController, tabs: const [
          Tab(
            icon: Icon(Icons.login),
          ),
          Tab(
            icon: Icon(Icons.verified_user),
          ),
        ]),
      ),
      body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                            label: const Text("E-mail"),
                            border: const OutlineInputBorder(),
                            errorText: (check) ? emailValid() : null),
                        controller: tEmail,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        maxLength: 8,
                        decoration: InputDecoration(
                            label: const Text("password"),
                            border: const OutlineInputBorder(),
                            errorText: (check) ? passwordValid() : null),
                        controller: tPassword,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          String email = tEmail.text;
                          String password = tPassword.text;
                          check = true;
                          setState(() {});
                          if (email.isNotEmpty &&
                              password.isNotEmpty &&
                              emailPatten.hasMatch(email) &&
                              passValid.hasMatch(password)) {
                            check = false;
                            emaliPassAuth(email, password);
                          }
                        },
                        child: const Text("Submit")),
                    InkWell(
                      onTap: () async {
                        signInWithGoogle();
                        //await FirebaseAuth.instance.signOut();
                      },
                      child: Container(
                        height: 50,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    'https://onymos.com/wp-content/uploads/2020/10/google-signin-button.png'))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document =
                              snapshot.data!.docs[index];
                          return ListTile(
                            trailing: IconButton(
                                onPressed: () {

                                  dialog(context,document.id);
                                },
                                icon: const Icon(Icons.delete)),
                            title: (document['name'].toString().isNotEmpty)
                                ? Text("${document['name']}")
                                : const Text("Not Exits"),
                            leading: CircleAvatar(
                                backgroundImage: (document['profileImage']
                                        .toString()
                                        .isNotEmpty)
                                    ? NetworkImage(
                                        '${document['profileImage']}',
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
                      _tabController.animateTo(_tabController.index - 1);
                    },
                    child: const Icon(Icons.navigate_before)),
                // Expanded(
                //   child: StreamBuilder(
                //     stream: userService.getAllUsers().asStream(),
                //     builder: (context, snapshot) {
                //       List<UserModel>? l = snapshot.data;
                //       if (snapshot.connectionState == ConnectionState.waiting) {
                //         return const Center(child: CircularProgressIndicator());
                //       }
                //       return ListView.builder(
                //         itemCount: l!.length,
                //         itemBuilder: (context, index) {
                //           UserModel userModel = l[index];
                //           return ListTile(
                //             title: Text('${userModel.email}'),
                //           );
                //         },
                //       );
                //     },
                //   ),
                // )
              ],
            ),
          ]),
    );
  }
}


