import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_with_me/components/ride/ride_author_image.dart';
import 'package:ride_with_me/components/ride/ride_date_pickers.dart';
import 'package:ride_with_me/components/ride/ride_map_component.dart';
import 'package:ride_with_me/components/ride/ride_number_pickers.dart';
import 'package:ride_with_me/components/ride/ride_participants_list.dart';
import 'package:ride_with_me/components/ride/ride_submit_handler.dart';
import 'package:ride_with_me/components/user/user_contact_icons.dart';
import 'package:ride_with_me/domain_layer/repositories/db_repository.dart';
import 'package:ride_with_me/controllers/new_ride_controller.dart';
import 'package:ride_with_me/utils/checkbox_dialog.dart';

import '../components/ride/ride_title_bar.dart';
import '../controllers/user_state_controller.dart';
import '../domain_layer/models/ride_model.dart';
import '../utils/address_search.dart';
import '../utils/button.dart';
import '../utils/duration_picker.dart';
import '../utils/text.dart';

class RideViewPage extends StatelessWidget {
  final RideModel? rideBeingEdited;

  RideViewPage({Key? key, this.rideBeingEdited}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserStateController>(builder: (context, userController, child) {

      final ride = rideBeingEdited;
      final userId = userController.user.id;
      final isBeingCreated = rideBeingEdited == null;

      final isAuthor = ride?.authorId == userId;
      final canBeEdited = isBeingCreated || isAuthor;
      final userIsParticipating = ride?.participantsIds.contains(userId) ?? false;

      final author = isBeingCreated ? userController.user : ride?.author;
      final authorName = isBeingCreated ? userController.user.getFullName() : ride?.author?.getFullName() ?? "Unknown author";
      var rideTitle = isBeingCreated ? "$authorName's ride" : ride?.title ?? "Loading...";
      var titleController = TextEditingController(text: rideTitle);
      // Provider.of<NewRideController>(context, listen: false).setRideTitle(rideTitle);
      Provider.of<NewRideController>(context, listen: false).ride.title = rideTitle;
      final showCompleteRideButton = isAuthor && (ride != null && !ride.isCompleted);

      final dbRepository = Provider.of<DbRepository>(context, listen: false);
      final ridesRepository = dbRepository.ridesRepository;

      return Consumer<NewRideController>(builder: (context, newRideController, _) {
        return Scaffold(
          appBar: AppBar(
              toolbarHeight: 80,
              elevation: 0,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              title: RideTitleBar(isBeingCreated: isBeingCreated, titleController: titleController)),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RideAuthorImage(author: author, authorName: authorName),
                  RideMapComponent(isBeingCreated: isBeingCreated),
                  RideParticipantsList(ride: ride, isBeingCreated: isBeingCreated),
                  RideDatePickers(canBeEdited: canBeEdited),
                  RideNumberPickers(canBeEdited: canBeEdited),
                  SizedBox(height: 20),
                  MediumText("Expected duration"),
                  DurationPicker(
                    isEditable: canBeEdited,
                    callback: (duration) {
                      newRideController.setDuration(duration);
                    },
                    currentValue: newRideController.ride.duration,
                  ),
                  SizedBox(height: 20),
                  MediumText("Start Location"),
                  AddressSearch(
                      initialValue: isBeingCreated ? "" : "Brno, Czech Republic",
                      callback: (value) {
                        newRideController.setRideStartLocation(value["description"]);
                      },
                      isEditable: canBeEdited),
                  SizedBox(height: 20),
                  MediumText("Tags"),
                  CheckboxDialog(
                    isEditable: canBeEdited,
                    callback: (tags) {
                      newRideController.setRideTags(tags);
                    },
                    selectedTags: newRideController.ride.tags,
                  ),
                  if (!isBeingCreated) ...[
                    SizedBox(height: 20),
                    MediumText("Contact host"),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: UserContactIcons(user: ride!.author!),
                    ),
                  ],
                  if (showCompleteRideButton)
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: SubmitButton(
                        value: "Mark ride as completed",
                        callback: () async {
                          await ridesRepository.markRideAsCompleted(ride);
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              //  ride can be marked as "completed", which can be set (once) by the author ("Mark ride as finished/complete")
              //  - if this is set, no info can be edited anymore and the ride's ID is added to participant's "completedRides"
              child: (ride != null && ride.isCompleted)
                  ? Text('Ride is already completed')
                  : RideSubmitHandler(
                      ride: ride, isBeingCreated: isBeingCreated, userIsParticipating: userIsParticipating, userId: userId)),
        );
      });
    });
  }
}
