import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/first_page.dart';

import 'common/constants/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GestureDetector(
    onTap: () {
      FocusManager.instance.primaryFocus?.unfocus();
    },
    child: MaterialApp(
      home: const FirstPage(),
      theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(ColorConstants.commonColor))),
          radioTheme: RadioThemeData(
              fillColor: MaterialStateProperty.all(ColorConstants.commonColor)),
          appBarTheme:
              AppBarTheme(backgroundColor: ColorConstants.commonColor)),
      debugShowCheckedModeBanner: false,
    ),
  ));
}
