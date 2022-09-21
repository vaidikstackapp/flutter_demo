import 'package:flutter/material.dart';
import 'package:flutter_demo/common/widget/app_text.dart';
import 'package:flutter_demo/screens/single_user.dart';
import 'package:flutter_demo/screens/user_page.dart';

import '../common/constants/color_constant.dart';
import 'login_page.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  bool status = false;

  @override
  void initState() {
    super.initState();
    // checkLogin();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  checkLogin() async {
    // status = getPrefBoolValue(isLogin) ?? false;
    // print("Status : $status");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: "Firebase_demo",
          color: ColorConstants.textColor,
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: IgnorePointer(
            ignoring: false,
            child: TabBar(
                indicatorColor: ColorConstants.textColor,
                controller: _tabController,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.login),
                  ),
                  Tab(
                    icon: Icon(Icons.verified_user),
                  ),
                  Tab(
                    child: Icon(Icons.supervised_user_circle),
                  )
                ]),
          ),
        ),
      ),
      body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            LoginPage(_tabController!),
            UserPage(_tabController!),
            SingleUser(tabController: _tabController),
          ]),
    );
  }
}
