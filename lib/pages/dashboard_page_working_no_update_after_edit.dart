import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_with_me/controllers/ride_filter_controller.dart';
import 'package:ride_with_me/controllers/user_state_controller.dart';
import 'package:ride_with_me/pages/filter_rides_page.dart';
import 'package:ride_with_me/pages/ride_view_page.dart';
import 'package:ride_with_me/utils/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_with_me/utils/db/ride.dart';
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
                        value: "REFRESH RIDES",
                        // callback: () async => Provider.of<RideFilterController>(context, listen: false).refreshRides(),
                        callback: () async => filterController.refreshRides(),
                      ),
                    ),
                  ),
                ],
              ),
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
                            // MaterialPageRoute(builder: (context) => ChangeNotifierProvider.value(value: Provider.of<RideFilterController>(context, listen: false), child: FilterRidesPage())),
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
                    child: ListView(
                      shrinkWrap: true,
                      // children: Provider.of<RideFilterController>(context).visibleRides.map((ride) => FutureBuilder<RideModel?>(
                      // children: filterController.visibleRides.map((ride) => FutureBuilder<RideModel?>(
                      // children: filterController.visibleRides.map((ride) => FutureBuilder<RideModel?>(


                      children: filterController.visibleRides.map((ride) => FutureBuilder<RideModel?>(
                        // for filters we don't need participants or author (for number of participants we have ride.participantsIds)
                        // we 'include' author for display ; getFullRide(ride) would fetch both author and participants
                        future: getRideWithAuthor(ride),
                        initialData: ride,
                        builder: (BuildContext context, AsyncSnapshot<RideModel?> snapshot) {
                          // TODO: add snapshot.hasData (etc.) checks
                          final ride = snapshot.data!;
                          return ListTile(
                            title: Text('${ride.title}  ${(ride.isCompleted) ? "(COMPLETED)" : ""}'),
                            subtitle: Text(
                              "author: ${ride.author?.getFullName() ?? "Unknown"}, participants: ${ride.participantsIds.length}"),
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ChangeNotifierProvider.value(
                                value: Provider.of<UserStateController>(context),
                                child: RideViewPage(rideBeingEdited: ride),
                              )
                            )));
                        }))
                      .toList()

                      // children: filterController.filteredRides.map((ride) => ListTile(
                      //   title: Text('${ride.title}')
                      // )).toList(),

                    ),
                  ),
                // ),
              ),

              //todo maybe use this for 'add ride' button
              // FloatingActionButton(
              //   onPressed: () {},
              //   tooltip: 'Increment',
              //   child: const Icon(Icons.add),
              // ),
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
        }
        );
  }
}





// ------------------[ old stuff ]----------------------

//       return FutureBuilder<RideModel?>(
//         // for filters we don't need participants or author (for number of participants we have ride.participantsIds)
//         // we 'include' author for display
//         // getFullRide(rideModel) fetches both author and participants
//         // future: getFullRide(rideModel),
//           future: getRideWithAuthor(rideModel),
//           initialData: rideModel,
//           builder: (BuildContext context, AsyncSnapshot<RideModel?> snapshot) {
//             final ride = snapshot.data!;
//             return ListTile(
//                 title: Text('${ride.title}  ${(ride.isCompleted) ? "(COMPLETED)" : ""}'),
//                 subtitle: Text("author: ${ride.author?.getFullName() ?? "Unknown"}, participants: ${ride.participantsIds.length}"),
//                 onTap: () =>
//                     Navigator.of(context).push(
//                         MaterialPageRoute(
//                           // builder: (_) => RideViewPage(rideBeingEdited: rideModel)
//                             builder: (_) =>
//                                 ChangeNotifierProvider.value(
//                                   value: Provider.of<UserStateController>(context),
//                                   child: RideViewPage(rideBeingEdited: ride),
//                                 )
//                         )
//                     )
//             );
//           });
//     }).toList(),
//     );
//   }
// )

