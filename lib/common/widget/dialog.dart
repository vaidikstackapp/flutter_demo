import 'package:flutter/material.dart';
import 'package:flutter_demo/common/widget/app_text.dart';
import 'package:flutter_demo/service/user_service.dart';

import '../constants/color_constant.dart';

dialog(BuildContext context, String? id) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: const AppText(
          text: "Delete Dialog",
          color: Colors.black,
        ),
        content: const AppText(
          text: "Do you want to delete this user?",
          color: Colors.black,
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                UserService userService = UserService();
                userService.deleteUser(id!);
                Navigator.pop(context);
              },
              child: AppText(
                text: "Yes",
                color: ColorConstants.textColor,
              )),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: AppText(
                text: "No",
                color: ColorConstants.textColor,
              )),
        ],
      );
    },
  );
}
