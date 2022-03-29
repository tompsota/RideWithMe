import 'package:flutter/material.dart';

class FilterRidesPage extends StatelessWidget {
  FilterRidesPage({Key? key}) : super(key: key);

  //TODO this is heavy WIP
  String _chosenValue = "todo";
  RangeValues _currentRangeValues = RangeValues(20, 80);

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
                fontSize: 22,
              ),
            ),
          )),
      body: Column(
        children: [
          DropdownButton<String>(
              focusColor: Colors.white,
              // value: _chosenValue,
              //elevation: 5,
              style: TextStyle(color: Colors.white),
              iconEnabledColor: Colors.black,
              items: <String>[
                'Android',
                'IOS',
                'Flutter',
                'Node',
                'Java',
                'Python',
                'PHP',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              hint: Text(
                "Please choose a langauage",
                style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
              ),
              onChanged: (_) {}
              // onChanged: (String value) {
              //   setState(() {
              //     _chosenValue = value;
              //   });
              // },
              ),
          RangeSlider(
            values: _currentRangeValues,
            max: 100,
            divisions: 20,
            labels: RangeLabels(
                // _currentRangeValues.start.round().toString(),
                // _currentRangeValues.end.round().toString(),
                '20',
                '80'),
            onChanged: (_) {},
            // onChanged: (RangeValues values) {
            //   setState(() {
            //     _currentRangeValues = values;
            //   });
            // },
          ),
        ],
      ),
    );
  }
}
