import 'package:flutter/material.dart';
import 'package:ride_with_me/pages/filter_rides_page.dart';
import 'package:ride_with_me/pages/ride_view_page.dart';
import 'package:ride_with_me/utils/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    final Stream<QuerySnapshot> _ridesStream = FirebaseFirestore.instance.collection('rides').snapshots();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SubmitButton(
            value: "Add ride",
            callback: () {
              CollectionReference rides = FirebaseFirestore.instance.collection('rides');
              Future<void> addRide() {
                return rides
                    .add(RideModel("don't use", "ride #2",).toJson()
                )
                    .then((value) => print("Ride Added"))
                    .catchError((error) => print("Failed to add ride: $error"));
              }

              addRide();
            }),

        StreamBuilder<QuerySnapshot>(
          stream: _ridesStream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView(
              shrinkWrap: true,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> json = document.data()! as Map<String, dynamic>;
                RideModel rideModel = RideModel.fromJson(json);
                // TODO: where to apply filter? (gotta Consume<RideFilter> there)
                return ListTile(
                    title: Text(rideModel.title),
                    subtitle: Text(rideModel.id),
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const RideViewPage()
                        )
                    )
                );
              }).toList(),
            );
          },
        ),

        Spacer(),

        SizedBox(
          width: double.infinity,
          child: SubmitButton(
              value: "FILTER RIDES",
              callback: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FilterRidesPage()),
                );
              }),
        )
      ],
    );
  }
}
