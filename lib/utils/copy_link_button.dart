import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CopyLinkButton extends StatelessWidget {
  String value;

  CopyLinkButton({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          Clipboard.setData(ClipboardData(text: value)).then((result) {
            // show toast or snackbar after successfully save
            //TODO Fluttertoast.showToast(msg: "copied");
          });
        },
      ),
    );
  }
}
