import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ride_with_me/pages/main_page.dart';

import '../utils/button.dart';
import '../utils/text_field.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 60, 8, 8),
          child: InputField(placeholder: "Username", isPassword: false),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: InputField(placeholder: "Password", isPassword: true),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: SubmitButton(
              value: "LOG IN",
              callback: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                  (_) => false,
                );
              }),
        ),
      ],
    );

    // TODO we'll need this button type, remove it from here then
    // floatingActionButton: FloatingActionButton(
    //   onPressed: ,
    //   tooltip: 'Increment',
    //   child: const Icon(Icons.add),
    // ), // This trailing comma makes auto-formatting nicer for build methods.
  }
}
