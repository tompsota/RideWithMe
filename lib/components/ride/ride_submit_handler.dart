import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/new_ride_controller.dart';
import '../../domain_layer/repositories/db_repository.dart';
import '../../domain_layer/models/ride_model.dart';
import '../../utils/button.dart';

class RideSubmitHandler extends StatelessWidget {
  final RideModel? ride;
  final bool isBeingCreated;
  final bool userIsParticipating;
  final String userId;

  RideSubmitHandler({Key? key, required this.ride, required this.isBeingCreated, required this.userIsParticipating, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dbRepository = Provider.of<DbRepository>(context, listen: false);
    final ridesRepository = dbRepository.ridesRepository;

    return Consumer<NewRideController>(builder: (context, newRideController, _) {
      return SubmitButton(
          value: isBeingCreated ? "CREATE RIDE" : (userIsParticipating ? "LEAVE RIDE" : "I'LL PARTICIPATE"),
          callback: isBeingCreated
              ? () async {
                  await newRideController.submitRide(userId);
                  Navigator.of(context).pop();
                }
              : (userIsParticipating
                  ? () async {
                      // user that is participating clicked on "Leave ride"
                      await ridesRepository.leaveRide(ride!.id, userId);
                      Navigator.of(context).pop();
                    }
                  : () async {
                      await ridesRepository.joinRide(ride!.id, userId);
                      Navigator.of(context).pop();
                    }));
    });
  }
}
