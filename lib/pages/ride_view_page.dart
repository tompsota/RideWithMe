import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_with_me/utils/checkbox_dialog.dart';
import 'package:ride_with_me/utils/ride_icon_button.dart';
import 'package:ride_with_me/utils/ride_number_picker.dart';
import 'package:ride_with_me/utils/title_button.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/user_state_controller.dart';
import '../models/ride_model.dart';
import '../utils/address_search.dart';
import '../utils/button.dart';
import '../utils/copy_link_button.dart';
import '../utils/db_utils.dart';
import '../utils/duration_picker.dart';
import '../utils/text.dart';

class RideViewPage extends StatelessWidget {
  final RideModel? rideBeingEdited;

  RideViewPage({Key? key, this.rideBeingEdited}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final ride = await getFullRide(rideBeingEdited!);
    return FutureBuilder<RideModel?>(
        future: getFullRide(rideBeingEdited),
        builder: (BuildContext context, AsyncSnapshot<RideModel?> snapshot) {
          return Consumer<UserStateController>(
            builder: (context, userController, child) {

              final ride = snapshot.data;

              final userId = userController.user.email;
              final isBeingCreated = rideBeingEdited == null;
              final userIsAuthor = ride?.authorId == userId;
              // ride can be edited by author and when it's being created (we can remove author later)
              final canBeEdited = isBeingCreated || userIsAuthor;
              final userIsParticipating = ride?.participantsIds.contains(userId) ?? false;

              final authorName = isBeingCreated ? userController.user.getFullName() : ride?.author?.getFullName() ?? "Unknown author";
              var rideTitle = isBeingCreated ? "$authorName's ride" : ride?.title ?? "Loading...";
              var titleController = TextEditingController(text: rideTitle);

              final showCompleteRideButton = userIsAuthor && (ride != null && !ride.isCompleted);

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
                        Expanded(
                            child: TitleButton(
                              isEnabled: isBeingCreated,
                              titleChangedCallback: (title) {
                                rideTitle = title;
                              },
                              textController: titleController,
                            )),
                        // FittedBox(
                        //   fit: BoxFit.fitWidth,
                        //   child: Text(
                        //     "Trip to " + _rideTitle,
                        //     style: TextStyle(
                        //       color: Theme.of(context).primaryColor,
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 36,
                        //     ),
                        //   ),
                        // ),
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
                                backgroundImage: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/c/c4/Orange-Fruit-Pieces.jpg'),
                                maxRadius: 30,
                              ),
                            ),
                            LargeText("by $authorName"),
                          ],
                        ),

                        // TODO: uncomment later, throwing errors on web (Unsupported operation: Trying to use the default webview implementation for TargetPlatform.linux but there isn't a default one)
                        // SizedBox(
                        //   height: 180,
                        //   width: 800,
                        //   child: Container(
                        //       child: WebView(
                        //         initialUrl: Uri.dataFromString(
                        //             '<html><body><iframe style="border:none" src="https://en.frame.mapy.cz/s/gozajafofo" width="700" height="466" frameborder="0"></iframe></body></html>',
                        //             mimeType: 'text/html')
                        //             .toString(),
                        //         javascriptMode: JavascriptMode.unrestricted,
                        //       )),
                        // ),

                        SizedBox(height: 20),
                        MediumText("With"),
                        Container(
                          constraints: BoxConstraints(maxHeight: 36, minWidth: double.infinity),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: ride == null
                                ? isBeingCreated
                                  ? Text("No participants yet, just creating the ride!")
                                  // : Text("Loading...")
                                  // some placeholder text/images before we load participants from DB
                                  : Stack(
                                      children: [
                                        ...List.generate(
                                          12,
                                              (index) => Positioned(
                                            left: index * 12,
                                            child: CircleAvatar(
                                              backgroundImage: index.isEven
                                                  ? NetworkImage('https://upload.wikimedia.org/wikipedia/commons/c/c4/Orange-Fruit-Pieces.jpg')
                                                  : NetworkImage('https://portswigger.net/cms/images/63/12/0c8b-article-211117-linux-rng.jpg'),
                                              maxRadius: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                : Stack(
                                  children: ride.participants.map((x) => Text(x.email)).toList(),
                                )
                          ),
                        ),
                        SizedBox(height: 50),
                        MediumText("Total distance"),
                        // TODO: how to obtain the value so that it can be passed to createRide() / RideModel ctor? use callback?
                        RideNumberPicker(minValue: 0, maxValue: 1000, units: "km", isEditable: canBeEdited),
                        SizedBox(height: 20),
                        MediumText("Expected average speed"),
                        RideNumberPicker(minValue: 15, maxValue: 40, units: "km/h", isEditable: canBeEdited),
                        SizedBox(height: 20),
                        MediumText("Total climbing"),
                        RideNumberPicker(minValue: 0, maxValue: 10000, units: "m", isEditable: canBeEdited),
                        SizedBox(height: 20),
                        MediumText("Expected duration"),
                        DurationPicker(isEditable: canBeEdited),
                        SizedBox(height: 20),
                        MediumText("Start Location"),
                        AddressSearch(initialValue: "", callback: (_) {}, isEditable: canBeEdited), //TODO add callback
                        SizedBox(height: 20),
                        MediumText("Tags"),
                        CheckboxDialog(isEditable: canBeEdited),

                        // link to share with friends should be displayed always? (or not when ride is complete? - to look at results?)
                        // author/host contact info should be displayed at all times?
                        // change 'author' to 'host' in display?
                        if (!canBeEdited) ...[
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
                                  RideIconButton(icon: FontAwesomeIcons.facebook),
                                  RideIconButton(icon: FontAwesomeIcons.strava),
                                  RideIconButton(icon: FontAwesomeIcons.instagram),
                                  RideIconButton(icon: FontAwesomeIcons.google),
                                  RideIconButton(icon: FontAwesomeIcons.slack),
                                  RideIconButton(icon: FontAwesomeIcons.envelope),
                                ],
                              ),
                            ),
                          ),
                        ],
                        if (showCompleteRideButton)
                          SubmitButton(
                            value: "Mark ride as complete",
                            callback: () async {
                              await completeRide(ride);
                              Navigator.of(context).pop();
                            },
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
                          callback:
                            isBeingCreated
                              ? () async {
                                // createRide in DB
                                await createRide(
                                  // RideModel.id(participantsIds: [userId], isCompleted: false, title: rideTitle, authorId: userId),
                                  RideModel.id(participantsIds: [userId], isCompleted: false, title: titleController.text, authorId: userId),
                                  userController
                                );
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
                                    }
                                )
                           ),
                ),
              );
            }
        );
      },
    );
  }
}
