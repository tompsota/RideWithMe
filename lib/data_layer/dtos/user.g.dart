// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      avatarUrl: json['avatarUrl'] as String,
      facebookAccount: json['facebook'] as String,
      googleAccount: json['google'] as String,
      instagramAccount: json['instagram'] as String,
      slackAccount: json['slack'] as String,
      stravaAccount: json['strava'] as String,
      aboutMe: json['aboutMe'] as String? ?? 'No info',
      createdRidesIds: (json['createdRidesIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      joinedRidesIds: (json['joinedRidesIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      completedRidesIds: (json['completedRidesIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'avatarUrl': instance.avatarUrl,
      'aboutMe': instance.aboutMe,
      'facebook': instance.facebookAccount,
      'strava': instance.stravaAccount,
      'instagram': instance.instagramAccount,
      'google': instance.googleAccount,
      'slack': instance.slackAccount,
      'createdRidesIds': instance.createdRidesIds,
      'joinedRidesIds': instance.joinedRidesIds,
      'completedRidesIds': instance.completedRidesIds,
    };
