import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ride_with_me/utils/checkbox_dialog.dart';
import 'package:ride_with_me/utils/ride_icon_button.dart';
import 'package:ride_with_me/utils/ride_number_picker.dart';
import 'package:ride_with_me/utils/title_button.dart';

import '../utils/address_search.dart';
import '../utils/button.dart';
import '../utils/copy_link_button.dart';
import '../utils/duration_picker.dart';
import '../utils/text.dart';

//TODO zistit ci sa da pridat widget s mapou, ktora ma preddefinovanu route alebo to robit ako redirect go google maps appky / browseru

class RideViewPage extends StatefulWidget {
  const RideViewPage({Key? key}) : super(key: key);

  @override
  _RideViewPageState createState() => _RideViewPageState();
}

class _RideViewPageState extends State<RideViewPage> {
  String _rideTitle = "Nove Mlyny";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 80,
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: FittedBox(
            fit: BoxFit.fitWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //TODO make this button
                // Expanded(child: TitleButton()),
                Text(
                  "Trip to " + _rideTitle,
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
            ),
          )),
      body: SingleChildScrollView(
        child: Padding(
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
              Container(
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
              SizedBox(height: 50),
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
              SizedBox(height: 20),
              MediumText("Start Location"),
              AddressSearch(callback: (_) {}), //TODO add callback
              SizedBox(height: 20),
              MediumText("Tags"),
              CheckboxDialog(),
              SizedBox(height: 20),
              MediumText("Link to share with friends"),
              SizedBox(
                width: double.infinity,
                child: CopyLinkButton(value: "ridewith.me/gh4jj5"),
              ),
              SizedBox(height: 20),
              MediumText("Contact host"),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RideIconButton(icon: FontAwesomeIcons.facebook),
                      RideIconButton(icon: FontAwesomeIcons.strava),
                      RideIconButton(icon: FontAwesomeIcons.instagram),
                      RideIconButton(icon: FontAwesomeIcons.google),
                      RideIconButton(icon: FontAwesomeIcons.slack),
                      RideIconButton(icon: FontAwesomeIcons.envelope),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: SubmitButton(
            value: "I'LL PARTICIPATE",
            callback: () {
              Navigator.of(context).pop();
            }),
      ),
    );
  }
}
