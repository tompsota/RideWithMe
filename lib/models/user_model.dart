import 'package:uuid/uuid.dart';

import '../data_layer/dtos/user.dart';

class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatarUrl;
  final String aboutMe;

  String facebookAccount;
  String googleAccount;
  String instagramAccount;
  String slackAccount;
  String stravaAccount;

  final List<String> createdRidesIds;
  final List<String> joinedRidesIds;
  final List<String> completedRidesIds;

  UserModel({
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

  UserModel.id({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatarUrl,
    this.aboutMe = 'No info',
    required this.facebookAccount,
    required this.googleAccount,
    required this.instagramAccount,
    required this.slackAccount,
    required this.stravaAccount,
    this.createdRidesIds = const [],
    this.joinedRidesIds = const [],
    this.completedRidesIds = const [],
  }) : id = Uuid().v4();

  factory UserModel.fromDto(User user) => UserModel(
      id: user.id,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      avatarUrl: user.avatarUrl,
      aboutMe: user.aboutMe,
      facebookAccount: user.facebookAccount,
      googleAccount: user.googleAccount,
      instagramAccount: user.instagramAccount,
      slackAccount: user.slackAccount,
      stravaAccount: user.stravaAccount,
      createdRidesIds: user.createdRidesIds,
      joinedRidesIds: user.joinedRidesIds,
      completedRidesIds: user.completedRidesIds);

  User toDto() => User(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      avatarUrl: avatarUrl,
      aboutMe: aboutMe,
      facebookAccount: facebookAccount,
      googleAccount: googleAccount,
      instagramAccount: instagramAccount,
      slackAccount: slackAccount,
      stravaAccount: stravaAccount,
      createdRidesIds: createdRidesIds,
      joinedRidesIds: joinedRidesIds,
      completedRidesIds: completedRidesIds);

  String getFullName() => firstName + " " + lastName;
}
