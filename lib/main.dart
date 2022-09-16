import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/first_page.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GestureDetector(
    onTap: () {
      FocusManager.instance.primaryFocus?.unfocus();
    },
    child:   MaterialApp(
      home: const FirstPage(),
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xff1ba294)))),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xff1ba294))
      ),
      debugShowCheckedModeBanner: false,
    ),
  ));
}
