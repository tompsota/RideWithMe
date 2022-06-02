import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'user.g.dart';

/// A single user item.
///
/// Users are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [fromJson]
/// respectively.
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

  @JsonKey(name: 'facebookAccount')
  final String facebookAccount;

  @JsonKey(name: 'stravaAccount')
  final String stravaAccount;

  @JsonKey(name: 'instagramAccount')
  final String instagramAccount;

  @JsonKey(name: 'googleAccount')
  final String googleAccount;

  @JsonKey(name: 'slackAccount')
  final String slackAccount;

  // ID's of rides that a user has created
  final List<String> createdRidesIds;

  // ID's of rides the user is currently participating in
  // once a ride has been completed, the id is removed from the list
  final List<String> joinedRidesIds;

  // ID's of rides the user has finished - rides that a user had joined and
  // that had been completed (marked as completed by the author)
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

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
