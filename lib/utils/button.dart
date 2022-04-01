import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

TextButton SubmitButton(BuildContext context, String value) {
  return TextButton(
    child: Text(
      value,
      style: TextStyle(fontSize: 16.0),
    ),
    style: TextButton.styleFrom(
      primary: Colors.white,
      backgroundColor: Theme.of(context).primaryColor,
      padding: EdgeInsets.symmetric(horizontal: 40),
      minimumSize: Size(100, 55),
      // textStyle:
    ),
    onPressed: () {},
  );
}

Widget CopyLinkButton(BuildContext context, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: OutlinedButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 16.0, fontFamily: GoogleFonts.ptMono().fontFamily),
          ),
          Icon(
            Icons.content_copy,
            color: Colors.grey,
            // size: 30.0,
          ),
        ],
      ),
      style: OutlinedButton.styleFrom(
        primary: Colors.black87,
        backgroundColor: Colors.white,
        padding: EdgeInsets.all(20),
        // textStyle:
      ),
      onPressed: () {
        Clipboard.setData(ClipboardData(text: "Add your text to copy")).then((result) {
          // show toast or snackbar after successfully save
          //TODO Fluttertoast.showToast(msg: "copied");
        });
      },
    ),
  );
}
