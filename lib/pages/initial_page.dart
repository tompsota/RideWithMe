import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sign_up_page.dart';
import 'log_in_page.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({Key? key}) : super(key: key);

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
              tabs: [Tab(text: "Log In"), Tab(text: "Sign Up")],
              labelStyle: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, fontFamily: GoogleFonts.comfortaa().fontFamily),
              unselectedLabelStyle:
                  TextStyle(fontSize: 22.0, fontWeight: FontWeight.normal, fontFamily: GoogleFonts.comfortaa().fontFamily),
              unselectedLabelColor: Color(0x5B000000),
              labelColor: Theme.of(context).primaryColor,
              indicatorWeight: 3,
            )),
        body: const TabBarView(
          children: [
            LogInPage(),
            SignUpPage(),
          ],
        ),
      ),
    );
  }
}
