import 'package:flutter/material.dart';

import '../utils/button.dart';
import '../utils/text_field.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 60, 8, 8),
          child: InputField(placeholder: "Email", isPassword: false),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: InputField(placeholder: "Username", isPassword: false),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: InputField(placeholder: "Password", isPassword: true),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: SubmitButton(value: "SIGN UP", callback: () {}),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("By signing up, you agree to Ride With Me’s Terms of Service and Privacy Policy."),
        )
      ],
    );
  }
}
