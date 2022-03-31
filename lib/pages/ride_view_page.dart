import 'package:flutter/material.dart';
import 'package:ride_with_me/utils/ride_number_picker.dart';

import '../utils/duration_picker.dart';
import '../utils/text.dart';

//TODO zistit ci sa da pridat widget s mapou, ktora ma preddefinovanu route alebo to robit ako redirect go google maps appky / browseru

class RideViewPage extends StatefulWidget {
  const RideViewPage({Key? key}) : super(key: key);

  @override
  _RideViewPageState createState() => _RideViewPageState();
}

class _RideViewPageState extends State<RideViewPage> {
  String _ride_title = "Nove Mlyny";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 80,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Container(
              child: Text(
                "Trip to " + _ride_title,
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
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/c/c4/Orange-Fruit-Pieces.jpg'),
                      maxRadius: 30,
                    ),
                  ),
                  LargeText("by Lucas Ronald"),
                ],
              ),
              SizedBox(height: 20),
              MediumText("With"),
              Flexible(
                child: Container(
                  constraints: BoxConstraints(maxHeight: 36, minWidth: double.infinity),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Stack(
                      children: [
                        ...List.generate(
                          12,
                          (index) => Positioned(
                            left: index * 12,
                            child: CircleAvatar(
                              backgroundImage: index.isEven
                                  ? NetworkImage('https://upload.wikimedia.org/wikipedia/commons/c/c4/Orange-Fruit-Pieces.jpg')
                                  : NetworkImage('https://portswigger.net/cms/images/63/12/0c8b-article-211117-linux-rng.jpg'),
                              maxRadius: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              MediumText("Total distance"),
              RideNumberPicker(minValue: 0, maxValue: 1000, units: "km"),

              SizedBox(height: 20),
              MediumText("Expected average speed"),
              RideNumberPicker(minValue: 15, maxValue: 40, units: "km/h"),

              SizedBox(height: 20),
              MediumText("Total climbing"),
              RideNumberPicker(minValue: 0, maxValue: 10000, units: "m"),

              SizedBox(height: 20),
              MediumText("Expected duration"),
              DurationPicker(),
            ],
          ),
        ));
  }
}
