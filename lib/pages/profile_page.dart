import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_with_me/controllers/user_state_controller.dart';
import 'package:ride_with_me/pages/ride_view_page.dart';

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
        // we might wanna load rides with authors for display (otherwise author = null)
        // future: getFullUserById(userController.user.getId()),
        future: getFullUserWithAuthorById(userController.user.getId()),
        initialData: userController.user,
        builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {

          // TODO: add snapshot.hasError and other checks?

          final user = snapshot.data!;
          userController.user = user;
          final aboutMeController = TextEditingController(text: user.aboutMe);
          return Column(
            children: [
              Text('First name: ${user.firstName}'),
              Text('Last name: ${user.lastName}'),
              Text('Email: ${user.email}'),
              Text('About me: ${user.aboutMe}'),
              // TODO: right now createdRidesIds.length != createdRides.length
              //       in general (after fixing stuff), that should be equal however
              //       - if we don't fetch created/joined/completedRides, the length will be 0,
              //         so it's better to use createdRidesIds.length, because async fetch won't change the number from 0 to X
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

              // TODO: add 'Mark as complete' button to ride_view_page

              Text('Created rides'),
              ListView(
                shrinkWrap: true,
                children: user.createdRides.map((ride) {
                  return ListTile(
                      title: Text(ride.title),
                      subtitle: Text("author: You, participants: ${ride.participantsIds.length}"),
                      onTap: () =>
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                // TODO: still have to wrap it with ChangeNotifierProvider .....
                                // builder: (_) => RideViewPage(rideBeingEdited: rideModel)
                                  builder: (_) =>
                                      ChangeNotifierProvider.value(
                                        value: Provider.of<UserStateController>(context),
                                        child: RideViewPage(rideBeingEdited: ride),
                                      )
                              )
                          )
                  );
                }).toList(),
               ),
              Text('Joined rides'),
              ListView(
                shrinkWrap: true,
                children: user.joinedRides.map((ride) {
                  return ListTile(
                      title: Text(ride.title),
                      subtitle: Text("author: ${ride.author?.getFullName()}, participants: ${ride.participantsIds.length}"),
                      onTap: () =>
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                // builder: (_) => RideViewPage(rideBeingEdited: rideModel)
                                  builder: (_) =>
                                      ChangeNotifierProvider.value(
                                        value: Provider.of<UserStateController>(context),
                                        child: RideViewPage(rideBeingEdited: ride),
                                      )
                              )
                          )
                  );
                }).toList(),
              ),
              Text('Completed rides'),

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
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                      // builder: (_) => RideViewPage(rideBeingEdited: rideModel)
                                        builder: (_) =>
                                            ChangeNotifierProvider.value(
                                              value: Provider.of<UserStateController>(context),
                                              child: RideViewPage(rideBeingEdited: ride),
                                            )
                                    )
                                )
                        );
                      }).toList(),
                    ),
            ],
          );
        });
      },
    );
  }
}