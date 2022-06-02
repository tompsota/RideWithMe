import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_with_me/components/filter/filter_date_pickers.dart';
import 'package:ride_with_me/components/filter/filter_range_sliders.dart';
import 'package:ride_with_me/utils/address_search.dart';
import 'package:ride_with_me/utils/button.dart';
import 'package:ride_with_me/controllers/ride_filter_controller.dart';
import 'package:ride_with_me/utils/text.dart';

//TODO pridat reset tlacitko
class FilterRidesPage extends StatelessWidget {
  FilterRidesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RideFilterController _rideFilterProvider = Provider.of<RideFilterController>(context, listen: false);

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
                  _rideFilterProvider.resetCurrentFilter();
                },
              ),
            ],
          )),
      body: Consumer<RideFilterController>(
        builder: (context, filterModel, _) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FilterDatePickers(),
                SizedBox(height: 20),
                MediumText("Start Location"),
                AddressSearch(
                    initialValue: _rideFilterProvider.getFilterLocation(),
                    callback: (location) => _rideFilterProvider.updateLocation(location),
                    isEditable: true),
                FilterRangeSliders(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: SubmitButton(
            value: "APPLY FILTERS",
            callback: () async {
              Navigator.of(context).pop();
              await _rideFilterProvider.applyFilter();
            }),
      ),
    );
  }
}
