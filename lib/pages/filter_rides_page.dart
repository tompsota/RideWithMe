import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_with_me/settings/filter_defaults.dart';
import 'package:ride_with_me/utils/address_search.dart';
import 'package:ride_with_me/utils/button.dart';
import 'package:ride_with_me/utils/date_picker.dart';
import 'package:ride_with_me/controllers/ride_filter_controller.dart';
import 'package:ride_with_me/utils/text.dart';
import 'package:ride_with_me/utils/time_picker.dart';
import 'package:ride_with_me/utils/two_way_slider.dart';

//TODO pridat reset tlacitko
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
                onPressed: () {
                  Navigator.of(context).pop();
                  Provider.of<RideFilterController>(context, listen: false).resetCurrentFilter();
                },
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
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // TODO tu sa nejak nevedia zrovnat, date je vypaddovany, idk why
                    Expanded(
                      child: Text(
                        "Date:",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Expanded(
                      child: DatePicker(
                        callback: (date) => Provider.of<RideFilterController>(context, listen: false).updateDate(date),
                        initialValue: Provider.of<RideFilterController>(context, listen: false).getAppliedFilter().selectedDate,
                        isEditable: true,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      "Starts after:",
                      style: TextStyle(fontSize: 16),
                    )), //TODO add provider for initial value
                    Expanded(
                        child: TimePicker(
                      callback: (time) => Provider.of<RideFilterController>(context, listen: false).updateStartTime(time),
                      time: Provider.of<RideFilterController>(context, listen: false).getAppliedFilter().selectedStartTime,
                      isEditable: true,
                    )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      "Finishes by:",
                      style: TextStyle(fontSize: 16),
                    )),
                    Expanded(
                        child: TimePicker(
                      callback: (time) => Provider.of<RideFilterController>(context, listen: false).updateFinishTime(time),
                      time: Provider.of<RideFilterController>(context, listen: false).getAppliedFilter().selectedFinishTime,
                      isEditable: true,
                    )),
                  ],
                ),
              ),

              SizedBox(height: 20),
              MediumText("Start Location"),
              AddressSearch(
                  initialValue: Provider.of<RideFilterController>(context, listen: false).getFilterLocation(),
                  callback: (location) => Provider.of<RideFilterController>(context, listen: false).updateLocation(location),
                  isEditable: true),

              SizedBox(height: 20),
              MediumText("Distance"),
              TwoWaySlider(
                span: defaultDistance,
                initialSpan: Provider.of<RideFilterController>(context, listen: false).getAppliedFilter().selectedDistance,
                callback: (range) => Provider.of<RideFilterController>(context, listen: false).updateDistance(range),
                units: "km",
              ),

              SizedBox(height: 20),
              MediumText("Climbing"),
              TwoWaySlider(
                span: defaultClimbing,
                initialSpan: Provider.of<RideFilterController>(context, listen: false).getAppliedFilter().selectedClimbing,
                callback: (range) => Provider.of<RideFilterController>(context, listen: false).updateClimbing(range),
                units: "m",
              ),

              SizedBox(height: 20),
              MediumText("Duration"),
              TwoWaySlider(
                span: defaultDuration,
                initialSpan: Provider.of<RideFilterController>(context, listen: false).getAppliedFilter().selectedDuration,
                callback: (range) => Provider.of<RideFilterController>(context, listen: false).updateDuration(range),
                units: "h",
              ),

              SizedBox(height: 20),
              MediumText("Expected average speed"),
              TwoWaySlider(
                span: defaultAvgSpeed,
                initialSpan: Provider.of<RideFilterController>(context, listen: false).getAppliedFilter().selectedAvgSpeed,
                callback: (range) => Provider.of<RideFilterController>(context, listen: false).updateAvgSpeed(range),
                units: "km/h",
              ),

              SizedBox(height: 20),
              MediumText("Participants"),
              TwoWaySlider(
                span: defaultNrParticipants,
                initialSpan: Provider.of<RideFilterController>(context, listen: false).getAppliedFilter().selectedNrParticipants,
                callback: (range) => Provider.of<RideFilterController>(context, listen: false).updateNrParticipants(range),
                units: "",
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
            callback: () async {
              Navigator.of(context).pop();
              await Provider.of<RideFilterController>(context, listen: false).applyFilter();
            }),
      ),
    );
  }
}
