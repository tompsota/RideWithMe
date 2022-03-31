import 'package:flutter/material.dart';
import 'package:ride_with_me/utils/address_search.dart';
import 'package:ride_with_me/utils/button.dart';
import 'package:ride_with_me/utils/date_picker.dart';
import 'package:ride_with_me/utils/dropdown.dart';
import 'package:ride_with_me/utils/text.dart';
import 'package:ride_with_me/utils/time_picker.dart';
import 'package:ride_with_me/utils/two_way_slider.dart';

//TODO make this scrollable, fix overflows in Time Schedule

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
                Text("Date:"),
                DatePicker(),
                Spacer(),
                Text("Starts after:"),
                TimePicker(),
                Spacer(),
                Text("Finishes by:"),
                TimePicker(),
              ],
            ),

            SizedBox(height: 20),
            MediumText("Start Location"),
            AddressSearch(),

            SizedBox(height: 20),
            MediumText("Distance"),
            TwoWaySlider(
              span: 120,
            ),

            SizedBox(height: 20),
            MediumText("Climbing"),
            TwoWaySlider(
              span: 120,
            ),

            SizedBox(height: 20),
            MediumText("Duration"),
            TwoWaySlider(
              span: 120,
            ),

            SizedBox(height: 20),
            MediumText("Expected average speed"),
            TwoWaySlider(
              span: 120,
            ),

            SizedBox(height: 20),
            MediumText("Participants"),
            TwoWaySlider(
              span: 120,
            ),

            Spacer(),

            SizedBox(
              width: double.infinity,
              child: SubmitButton(context, "APPLY FILTERS"),
            )

            // SizedBox(height: 20),
            // MediumText("Random Dropdown"),
            // Dropdown(),
          ],
        ),
      ),
    );
  }
}
