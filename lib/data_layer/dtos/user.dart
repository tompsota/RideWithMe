import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ride_with_me/models/ride_model.dart';
import 'package:uuid/uuid.dart';

part 'user.g.dart';

@immutable
@JsonSerializable(explicitToJson: true, includeIfNull: false)
class User {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'firstName')
  final String firstName;

  @JsonKey(name: 'lastName')
  final String lastName;

  @JsonKey(name: 'avatarUrl')
  final String avatarUrl;

  @JsonKey(name: 'aboutMe')
  final String aboutMe;

  @JsonKey(name: 'facebook')
  final String facebookAccount;

  @JsonKey(name: 'strava')
  final String stravaAccount;

  @JsonKey(name: 'instagram')
  final String instagramAccount;

  @JsonKey(name: 'google')
  final String googleAccount;

  @JsonKey(name: 'slack')
  final String slackAccount;

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

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatarUrl,
    required this.facebookAccount,
    required this.googleAccount,
    required this.instagramAccount,
    required this.slackAccount,
    required this.stravaAccount,
    this.aboutMe = 'No info',
    this.createdRidesIds = const [],
    this.joinedRidesIds = const [],
    this.completedRidesIds = const [],
  });

  User.id({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatarUrl,
    required this.facebookAccount,
    required this.googleAccount,
    required this.instagramAccount,
    required this.slackAccount,
    required this.stravaAccount,
    this.aboutMe = 'No info',
    this.createdRidesIds = const [],
    this.joinedRidesIds = const [],
    this.completedRidesIds = const [],
  }) : id = Uuid().v4();

  /// Returns a copy of this user with the given values updated.
  // TODO: might be a useless method for User
  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? avatarUrl,
    String? aboutMe,
    String? emailAccount,
    String? facebookAccount,
    String? googleAccount,
    String? instagramAccount,
    String? slackAccount,
    String? stravaAccount,
    List<String>? createdRidesIds,
    List<String>? joinedRidesIds,
    List<String>? completedRidesIds,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      aboutMe: aboutMe ?? this.aboutMe,
      facebookAccount: facebookAccount ?? this.facebookAccount,
      googleAccount: googleAccount ?? this.googleAccount,
      instagramAccount: instagramAccount ?? this.instagramAccount,
      slackAccount: slackAccount ?? this.slackAccount,
      stravaAccount: stravaAccount ?? this.stravaAccount,
      createdRidesIds: createdRidesIds ?? this.createdRidesIds,
      joinedRidesIds: joinedRidesIds ?? this.joinedRidesIds,
      completedRidesIds: completedRidesIds ?? this.completedRidesIds,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  String getFullName() => firstName + " " + lastName;
}
