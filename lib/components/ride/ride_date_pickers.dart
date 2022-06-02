import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/new_ride_controller.dart';
import '../../utils/date_picker.dart';
import '../../utils/text.dart';
import '../../utils/time_picker.dart';

class RideDatePickers extends StatelessWidget {
  bool canBeEdited;

  RideDatePickers({Key? key, required this.canBeEdited}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NewRideController>(
      builder: (context, newRideController, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            MediumText("Start date & Start time"),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    child: DatePicker(
                        callback: (date) => {newRideController.setRideDate(date)},
                        currentValue: newRideController.ride.rideDate,
                        isEditable: canBeEdited),
                  ),
                  if (canBeEdited) Icon(Icons.edit, color: Colors.grey),
                  SizedBox(width: 15),
                  Expanded(
                    child: TimePicker(
                        callback: (time) => {newRideController.setRideStartTime(time)},
                        time: newRideController.getRideStartTime(),
                        isEditable: canBeEdited),
                  ),
                  if (canBeEdited) Icon(Icons.edit, color: Colors.grey),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
