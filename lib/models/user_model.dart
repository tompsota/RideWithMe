import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ride_with_me/models/ride_model.dart';
import 'package:uuid/uuid.dart';

part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class UserModel {

  // we use email as ID (primary key)
  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'firstName')
  final String firstName;

  @JsonKey(name: 'lastName')
  final String lastName;

  @JsonKey(name: 'avatarURL')
  final String avatarURL;

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
  // > the user can click the 'I'll participate button' in RideDetail,
  //   and the ride's ID will be added to this list
  final List<String> joinedRidesIds;

  // ID's of rides the uer has finished
  // > ride has to be marked as 'Completed' by the author - ride's ID will
  //   be removed from joinedRidesIds, and added to completedRidesIds
  final List<String> completedRidesIds;

  @JsonKey(ignore: true)
  late List<RideModel> createdRides;
  @JsonKey(ignore: true)
  late List<RideModel> joinedRides;
  @JsonKey(ignore: true)
  late List<RideModel> completedRides;

  UserModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatarURL,
    this.aboutMe = 'No info',
    this.createdRidesIds = const [],
    this.joinedRidesIds = const [],
    this.completedRidesIds = const [],
    this.createdRides = const [],
    this.joinedRides = const [],
    this.completedRides = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  String getFullName() => firstName + " " + lastName;
  String getId() => email;
}