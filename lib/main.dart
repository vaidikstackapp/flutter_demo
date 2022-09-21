import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/screens/first_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'common/constants/color_constant.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GestureDetector(
    onTap: () {
      FocusManager.instance.primaryFocus?.unfocus();
    },
    child: MaterialApp(
      builder: EasyLoading.init(),
      home: const FirstPage(),
      theme: ThemeData(
          fontFamily: 'Montserrat',
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
