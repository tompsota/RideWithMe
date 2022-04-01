import 'package:flutter/material.dart';
import 'package:ride_with_me/pages/filter_rides_page.dart';
import 'package:ride_with_me/pages/ride_view_page.dart';
import 'package:ride_with_me/utils/button.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SubmitButton(
            value: "Placeholder",
            callback: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RideViewPage()),
              );
            }),
        Spacer(),
        SizedBox(
          width: double.infinity,
          child: SubmitButton(
              value: "FILTER RIDES",
              callback: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FilterRidesPage()),
                );
              }),
        )
      ],
    );
  }
}
