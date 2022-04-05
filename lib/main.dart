import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_with_me/controllers/user_state_controller.dart';
import 'package:ride_with_me/pages/initial_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_with_me/models/ride_filter.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:ride_with_me/pages/main_page.dart';
import 'firebase_options.dart';
import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RideFilter(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Ride With Me",
        theme: ThemeData(
          primarySwatch: Colors.teal,
          primaryColorDark: Color(0xFF152F29),
          unselectedWidgetColor: Color(0x5B000000),
          textTheme: GoogleFonts.comfortaaTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        // switch directly to MainPage() is user is signed in?
        // home: FirebaseAuth.instance.currentUser == null ? InitialPage() :
        // ChangeNotifierProvider(create: (_) => UserStateController(user: FirebaseAuth.instance.currentUser), child: MainPage()),
        home: InitialPage(),
      ),
    );
  }
}
