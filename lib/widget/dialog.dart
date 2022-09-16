import 'package:flutter/material.dart';
import 'package:flutter_demo/service/user_service.dart';

dialog(BuildContext context, String id) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: const Text("Delete Dialog"),
        content: const Text("Do you want to delete this?"),
        actions: [
          ElevatedButton(
              onPressed: () {
                UserService userService = UserService();
                userService.deleteUser(id);
                Navigator.pop(context);
              },
              child: const Text("Yes")),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No")),
        ],
      );
    },
  );
}
