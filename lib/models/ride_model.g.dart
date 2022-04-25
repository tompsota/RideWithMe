// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RideModel _$RideModelFromJson(Map<String, dynamic> json) => RideModel(
      createdAt: DateTime.parse(json['createdAt'] as String),
      averageSpeed: json['averageSpeed'] as int,
      distance: json['distance'] as int,
      climbing: json['climbing'] as int,
      duration: Duration(microseconds: json['duration'] as int),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      participantsIds: (json['participantsIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isCompleted: json['isCompleted'] as bool,
      title: json['title'] as String,
      authorId: json['authorId'] as String,
      id: json['id'] as String,
    );

Map<String, dynamic> _$RideModelToJson(RideModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'authorId': instance.authorId,
      'createdAt': instance.createdAt.toIso8601String(),
      'participantsIds': instance.participantsIds,
      'isCompleted': instance.isCompleted,
      'averageSpeed': instance.averageSpeed,
      'distance': instance.distance,
      'climbing': instance.climbing,
      'duration': instance.duration.inMicroseconds,
      'tags': instance.tags,
    };
