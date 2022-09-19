import 'package:flutter/material.dart';
import 'package:flutter_demo/common/variable/variable.dart';
import 'package:flutter_demo/pages/loginPage.dart';
import 'package:flutter_demo/pages/user_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 2, vsync: this);
  bool status = false;

  @override
  void initState() {
    super.initState();
    checkLogin();
    //print("controller val = ${_tabController.index}");
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  checkLogin() async {
    Variable.preferences = await SharedPreferences.getInstance();
    status = Variable.preferences!.getBool('login') ?? false;
    // print("Status : $status");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase_demo"),
        centerTitle: true,
        bottom: TabBar(
            indicatorColor: Colors.white,
            controller: _tabController,
            tabs: const [
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
            UserPage(_tabController),
            LoginPage(_tabController),
          ]),
    );
  }
}
