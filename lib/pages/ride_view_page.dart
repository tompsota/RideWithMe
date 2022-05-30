import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_with_me/components/user_contact_icons.dart';
import 'package:ride_with_me/controllers/ride_filter_controller.dart';
import 'package:ride_with_me/domain_layer/db_repository.dart';
import 'package:ride_with_me/controllers/new_ride_controller.dart';
import 'package:ride_with_me/utils/checkbox_dialog.dart';
import 'package:ride_with_me/utils/ride_number_picker.dart';
import 'package:ride_with_me/utils/title_button.dart';
import 'package:ride_with_me/utils/user_input_field.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/user_state_controller.dart';
import '../models/ride_model.dart';
import '../utils/address_search.dart';
import '../utils/button.dart';
import '../utils/copy_link_button.dart';
import '../utils/date_picker.dart';
import '../utils/duration_picker.dart';
import '../utils/filters.dart';
import '../utils/ride/ride_participants.dart';
import '../utils/text.dart';
import '../utils/time_picker.dart';

class RideViewPage extends StatelessWidget {
  final RideModel? rideBeingEdited;

  RideViewPage({Key? key, this.rideBeingEdited}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // NewRideController _newRideProvider = Provider.of<NewRideController>(context, listen: false);
    // RideFilterController _rideFilterProvider = Provider.of<RideFilterController>(context, listen: false);

    return Consumer<UserStateController>(builder: (context, userController, child) {
      // final ride = snapshot.data;

      final ride = rideBeingEdited;

      final userId = userController.user.id;
      final isBeingCreated = rideBeingEdited == null;
      final isAuthor = ride?.authorId == userId;
      // ride can be edited by author and when it's being created (we can remove author later)
      final canBeEdited = isBeingCreated || isAuthor;
      final userIsParticipating = ride?.participantsIds.contains(userId) ?? false;

      final authorName = isBeingCreated ? userController.user.getFullName() : ride?.author?.getFullName() ?? "Unknown author";
      var rideTitle = isBeingCreated ? "$authorName's ride" : ride?.title ?? "Loading...";
      var titleController = TextEditingController(text: rideTitle);
      var linkController = TextEditingController();

      final showCompleteRideButton = isAuthor && (ride != null && !ride.isCompleted);

      final iframeWidth = MediaQuery.of(context).size.width.toInt() * 2.5; // some black magic
      final iframeHeight = MediaQuery.of(context).size.width.toInt() * 1.5;

      final dbRepository = Provider.of<DbRepository>(context, listen: false);
      final usersRepository = dbRepository.usersRepository;
      final ridesRepository = dbRepository.ridesRepository;

      return Consumer<NewRideController>(builder: (context, newRideController, _) {
        return Scaffold(
          appBar: AppBar(
              toolbarHeight: 80,
              elevation: 0,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: TitleButton(
                    isEnabled: isBeingCreated,
                    callback: (title) {
                      newRideController.setRideTitle(title);
                    },
                    textController: titleController,
                  )),
                  IconButton(
                    icon: Icon(Icons.close, color: Theme.of(context).unselectedWidgetColor),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              )),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              ride?.author?.avatarUrl ?? 'https://upload.wikimedia.org/wikipedia/commons/c/c4/Orange-Fruit-Pieces.jpg'),
                          maxRadius: 30,
                        ),
                      ),
                      LargeText("by $authorName"),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: isBeingCreated
                        ? UserInputField(
                            callback: (link) => {newRideController.setRideMapLink(link)},
                            controller: linkController,
                          )
                        : Container(
                            child: kIsWeb
                                ? Image(
                                    image: AssetImage("assets/abstract-map-placeholder.jpg"),
                                  )
                                : SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.width * 0.54,
                                    child: WebView(
                                      initialUrl: Uri.dataFromString(
                                              '<html><body><iframe style="border:none" src="https://en.frame.mapy.cz/s/gozajafofo" width="$iframeWidth" height="$iframeHeight" frameborder="0"></iframe></body></html>',
                                              mimeType: 'text/html')
                                          .toString(),
                                      javascriptMode: JavascriptMode.unrestricted,
                                    ),
                                  ),
                          ),
                  ),

                  if (!isBeingCreated) ...[
                    SizedBox(height: 20),
                    MediumText("With"),
                    Container(
                        constraints: BoxConstraints(maxHeight: 36, minWidth: double.infinity),
                        child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: ride == null
                                ? RideParticipants(participantsStream: null)
                                : RideParticipants(participantsStream: usersRepository.getUsers(Filters.isParticipant(ride)))
                            // : RideParticipants(participantsStream: usersRepository.getUsers())
                            )),
                  ],
                  SizedBox(height: 50),
                  MediumText("Start date & Start time"),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: DatePicker(
                              callback: (date) => {newRideController.setRideDate(date)},
                              currentValue: newRideController.ride.rideDate,
                              isEditable: canBeEdited),
                        ),
                        if (canBeEdited) Icon(Icons.edit, color: Colors.grey),
                        SizedBox(width: 15),
                        Expanded(
                          child: TimePicker(
                              callback: (time) => {newRideController.setRideStartTime(time)},
                              time: newRideController.getRideStartTime(),
                              isEditable: canBeEdited),
                        ),
                        if (canBeEdited) Icon(Icons.edit, color: Colors.grey),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  MediumText("Total distance"),
                  RideNumberPicker(
                    minValue: 0,
                    maxValue: 1000,
                    units: "km",
                    isEditable: canBeEdited,
                    callback: (distance) {
                      newRideController.setRideDistance(distance);
                    },
                    currentValue: newRideController.ride.distance,
                  ),
                  SizedBox(height: 20),
                  MediumText("Expected average speed"),
                  RideNumberPicker(
                    minValue: 0,
                    maxValue: 40,
                    units: "km/h",
                    isEditable: canBeEdited,
                    callback: (speed) {
                      newRideController.setRideAvgSpeed(speed);
                    },
                    currentValue: newRideController.ride.averageSpeed,
                  ),
                  SizedBox(height: 20),
                  MediumText("Total climbing"),
                  RideNumberPicker(
                    minValue: 0,
                    maxValue: 10000,
                    units: "m",
                    isEditable: canBeEdited,
                    callback: (climbing) {
                      newRideController.setRideClimbing(climbing);
                    },
                    currentValue: newRideController.ride.climbing,
                  ),
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
                  //TODO add callback, set initial value from db
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
                    MediumText("Link to share with friends"),
                    SizedBox(
                      width: double.infinity,
                      child: CopyLinkButton(value: "ridewith.me/gh4jj5"),
                    ),
                    SizedBox(height: 20),
                    MediumText("Contact host"),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: UserContactIcons(user: userController.user) //todo chcelo by to model autora, nie toho co je prihlaseny
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
                // TODO: improve design - maybe grayed out?
                ? Text('Ride is already completed')
                : SubmitButton(
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
                              })),
          ),
        );
      });
    });
  }
}
