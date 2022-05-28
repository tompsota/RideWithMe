import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_with_me/controllers/ride_filter_controller.dart';
import 'package:ride_with_me/controllers/user_state_controller.dart';
import 'package:ride_with_me/data_layer/apis/firestore_users_api.dart';
import 'package:ride_with_me/domain_layer/rides_repository.dart';
import 'package:ride_with_me/pages/filter_rides_page.dart';
import 'package:ride_with_me/pages/ride_view_page.dart';
import 'package:ride_with_me/utils/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_with_me/utils/db/ride.dart';
import '../data_layer/apis/firestore_rides_api.dart';
import '../data_layer/apis/rides_api.dart';
import '../models/ride_model.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RideFilterController>(builder: (context, filterController, child) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                        MaterialPageRoute(builder: (context) => ChangeNotifierProvider.value(value: filterController, child: FilterRidesPage())),
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
                child: StreamBuilder<List<RideModel>>(
                  stream: RidesRepository(ridesApi: FirestoreRidesApi(), usersApi: FirestoreUsersApi()).getFullRides(),
                  builder: (BuildContext context, AsyncSnapshot<List<RideModel>> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }

                    if (!snapshot.hasData) {
                      return Text("No rides to show.");
                    }

                    return ListView(
                        shrinkWrap: true,
                        children: snapshot.data!.map((ride) {
                          return ListTile(
                            title: Text('${ride.title}  ${(ride.isCompleted) ? "(COMPLETED)" : ""}'),
                            subtitle: Text(
                              "author: ${ride.author?.getFullName() ?? "Unknown"}, participants: ${ride.participantsIds.length}"),
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) =>
                              //     ChangeNotifierProvider.value(
                              //   value: Provider.of<UserStateController>(context),
                              //   child: RideViewPage(rideBeingEdited: ride),
                              // )
                                MultiProvider(providers: [
                                  ChangeNotifierProvider.value(value: Provider.of<UserStateController>(context)),
                                  ChangeNotifierProvider.value(value: filterController),
                                ],
                                child: RideViewPage(rideBeingEdited: ride),
                              )
                            )));
                          }).toList(),
                    );
                  },
                )
              ),
            // ),
          ),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer<UserStateController>(builder: (context, userController, child) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 50),
                    child: SubmitButton(
                      value: "ADD RIDE",
                      callback: () => Navigator.of(context).push(MaterialPageRoute(
                        // builder: (_) => RideViewPage()
                          builder: (context) => ChangeNotifierProvider.value(value: userController, child: RideViewPage()))
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ]
      );
    });
  }
}
