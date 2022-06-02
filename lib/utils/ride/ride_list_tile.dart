
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_with_me/domain_layer/repositories/db_repository.dart';

import '../../controllers/user_state_controller.dart';
import '../../domain_layer/models/ride_model.dart';
import '../../pages/ride_view_page.dart';
import '../temp/get_db_repository.dart';

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
// builder: (_) => RideViewPage(rideBeingEdited: rideModel)
                builder: (_) =>
                    // MultiProvider(
                    //   providers: [
                    //     // use listen: false ?
                    //     ChangeNotifierProvider.value(value: Provider.of<UserStateController>(context)),
                    //   ],
                    //   child: RideViewPage(rideBeingEdited: ride,),
                    // )
                    ChangeNotifierProvider.value(
                      value: Provider.of<UserStateController>(context),
                      child: RideViewPage(rideBeingEdited: ride),
                    )
            ))
    );
  }
}