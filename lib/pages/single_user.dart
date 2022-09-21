import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/common/constants/constants.dart';
import 'package:flutter_demo/service/auth_serivce.dart';
import 'package:flutter_demo/service/user_service.dart';

// ignore: must_be_immutable
class SingleUser extends StatefulWidget {
  TabController? tabController;
  String? uid;

  SingleUser({super.key, this.tabController});

  @override
  State<SingleUser> createState() => _SingleUserState();
}

class _SingleUserState extends State<SingleUser> {
  bool status = false;
  User? user;
  UserService userService = UserService();

  @override
  void initState() {
    super.initState();

    FirebaseAuth auth = FirebaseAuth.instance;
    user = auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            (user?.photoURL == null)
                ? CircleAvatar(
                    backgroundImage: NetworkImage(ImageConstants.networkImage),
                    radius: 50,
                    backgroundColor: ColorConstants.commonColor,
                  )
                : CircleAvatar(
                    backgroundImage: NetworkImage('${user!.photoURL}'),
                  ),
            (user!.email == null)
                ? const Text(
                    "Email : No email found",
                    style: TextStyle(fontSize: 20),
                  )
                : Text("Email : ${user!.email}",
                    style: const TextStyle(fontSize: 18)),
            (user!.photoURL == null)
                ? ElevatedButton(
                    onPressed: () {
                      AuthService()
                          .signOutWithEmailPassword(widget.tabController);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(StringConstants.snackBarText)));
                    },
                    child: Text(StringConstants.logoutButton))
                : ElevatedButton(
                    onPressed: () {
                      AuthService().signOutWithGoogle(widget.tabController);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(StringConstants.snackBarText)));
                    },
                    child: Text(StringConstants.logoutGoogleButton)),
          ],
        ),
      ),
    );
  }
}
