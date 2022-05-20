import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_with_me/utils/checkbox_dialog.dart';
import 'package:ride_with_me/utils/ride_icon_button.dart';
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
import '../utils/db_utils.dart';
import '../utils/duration_picker.dart';
import '../utils/text.dart';
import '../utils/time_picker.dart';

class RideViewPage extends StatelessWidget {
  final RideModel? rideBeingEdited;

  RideViewPage({Key? key, this.rideBeingEdited}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final ride = await getFullRide(rideBeingEdited!);
    return FutureBuilder<RideModel?>(
      future: getFullRide(rideBeingEdited),
      builder: (BuildContext context, AsyncSnapshot<RideModel?> snapshot) {
        return Consumer<UserStateController>(builder: (context, userController, child) {
          final ride = snapshot.data;

          final userId = userController.user.email;
          final isBeingCreated = rideBeingEdited == null;
          final isAuthor = ride?.authorId == userId;
          // ride can be edited by author and when it's being created (we can remove author later)
          final canBeEdited = isBeingCreated || isAuthor;
          final userIsParticipating = ride?.participantsIds.contains(userId) ?? false;

          final authorName = isBeingCreated ? userController.user.getFullName() : ride?.author?.getFullName() ?? "Unknown author";
          var rideTitle = isBeingCreated ? "$authorName's ride" : ride?.title ?? "Loading...";
          var titleController = TextEditingController(text: rideTitle);

          final showCompleteRideButton = isAuthor && (ride != null && !ride.isCompleted);

          final iframeWidth = MediaQuery.of(context).size.width.toInt() * 2.5; // some black magic
          final iframeHeight = MediaQuery.of(context).size.width.toInt() * 1.5;

          Duration rideDuration = Duration();
          DateTime rideDate = DateTime.now();
          TimeOfDay rideStartTime = TimeOfDay.now();
          String rideMapLink;
          String rideStartLocationName;
          String rideStartLocationId;
          // TODO: change to double ?
          int rideDistance = 0;
          int rideAverageSpeed = 0;
          int rideClimbing = 0;
          List<String> rideTags = [];

          final authUser = FirebaseAuth.instance;

          return Scaffold(
            appBar: AppBar(
                toolbarHeight: 80,
                elevation: 0,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //TODO make this readonly if ride is viewed
                    // TODO: keep either callback or textController, not both
                    Expanded(
                        child: TitleButton(
                      isEnabled: isBeingCreated,
                      callback: (title) {
                        rideTitle = title;
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
                                ride?.author?.avatarURL ?? 'https://upload.wikimedia.org/wikipedia/commons/c/c4/Orange-Fruit-Pieces.jpg'),
                            maxRadius: 30,
                          ),
                        ),
                        LargeText("by $authorName"),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: isBeingCreated
                          ? UserInputField(initialValue: "", callback: (link) => {rideMapLink = link})
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
                                ?
                                // : Text("Loading...")
                                // some placeholder text/images before we load participants from DB
                                Stack(
                                    children: [
                                      ...List.generate(
                                        12,
                                        (index) => Positioned(
                                          left: index * 12,
                                          child: CircleAvatar(
                                            backgroundImage: index.isEven
                                                ? NetworkImage(
                                                    'https://upload.wikimedia.org/wikipedia/commons/c/c4/Orange-Fruit-Pieces.jpg')
                                                : NetworkImage(
                                                    'https://portswigger.net/cms/images/63/12/0c8b-article-211117-linux-rng.jpg'),
                                            maxRadius: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Stack(
                                    children:
                                        // ride.participants.map((x) => Text(x.email)).toList(),
                                        List.generate(
                                      ride.participantsIds.length,
                                      (index) => Positioned(
                                        left: index * 12,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(ride.participants[index].avatarURL),
                                          maxRadius: 12,
                                        ),
                                      ),
                                    ),
                                  )),
                      ),
                    ],
                    SizedBox(height: 50),
                    MediumText("Start date & Start time"),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: DatePicker(callback: (date) => {rideDate = date}, initialValue: DateTime.now(), isEditable: canBeEdited),
                          ),
                          if (canBeEdited) Icon(Icons.edit, color: Colors.grey),
                          SizedBox(width: 15),
                          Expanded(
                            child: TimePicker(callback: (time) => {rideStartTime = time}, time: TimeOfDay.now(), isEditable: canBeEdited),
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
                          rideDistance = distance;
                        }),
                    SizedBox(height: 20),
                    MediumText("Expected average speed"),
                    RideNumberPicker(
                        minValue: 15,
                        maxValue: 40,
                        units: "km/h",
                        isEditable: canBeEdited,
                        callback: (speed) {
                          rideAverageSpeed = speed;
                        }),
                    SizedBox(height: 20),
                    MediumText("Total climbing"),
                    RideNumberPicker(
                        minValue: 0,
                        maxValue: 10000,
                        units: "m",
                        isEditable: canBeEdited,
                        callback: (climbing) {
                          rideClimbing = climbing;
                        }),
                    SizedBox(height: 20),
                    MediumText("Expected duration"),
                    DurationPicker(
                        isEditable: canBeEdited,
                        callback: (duration) {
                          rideDuration = duration;
                        }),
                    SizedBox(height: 20),
                    MediumText("Start Location"),
                    AddressSearch(
                        initialValue: isBeingCreated ? "" : "Brno, Czech Republic",
                        callback: (value) {
                          rideStartLocationName = value["description"];
                          rideStartLocationId = value["place_id"];
                        },
                        isEditable: canBeEdited),
                    //TODO add callback, set initial value from db
                    SizedBox(height: 20),
                    MediumText("Tags"),
                    CheckboxDialog(
                        isEditable: canBeEdited,
                        callback: (tags) {
                          rideTags = tags;
                        }),

                    // link to share with friends should be displayed always? (or not when ride is complete? - to look at results?)
                    // author/host contact info should be displayed at all times?
                    // change 'author' to 'host' in display?
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
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RideIconButton(
                                  icon: FontAwesomeIcons.facebook, accountLink: 'facebook.com/' + ride!.authorId, serviceName: 'Facebook'),
                              //TODO add username from db
                              RideIconButton(
                                  icon: FontAwesomeIcons.strava, accountLink: 'strava.com/' + ride!.authorId, serviceName: 'Strava'),
                              RideIconButton(
                                  icon: FontAwesomeIcons.instagram,
                                  accountLink: 'instagram.com/' + ride!.authorId,
                                  serviceName: 'Instagram'),
                              RideIconButton(
                                  icon: FontAwesomeIcons.google, accountLink: 'google.com/' + ride!.authorId, serviceName: 'Google'),
                              RideIconButton(
                                  icon: FontAwesomeIcons.slack, accountLink: 'slack.com/' + ride!.authorId, serviceName: 'Slack'),
                              RideIconButton(icon: FontAwesomeIcons.envelope, accountLink: ride!.authorId, serviceName: 'Email'),
                            ],
                          ),
                        ),
                      ),
                    ],
                    if (showCompleteRideButton)
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: SubmitButton(
                          value: "Mark ride as completed",
                          callback: () async {
                            await completeRide(ride);
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
              //  also, ride should have a bool "finished/completed", which can be set (once?) by the author ("Mark ride as finished/complete") - if this is set,
              //  no info can be edited anymore and the ride's ID is added to participant's "completedRides"
              child: (ride != null && ride.isCompleted)
                  // TODO: improve design - maybe grayed out?
                  ? Text('Ride is already completed')
                  : SubmitButton(
                      value: isBeingCreated ? "CREATE RIDE" : (userIsParticipating ? "LEAVE RIDE" : "I'LL PARTICIPATE"),
                      callback: isBeingCreated
                          ? () async {
                              // createRide in DB
                              await createRide(
                                  // RideModel.id(participantsIds: [userId], isCompleted: false, title: rideTitle, authorId: userId),
                                  RideModel.id(
                                    //TODO   add DateTime rideDate, TimeOfDay rideStartTime, String rideMapLink, String rideStartLocationName, String rideStartLocationId to DB (variables already exist and are filled with data)
                                    participantsIds: [userId],
                                    isCompleted: false,
                                    title: titleController.text,
                                    authorId: userId,
                                    distance: rideDistance,
                                    climbing: rideClimbing,
                                    createdAt: DateTime.now(),
                                    tags: rideTags,
                                    averageSpeed: rideAverageSpeed,
                                    duration: rideDuration,
                                  ),
                                  userController);
                              Navigator.of(context).pop();
                            }
                          : (userIsParticipating
                              ? () async {
                                  // user that is participating clicked on "Leave ride"
                                  await leaveRide(ride!, userController);
                                  Navigator.of(context).pop();
                                }
                              : () async {
                                  await joinRide(ride!, userController);
                                  Navigator.of(context).pop();
                                })),
            ),
          );
        });
      },
    );
  }
}
