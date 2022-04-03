import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_with_me/utils/address_search.dart';
import 'package:ride_with_me/utils/button.dart';
import 'package:ride_with_me/utils/date_picker.dart';
import 'package:ride_with_me/models/ride_filter.dart';
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
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Filter Rides",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Theme.of(context).unselectedWidgetColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MediumText("Time Schedule"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // TODO tu sa nejak nevedia zrovnat, date je vypaddovany, idk why
                  Expanded(
                    child: Text("Date:"),
                  ),
                  Expanded(
                    child: DatePicker(callback: (date) => Provider.of<RideFilter>(context, listen: false).updateDate(date)),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(child: Text("Starts after:")),
                  Expanded(child: TimePicker(callback: (time) => Provider.of<RideFilter>(context, listen: false).updateStartTime(time))),
                ],
              ),
              Row(
                children: [
                  Expanded(child: Text("Finishes by:")),
                  Expanded(child: TimePicker(callback: (time) => Provider.of<RideFilter>(context, listen: false).updateFinishTime(time))),
                ],
              ),

              SizedBox(height: 20),
              MediumText("Start Location"),
              AddressSearch(callback: (location) => Provider.of<RideFilter>(context, listen: false).updateLocation(location)),

              SizedBox(height: 20),
              MediumText("Distance"),
              TwoWaySlider(
                span: 120,
                callback: (range) => Provider.of<RideFilter>(context, listen: false).updateDistance(range),
              ),

              SizedBox(height: 20),
              MediumText("Climbing"),
              TwoWaySlider(
                span: 120,
                callback: (range) => Provider.of<RideFilter>(context, listen: false).updateClimbing(range),
              ),

              SizedBox(height: 20),
              MediumText("Duration"),
              TwoWaySlider(
                span: 120,
                callback: (range) => Provider.of<RideFilter>(context, listen: false).updateDuration(range),
              ),

              SizedBox(height: 20),
              MediumText("Expected average speed"),
              TwoWaySlider(
                span: 120,
                callback: (range) => Provider.of<RideFilter>(context, listen: false).updateAvgSpeed(range),
              ),

              SizedBox(height: 20),
              MediumText("Participants"),
              TwoWaySlider(
                span: 120,
                callback: (range) => Provider.of<RideFilter>(context, listen: false).updateNrParticipants(range),
              ),

              // SizedBox(height: 20),
              // MediumText("Random Dropdown"),
              // Dropdown(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: SubmitButton(
            value: "APPLY FILTERS",
            callback: () {
              () => Navigator.of(context).pop();
            }),
      ),
    );
  }
}
