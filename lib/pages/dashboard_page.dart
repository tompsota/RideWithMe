import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_with_me/controllers/ride_filter_controller.dart';
import 'package:ride_with_me/controllers/user_state_controller.dart';
import 'package:ride_with_me/pages/filter_rides_page.dart';
import 'package:ride_with_me/pages/ride_view_page.dart';
import 'package:ride_with_me/utils/button.dart';
import 'package:ride_with_me/utils/ride/rides_stream_builder.dart';
import '../domain_layer/db_repository.dart';
import '../utils/filters.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dbRepository = Provider.of<DbRepository>(context, listen: false);
    final ridesRepository = dbRepository.ridesRepository;

    return Consumer<RideFilterController>(builder: (context, filterController, child) {
      final ridesFilter = filterController.getAppliedFilter();
      final ridesStream = ridesRepository.getFullRides(Filters.passesRidesFilter(ridesFilter));

      return Column(mainAxisSize: MainAxisSize.min, children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 50),
                child: SubmitButton(
                  value: "FILTER RIDES",
                  callback: () async {
                    Navigator.push(
                      context,
                      // MaterialPageRoute(builder: (context) => FilterRidesPage()),
                      MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider.value(value: filterController, child: FilterRidesPage())),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        Expanded(
          // child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 50),
            child: RidesStreamBuilder(ridesStream: ridesStream),
          ),
          // ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<UserStateController>(builder: (context, userController, child) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                  child: SubmitButton(
                    value: "ADD RIDE",
                    callback: () => Navigator.of(context).push(MaterialPageRoute(
                        // builder: (_) => RideViewPage()
                        builder: (context) => ChangeNotifierProvider.value(value: userController, child: RideViewPage()))),
                  ),
                ),
              );
            }),
          ],
        ),
      ]);
    });
  }
}
