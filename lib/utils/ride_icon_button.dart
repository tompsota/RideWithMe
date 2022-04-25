import 'package:flutter/material.dart';

class RideIconButton extends StatelessWidget {
  IconData icon;

  // TODO: add link to ctor and use it in onPressed
  RideIconButton({Key? key, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
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
}
