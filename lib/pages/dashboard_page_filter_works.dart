import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_with_me/controllers/ride_filter_controller.dart';
import 'package:ride_with_me/controllers/user_state_controller.dart';
import 'package:ride_with_me/pages/filter_rides_page.dart';
import 'package:ride_with_me/pages/ride_view_page.dart';
import 'package:ride_with_me/utils/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_with_me/utils/db_utils.dart';
import '../models/ride_model.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: should add refresh button or does it get updated automatically? if a different user adds a new ride in real time,
    //   will the current user see the new ride? probably has to refresh? maybe pull down/scroll up on phone at the very top would
    //   trigger refresh (get current collection 'rides' from DB), while keeping the same filter?
    // also, we might need to get more then just the 'rides' collection if we have to use ID's instead of 'full' UserModels in RideModel,
    //  which might cause that we can't use Stream<QuerySnapshot>? or maybe 'fetch author/participants as we load' ?
    // final Stream<QuerySnapshot> _ridesStream = FirebaseFirestore.instance.collection('rides').snapshots();

    // QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('rides').get();
    // QuerySnapshot querySnapshot = await _collectionRef.get();
    // Provider.of<RideFilterController>(context, listen: false).setRides(rides);

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
                  callback: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChangeNotifierProvider.value(value: filterController, child: FilterRidesPage())),
                      // MaterialPageRoute(builder: (context) => FilterRidesPage()),
                    );
                  }),
            ),
          ),
        ],
      ),

    // Consumer<RideFilterController>(builder: (context, filterController, child) {
            // Provider.of<RideFilterController>(context, listen: false).setRides(rides);
            // var rides = filterController.filteredRides;
            // return ListView(
            ListView(
              shrinkWrap: true,
              children: Provider.of<RideFilterController>(context).visibleRides // should be filteredRides, but other gives error, since filteredRides was removed
              // children: Provider.of<RideFilterController>(context).filteredRides
              .map((ride) => FutureBuilder<RideModel?>(
                // for filters we don't need participants or author (for number of participants we have ride.participantsIds)
                // we 'include' author for display
                // getFullRide(rideModel) fetches both author and participants
                // future: getFullRide(rideModel),
                future: getRideWithAuthor(ride),
                initialData: ride,
                builder: (BuildContext context, AsyncSnapshot<RideModel?> snapshot) {
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
              .toList()),
        // }),


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
            child: SubmitButton(
              value: "ADD RIDE",
              callback: () => Navigator.of(context).push(MaterialPageRoute(
                  // builder: (_) => RideViewPage()
                  // TODO: why the fuck do I have to wrap it in another ChangeNotifierProvider, when this widget/Page can access UserStateController ?????
                  builder: (context) => ChangeNotifierProvider.value(value: userController, child: RideViewPage()))),
            ),
          );
        }),
      ],
    ),
  ],);
    });
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
