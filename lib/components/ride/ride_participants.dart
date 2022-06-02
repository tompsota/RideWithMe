import 'package:flutter/material.dart';
import 'package:ride_with_me/components/ride/ride_participants_icons.dart';

import '../../domain_layer/models/user_model.dart';


class RideParticipants extends StatelessWidget {

  final Stream<List<UserModel>>? participantsStream;

  RideParticipants({Key? key, required this.participantsStream}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (participantsStream == null) {
      return RideParticipantsIcons(participants: null);
    }

    return StreamBuilder<List<UserModel>>(
        stream: participantsStream,
        builder: (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong!');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading participants ...");
          }

          if (!snapshot.hasData || snapshot.data?.length == 0) {
            return Text("No participants... (yet)");
          }

          return RideParticipantsIcons(participants: snapshot.data!);
        },
    );
  }
}

