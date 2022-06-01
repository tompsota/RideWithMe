import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_with_me/components/profile_expansion_panel.dart';
import 'package:ride_with_me/controllers/user_state_controller.dart';
import 'package:ride_with_me/utils/prefix_text_input_field.dart';
import 'package:ride_with_me/utils/text.dart';

import '../components/user_contact_icons.dart';
import '../utils/button.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserStateController>(builder: (context, userController, child) {
      // return FutureBuilder<UserModel?>(
      //   // we might wanna load rides with authors for display (otherwise author = null)
      //   // future: getFullUserById(userController.user.getId()),
      //     future: getFullUserWithAuthorById(userController.user.getId()),
      //     initialData: userController.user,
      //     builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
      // TODO: add snapshot.hasError and other checks?

      final user = userController.user;
      // userController.user = user;
      final aboutMeController = TextEditingController(text: user.aboutMe);
      final facebookController = TextEditingController(text: ' ' + user.facebookAccount);
      final stravaController = TextEditingController(text: ' ' + user.stravaAccount);
      final instagramController = TextEditingController(text: ' ' + user.instagramAccount);
      final googleController = TextEditingController(text: ' ' + user.googleAccount);
      final slackController = TextEditingController(text: ' ' + user.slackAccount);
      // TODO: should be able to change email ? we would have to change also gmail login,
      //  since we fetch user based on firebaseAuth.user.email (so the firebaseAuth email has to match the 'usersCollection.userDocument.email')
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
                      icon: Icon(Icons.settings_rounded, color: Theme.of(context).unselectedWidgetColor),
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
                      backgroundImage: NetworkImage(user.avatarUrl),
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
                SizedBox(
                  height: 30,
                ),
                MediumText('About me'),
                SizedBox(
                  height: 15,
                ),

                if (isEditing)
                  TextFormField(
                    // would have to change to currentUserId == userId, if we wanted to allow viewing other people's profiles
                    enabled: true,
                    controller: aboutMeController,
                    onFieldSubmitted: (text) {
                      aboutMeController.text = text;
                      // print("about me changed: ${aboutMeController.text}");
                    },
                  )
                else
                  Text(user.aboutMe),

                if (isEditing) ...[
                  PrefixTextInputField(
                      initialValue: 'facebook.com/ ', controller: facebookController, mediaIcon: FontAwesomeIcons.facebook),
                  PrefixTextInputField(initialValue: 'strava.com/ ', controller: stravaController, mediaIcon: FontAwesomeIcons.strava),
                  PrefixTextInputField(
                      initialValue: 'instagram.com/ ', controller: instagramController, mediaIcon: FontAwesomeIcons.instagram),
                  PrefixTextInputField(initialValue: 'google.com/ ', controller: googleController, mediaIcon: FontAwesomeIcons.google),
                  PrefixTextInputField(initialValue: 'slack.com/ ', controller: slackController, mediaIcon: FontAwesomeIcons.slack),
                  PrefixTextInputField(initialValue: 'email ', controller: emailController, mediaIcon: FontAwesomeIcons.envelope),
                ] else
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: UserContactIcons(user: user),
                  ),
                // TODO: ExpansionPanelList might only (easily) work as Stateful,
                ProfileExpansionPanel(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: isEditing
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: SubmitButton(
                    value: "SAVE CHANGES",
                    callback: () async {
                      // TODO: use UsersRepository method
                      // await userUpdateAboutMe(userController, aboutMeController.text);
                      setState(() {
                        isEditing = false;
                      });
                    }),
              )
            : SizedBox(),
      );
    });
    //   },
    // );
  }
}
