import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_with_me/controllers/user_state_controller.dart';
import 'package:ride_with_me/pages/ride_view_page.dart';
import 'package:ride_with_me/utils/prefix_text_input_field.dart';
import 'package:ride_with_me/utils/text.dart';

import '../models/user_model.dart';
import '../utils/button.dart';
import '../utils/db_utils.dart';
import '../utils/ride_icon_button.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    // TODO: refreshing on profile page should fetch current User from DB and update the userStateController
    // TODO: or could be wrapped with future builder with initial data set to userController.user, and then the value would be refreshed
    //  e.g. if we create a ride, it will be updated directly (in userStateController ??)
    //       but if a ride we participated in is marked as completed, this won't be displayed in profile
    //       (since profile page uses info from userStateController.user, where the user is fetched after logging in)

    // return Consumer<UserStateController>(
    return Consumer<UserStateController>(
      builder: (context, userController, child) {
        return FutureBuilder<UserModel?>(
          // we might wanna load rides with authors for display (otherwise author = null)
          // future: getFullUserById(userController.user.getId()),
            future: getFullUserWithAuthorById(userController.user.getId()),
            initialData: userController.user,
            builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
              // TODO: add snapshot.hasError and other checks?

              final user = snapshot.data!;
              userController.user = user;
              final aboutMeController = TextEditingController(text: user.aboutMe);
              final facebookController = TextEditingController(
                  text: user.aboutMe); //todo change to correct field when added to db, use ' ' (with space) as default value
              final stravaController = TextEditingController(text: user.aboutMe);
              final instagramController = TextEditingController(text: user.aboutMe);
              final googleController = TextEditingController(text: user.aboutMe);
              final slackController = TextEditingController(text: user.aboutMe);
              // TODO: probably shouldn't be able to change email - otherwise we have to also change the document ID (since it uses email)
              final emailController = TextEditingController(text: user.email);

              return Scaffold(
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            LargeText('${user.firstName} ${user.lastName}'),
                            IconButton(
                              icon: Icon(Icons.settings_rounded, color: Theme
                                  .of(context)
                                  .unselectedWidgetColor),
                              onPressed: () async {
                                setState(() {
                                  isEditing = true;
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(user.avatarURL),
                              maxRadius: 60,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MediumText('Created rides'),
                                Text(user.createdRidesIds.length.toString()),
                                SizedBox(height: 7),
                                MediumText('Joined rides'),
                                Text(user.joinedRidesIds.length.toString()),
                                SizedBox(height: 7),
                                MediumText('Completed rides'),
                                Text(user.completedRidesIds.length.toString()),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 30,),
                        MediumText('About me'),
                        SizedBox(height: 15,),
                        // TODO: right now createdRidesIds.length != createdRides.length
                        //       in general (after fixing stuff), that should be equal however
                        //       - if we don't fetch created/joined/completedRides, the length will be 0,
                        //         so it's better to use createdRidesIds.length, because async fetch won't change the number from 0 to X

                        if (isEditing) TextFormField(
                          // would have to change to currentUserId == userId, if we wanted to allow viewing other people's profiles
                          enabled: true,
                          controller: aboutMeController,
                          onFieldSubmitted: (text) {
                            aboutMeController.text = text;
                            // print("about me changed: ${aboutMeController.text}");
                          },
                        ) else
                          Text(user.aboutMe),

                        if (isEditing) ...[
                          PrefixTextInputField(
                              initialValue: 'facebook.com/ ', controller: facebookController, mediaIcon: FontAwesomeIcons.facebook),
                          PrefixTextInputField(
                              initialValue: 'strava.com/ ', controller: stravaController, mediaIcon: FontAwesomeIcons.strava),
                          PrefixTextInputField(
                              initialValue: 'instagram.com/ ', controller: instagramController, mediaIcon: FontAwesomeIcons.instagram),
                          PrefixTextInputField(
                              initialValue: 'google.com/ ', controller: googleController, mediaIcon: FontAwesomeIcons.google),
                          PrefixTextInputField(initialValue: 'slack.com/ ', controller: slackController, mediaIcon: FontAwesomeIcons.slack),
                          PrefixTextInputField(initialValue: 'email ', controller: emailController, mediaIcon: FontAwesomeIcons.envelope),
                        ] else
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  RideIconButton(icon: FontAwesomeIcons.facebook,
                                      accountLink: 'facebook.com/' + user.lastName,
                                      serviceName: 'Facebook'), //TODO add username from db
                                  RideIconButton(
                                      icon: FontAwesomeIcons.strava, accountLink: 'strava.com/' + user.lastName, serviceName: 'Strava'),
                                  RideIconButton(icon: FontAwesomeIcons.instagram,
                                      accountLink: 'instagram.com/' + user.lastName,
                                      serviceName: 'Instagram'),
                                  RideIconButton(
                                      icon: FontAwesomeIcons.google, accountLink: 'google.com/' + user.lastName, serviceName: 'Google'),
                                  RideIconButton(
                                      icon: FontAwesomeIcons.slack, accountLink: 'slack.com/' + user.lastName, serviceName: 'Slack'),
                                  RideIconButton(icon: FontAwesomeIcons.envelope, accountLink: user.email, serviceName: 'Email'),
                                ],
                              ),
                            ),
                          ),


                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: MediumText('Completed rides'),
                        ),

                        // TODO: place into separate method to remove copy-paste (created rides have author "You" instead of author.fullName)
                        // also use this condition to display a message if there are no rides
                        (user.completedRides.length == 0)
                            ? Text('No rides.')
                            : ListView(
                          shrinkWrap: true,
                          children: user.completedRides.map((ride) {
                            return ListTile(
                                title: Text(ride.title),
                                subtitle: Text("author: ${ride.author?.getFullName()}, participants: ${ride.participantsIds.length}"),
                                onTap: () =>
                                    Navigator.of(context).push(MaterialPageRoute(
                                      // builder: (_) => RideViewPage(rideBeingEdited: rideModel)
                                        builder: (_) =>
                                            ChangeNotifierProvider.value(
                                              value: Provider.of<UserStateController>(context),
                                              child: RideViewPage(rideBeingEdited: ride),
                                            ))));
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: isEditing ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: SubmitButton(
                      value: "SAVE CHANGES",
                      callback: () async {
                        await userUpdateAboutMe(userController, aboutMeController.text);
                        setState(() {
                          isEditing = false;
                        });
                      }),
                ) : SizedBox(),
              );
            });
      },
    );
  }
}
