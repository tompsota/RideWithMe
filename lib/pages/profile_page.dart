import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_with_me/controllers/user_state_controller.dart';

import '../models/user_model.dart';
import '../utils/db_utils.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

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
        future: getFullUserById(userController.user.getId()),
        initialData: userController.user,
        builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {

          final user = snapshot.data!;
          userController.user = user;
          final aboutMeController = TextEditingController(text: user.aboutMe);
          return Column(
            children: [
              Text('First name: ${user.firstName}'),
              Text('Last name: ${user.lastName}'),
              Text('Email: ${user.email}'),
              Text('About me: ${user.aboutMe}'),
              Text('Created rides: ${user.createdRidesIds.length}'),
              Text('Joined rides: ${user.joinedRidesIds.length}'),
              Text('Completed rides: ${user.completedRidesIds.length}'),
              TextFormField(
                // would have to change to currentUserId == userId, if we wanted to allow viewing other people's profiles
                enabled: true,
                controller: aboutMeController,
                onFieldSubmitted: (text) {
                  aboutMeController.text = text;
                  // print("about me changed: ${aboutMeController.text}");
                },
              ),
              TextButton(
                onPressed: () async => await userUpdateAboutMe(userController, aboutMeController.text),
                child: Text("Update About me"),
              ),
              // Text('authUser display name: ${authUser?.displayName}')
              // Image.network(user.user?.photoURL ?? 'https://upload.wikimedia.org/wikipedia/commons/c/c4/Orange-Fruit-Pieces.jpg'),
            ],
          );
        });
      },
    );
  }
}