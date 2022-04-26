// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      aboutMe: json['aboutMe'] as String? ?? 'No info',
      avatarURL: json['avatarURL'] as String,
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

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'avatarURL': instance.avatarURL,
      'aboutMe': instance.aboutMe,
      'createdRidesIds': instance.createdRidesIds,
      'joinedRidesIds': instance.joinedRidesIds,
      'completedRidesIds': instance.completedRidesIds,
    };
