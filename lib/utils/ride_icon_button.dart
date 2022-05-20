import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RideIconButton extends StatelessWidget {
  IconData icon;
  String serviceName;
  String accountLink;

  // TODO: add link to ctor and use it in onPressed
  RideIconButton({Key? key, required this.icon, required this.serviceName, required this.accountLink}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(serviceName + ' Account'),
          content: Text(accountLink),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: accountLink)).then((result) {
                  _showToast(context);
                });
                Navigator.pop(context, 'Copy to Clipboard');
              },
              child: const Text('Copy to Clipboard'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon, color: Colors.white, size: 20.0),
      ),
      style: OutlinedButton.styleFrom(
        shape: CircleBorder(),
        // side: BorderSide(width: 5.0, color: Colors.blue),
      ),
    );
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: const Text('Copied to Clipboard'),
        action: SnackBarAction(label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
