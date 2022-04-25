import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ride_with_me/models/ride_model.dart';
import 'package:uuid/uuid.dart';

part 'user_model.g.dart';

@immutable
@JsonSerializable(explicitToJson: true, includeIfNull: false)
class UserModel {
  // we use email as ID (primary key)
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'firstName')
  final String firstName;
  @JsonKey(name: 'lastName')
  final String lastName;

  // avatar / profile pic URL
  // final String avatarURL;

  // bike model
  // final String bike;

  // we might wanna display age
  // final DateTime birthDate;

  @JsonKey(name: 'aboutMe')
  final String aboutMe;

  // TODO: how to save links? (do we have a defined set of allowed domains, such as facebook, instagram, twitter etc. ?)
  // is it a map/JSON object in the format: { "instagram": "instagram.com/michalSali", "twitter": null, "facebook": ... } ??
  //  - if user can choose any domain (e.g. his own site), what icon do we display? (since domains like FB, IG have specific icons)
  //    - maybe we can let user choose from predefined set of domains that have icons (FB, IG, ...), and if he adds a different domain,
  //      we give some default icon?

  // ID's of rides that a user has created
  final List<String> createdRidesIds;

  // ID's of rides the user took part in
  // 'completedRides' / 'joinedRides' (Figma) ?
  // the user can click the 'I'll participate button' in RideDetail,
  //   and the ride's ID will be added to this list
  //   - when user clicks on RideDetail, we can check if user.joinedRides contains the ride's ID - that means he is currently participating
  //     - we could then display different button to leave the ride (and remove that ID from user.joinedRides)
  // then the number of completed rides is different though (basically joinedRides that have already happened)
  // - ideally we would keep a separate list for completedRides? but we would have to update that regularly based on starting date of a race
  // - as soon as ride happens, for every participant, we will remove that ride's ID from joinedRides and add it to completedRides
  // - in our case, we could start the update/recalculation as soon as user starts app (if other users could view our profile, then it would show old stats)
  // - maybe the easiest/smartest solution would be to make author label the ride as finished (ride could have attribute 'state': {finished, cancelled, pending, ...}),
  //    which will trigger the update
  //    - author also has the ability to cancel the race / postpone it (e.g. because of bad weather conditions / whatever)
  final List<String> joinedRidesIds;

  // rides the user has finished
  final List<String> completedRidesIds;

  @JsonKey(ignore: true)
  late List<RideModel> createdRides;
  @JsonKey(ignore: true)
  late List<RideModel> joinedRides;
  @JsonKey(ignore: true)
  late List<RideModel> completedRides;

  // TODO: save image to 'firebase/storage'
  // TODO: use RouteMaster ?

  UserModel({required this.email, required this.firstName, required this.lastName, this.aboutMe = 'No info',
    this.createdRidesIds = const [],
    this.joinedRidesIds = const [],
    this.completedRidesIds = const []
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  String getFullName() => firstName + " " + lastName;
  String getId() => email;
}