import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_with_me/controllers/ride_filter_controller.dart';
import 'package:ride_with_me/controllers/user_state_controller.dart';
import 'package:ride_with_me/pages/dashboard_page.dart';
import 'package:ride_with_me/pages/profile_page.dart';

import '../models/user_model.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            toolbarHeight: 80,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: TabBar(
              tabs: [Tab(text: "Dashboard"), Tab(text: "Profile")],
              labelStyle: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, fontFamily: GoogleFonts.comfortaa().fontFamily),
              unselectedLabelStyle:
                  TextStyle(fontSize: 22.0, fontWeight: FontWeight.normal, fontFamily: GoogleFonts.comfortaa().fontFamily),
              unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
              labelColor: Theme.of(context).primaryColor,
              indicatorWeight: 3,
            )),
        body: TabBarView(
          children: [
            // ChangeNotifierProvider(
            //   create: (_) => RideFilterController(),
            //   child: DashboardPage(),
            // ),
            // ChangeNotifierProvider.value(value: Provider.of<RideFilterController>(context), child: DashboardPage(),),
            DashboardPage(),
            ProfilePage()
          ],
        ),
      ),
    );
  }
}
