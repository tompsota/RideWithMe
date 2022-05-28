
import 'package:flutter/material.dart';

import '../../models/ride_model.dart';

class RideListTile extends StatelessWidget {

  final RideModel ride;

  RideListTile({Key? key, required this.ride}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(ride.title),
        subtitle: Text("author: ${ride.author?.getFullName() ?? "Unknown"}, participants: ${ride.participantsIds.length}"),
//         onTap: () =>
//             Navigator.of(context).push(MaterialPageRoute(
// // builder: (_) => RideViewPage(rideBeingEdited: rideModel)
//                 builder: (_) =>
//                     ChangeNotifierProvider.value(
//                       value: Provider.of<UserStateController>(context),
//                       child: RideViewPage(rideBeingEdited: ride),
//                     ))));
    );
  }
}