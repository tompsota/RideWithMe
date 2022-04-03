import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_with_me/pages/initial_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_with_me/utils/ride_filter.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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
        // home: InitialPage(),
        home: InitialPage(),
      ),
    );
  }
}
