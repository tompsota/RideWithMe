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
                    .add(RideModel.id("ride #2",).toJson()
                )
                    .then((value) => print("Ride Added"))
                    .catchError((error) => print("Failed to add ride: $error"));
              }

              addRide();
            }),
        // Spacer(),

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
                return ListTile(
                    title: Text(rideModel.name),
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
