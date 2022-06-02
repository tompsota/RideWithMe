import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/new_ride_controller.dart';
import '../../utils/ride_number_picker.dart';
import '../../utils/text.dart';

class RideNumberPickers extends StatelessWidget {
  bool canBeEdited;

  RideNumberPickers({Key? key, required this.canBeEdited}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NewRideController>(builder: (context, newRideController, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          MediumText("Total distance"),
          RideNumberPicker(
            minValue: 0,
            maxValue: 1000,
            units: "km",
            isEditable: canBeEdited,
            callback: (distance) {
              newRideController.setRideDistance(distance);
            },
            currentValue: newRideController.ride.distance,
          ),
          SizedBox(height: 20),
          MediumText("Expected average speed"),
          RideNumberPicker(
            minValue: 0,
            maxValue: 40,
            units: "km/h",
            isEditable: canBeEdited,
            callback: (speed) {
              newRideController.setRideAvgSpeed(speed);
            },
            currentValue: newRideController.ride.averageSpeed,
          ),
          SizedBox(height: 20),
          MediumText("Total climbing"),
          RideNumberPicker(
            minValue: 0,
            maxValue: 10000,
            units: "m",
            isEditable: canBeEdited,
            callback: (climbing) {
              newRideController.setRideClimbing(climbing);
            },
            currentValue: newRideController.ride.climbing,
          ),
        ],
      );
    });
  }
}
