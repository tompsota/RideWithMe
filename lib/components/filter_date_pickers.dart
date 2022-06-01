import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/ride_filter_controller.dart';
import '../utils/date_picker.dart';
import '../utils/text.dart';
import '../utils/time_picker.dart';

class FilterDatePickers extends StatelessWidget {
  const FilterDatePickers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RideFilterController _rideFilterProvider = Provider.of<RideFilterController>(context, listen: false);

    return Consumer<RideFilterController>(
      builder: (context, filterModel, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MediumText("Time Schedule"),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Text(
                    "Date:",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Expanded(
                  child: DatePicker(
                    callback: (date) => _rideFilterProvider.updateDate(date),
                    currentValue: filterModel.getCurrentFilter().selectedDate,
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
                  ),
                ),
                Expanded(
                    child: TimePicker(
                  callback: (time) => _rideFilterProvider.updateStartTime(time),
                  time: filterModel.getCurrentFilter().selectedStartTime,
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
                  callback: (time) => _rideFilterProvider.updateFinishTime(time),
                  time: filterModel.getCurrentFilter().selectedFinishTime,
                  isEditable: true,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
