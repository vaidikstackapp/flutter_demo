import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/loginPage.dart';
import 'package:flutter_demo/pages/user_page.dart';

import '../widget/dialog.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 2, vsync: this);


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
             LoginPage(_tabController),
              UserPage(_tabController)
          ]),
    );
  }
}
