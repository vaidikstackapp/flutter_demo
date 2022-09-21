import 'package:flutter/material.dart';
import 'package:flutter_demo/common/constants/constants.dart';
import 'package:flutter_demo/common/widget/app_text.dart';
import 'package:flutter_demo/service/user_service.dart';

dialog(BuildContext context, String? id) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: const Text("Delete Dialog"),
        content: const Text("Do you want to delete this user?"),
        actions: [
          ElevatedButton(
              onPressed: () {
                UserService userService = UserService();
                userService.deleteUser(id!);
                Navigator.pop(context);
              },
              child: AppText(
                text: "Yes",
                color: ColorConstants.commonColor,
              )),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: AppText(
                text: "No",
                color: ColorConstants.commonColor,
              )),
        ],
      );
    },
  );
}
