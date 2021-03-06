import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain_layer/repositories/db_repository.dart';
import '../../domain_layer/models/ride_model.dart';
import 'ride_participants.dart';
import '../../utils/text.dart';


class RideParticipantsList extends StatelessWidget {
  final RideModel? ride;
  final bool isBeingCreated;

  RideParticipantsList({Key? key, required this.ride, required this.isBeingCreated}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dbRepository = Provider.of<DbRepository>(context, listen: false);
    final usersRepository = dbRepository.usersRepository;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isBeingCreated) ...[
          SizedBox(height: 20),
          MediumText("With"),
          Container(
              constraints: BoxConstraints(maxHeight: 36, minWidth: double.infinity),
              child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: ride == null
                      ? RideParticipants(participantsStream: null)
                      : RideParticipants(participantsStream: usersRepository.getParticipants(ride!))
                  )),
        ],
      ],
    );
  }
}
