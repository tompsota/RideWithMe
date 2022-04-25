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
      // ..createdRides = (json['createdRides'] as List<dynamic>)
      //     .map((e) => RideModel.fromJson(e as Map<String, dynamic>))
      //     .toList()
      // ..joinedRides = (json['joinedRides'] as List<dynamic>)
      //     .map((e) => RideModel.fromJson(e as Map<String, dynamic>))
      //     .toList()
      // ..completedRides = (json['completedRides'] as List<dynamic>)
      //     .map((e) => RideModel.fromJson(e as Map<String, dynamic>))
      //     .toList();

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'aboutMe': instance.aboutMe,
      'createdRidesIds': instance.createdRidesIds,
      'joinedRidesIds': instance.joinedRidesIds,
      'completedRidesIds': instance.completedRidesIds,
      // 'createdRides': instance.createdRides.map((e) => e.toJson()).toList(),
      // 'joinedRides': instance.joinedRides.map((e) => e.toJson()).toList(),
      // 'completedRides': instance.completedRides.map((e) => e.toJson()).toList(),
    };
