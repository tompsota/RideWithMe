import 'package:ride_with_me/domain_layer/models/ride_model.dart';
import 'package:uuid/uuid.dart';

import '../../data_layer/dtos/user.dart';

class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatarUrl;
  final String aboutMe;

  final String facebookAccount;
  final String googleAccount;
  final String instagramAccount;
  final String slackAccount;
  final String stravaAccount;

  final List<String> createdRidesIds;
  final List<String> joinedRidesIds;
  final List<String> completedRidesIds;

  late List<RideModel> createdRides;
  late List<RideModel> joinedRides;
  late List<RideModel> completedRides;

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
    this.createdRides = const[],
    this.joinedRides = const[],
    this.completedRides = const[],
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
    this.createdRides = const[],
    this.joinedRides = const[],
    this.completedRides = const[],
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

  /// Returns a copy of this UserModel with the given values updated.
  UserModel copyWith({
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
    return UserModel(
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

  String getFullName() => firstName + " " + lastName;
}
