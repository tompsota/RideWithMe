import 'package:flutter/material.dart';
import '../../domain_layer/models/ride_model.dart';
import '../../pages/ride_view_page.dart';

class RideListTile extends StatelessWidget {

  final RideModel ride;

  RideListTile({Key? key, required this.ride}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final author = ride.author?.getFullName() ?? "Unknown";
    final rideTitle = ride.title.isNotEmpty ? ride.title : (ride.author != null ? "$author's ride" : "[No title]");
    return ListTile(
        title: Text('$rideTitle  ${(ride.isCompleted) ? "(COMPLETED)" : ""}'),
        subtitle: Text("author: $author, participants: ${ride.participantsIds.length}"),
        onTap: () =>
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => RideViewPage(rideBeingEdited: ride),
            ))
    );
  }
}