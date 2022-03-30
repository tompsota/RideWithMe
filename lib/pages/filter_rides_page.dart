import 'package:flutter/material.dart';
import 'package:ride_with_me/utils/address_search.dart';
import 'package:ride_with_me/utils/dropdown.dart';
import 'package:ride_with_me/utils/text.dart';
import 'package:ride_with_me/utils/time_picker.dart';
import 'package:ride_with_me/utils/two_way_slider.dart';

class FilterRidesPage extends StatelessWidget {
  FilterRidesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 80,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Container(
            child: Text(
              "Filter Rides",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 36,
              ),
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            MediumText("Time Schedule"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Starts after:"),
                TimePicker(),
                Spacer(),
                Text("Finishes by:"),
                TimePicker(),
              ],
            ),


            SizedBox(height: 20),
            MediumText("Distance"),
            TwoWaySlider(
              span: 120,
            ),


            SizedBox(height: 20),
            MediumText("Duration"),
            TwoWaySlider(
              span: 120,
            ),

            SizedBox(height: 20),
            MediumText("Participants"),
            TwoWaySlider(
              span: 120,
            ),
            AddressSearch(title: "test",),

            Dropdown(),
          ],
        ),
      ),
    );
  }
}
