import 'package:flutter/material.dart';

class RideWithMeTitle extends StatelessWidget {
  const RideWithMeTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Ride",
                style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 56),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 80.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "With",
                style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 56),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 80.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Me",
                style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 56),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