// return ListView(
//   shrinkWrap: true,
//
//   children: snapshot.data!.docs
//       .map((doc) => RideModel.fromJson(doc.data()! as Map<String, dynamic>))
//       .where((ride) => Provider.of<RideFilterController>(context))
//
//   children: snapshot.data!.docs.map((DocumentSnapshot document) {
//     Map<String, dynamic> json = document.data()! as Map<String, dynamic>;
//     RideModel rideModel = RideModel.fromJson(json);
//
//
//
//
//
//     // TODO: where to apply filter? (gotta Consume<RideFilter> there)
//
//
//
//
//     return FutureBuilder<RideModel?>(
//       // for filters we don't need participants or author (for number of participants we have ride.participantsIds)
//       // we 'include' author for display
//       // getFullRide(rideModel) fetches both author and participants
//       // future: getFullRide(rideModel),
//       future: getRideWithAuthor(rideModel),
//       initialData: rideModel,
//       builder: (BuildContext context, AsyncSnapshot<RideModel?> snapshot) {
//         final ride = snapshot.data!;
//         return ListTile(
//             title: Text('${ride.title}  ${(ride.isCompleted) ? "(COMPLETED)" : ""}'),
//             subtitle: Text("author: ${ride.author?.getFullName() ?? "Unknown"}, participants: ${ride.participantsIds.length}"),
//             onTap: () =>
//                 Navigator.of(context).push(
//                     MaterialPageRoute(
//                       // builder: (_) => RideViewPage(rideBeingEdited: rideModel)
//                         builder: (_) =>
//                             ChangeNotifierProvider.value(
//                                 value: Provider.of<UserStateController>(context),
//                                 child: RideViewPage(rideBeingEdited: ride),
//                             )
//                     )
//                 )
//         );
//       });
//   }).toList(),
// );


// Expanded(
// child: SingleChildScrollView(
// child: Consumer<RideFilterController>(builder: (context, filterController, child) {
// return StreamBuilder<QuerySnapshot>(
// // StreamBuilder<QuerySnapshot>(
// //   stream: _ridesStream,
// stream: FirebaseFirestore.instance.collection('rides').snapshots(),
// builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
// if (snapshot.hasError) {
// return Text('Something went wrong');
// }
//
// if (snapshot.connectionState == ConnectionState.waiting) {
// return Text("Loading");
// }
//
// // return Consumer<RideFilterController>(
// //   builder: (context, filterController, child) {
// return ListView(
// shrinkWrap: true,
// children: snapshot.data!.docs
//     .map((doc) => RideModel.fromJson(doc.data()! as Map<String, dynamic>))
// // .where((ride) => Provider.of<RideFilterController>(context).getAppliedFilter().passes(ride))
//     .where((ride) => filterController.getAppliedFilter().passes(ride))
//     .map((ride) => FutureBuilder<RideModel?>(
// // for filters we don't need participants or author (for number of participants we have ride.participantsIds)
// // we 'include' author for display
// // getFullRide(rideModel) fetches both author and participants
// // future: getFullRide(rideModel),
// future: getRideWithAuthor(ride),
// initialData: ride,
// builder: (BuildContext context, AsyncSnapshot<RideModel?> snapshot) {
// final ride = snapshot.data!;
// return ListTile(
// title: Text('${ride.title}  ${(ride.isCompleted) ? "(COMPLETED)" : ""}'),
// subtitle: Text(
// "author: ${ride.author?.getFullName() ?? "Unknown"}, participants: ${ride.participantsIds.length}"),
// onTap: () => Navigator.of(context).push(MaterialPageRoute(
// builder: (_) => ChangeNotifierProvider.value(
// value: Provider.of<UserStateController>(context),
// child: RideViewPage(rideBeingEdited: ride),
// ))));
// }))
//     .toList());
// });
// }),
// ),
// ),