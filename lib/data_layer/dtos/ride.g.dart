// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ride _$RideFromJson(Map<String, dynamic> json) => Ride(
      id: json['id'] as String,
      title: json['title'] as String,
      authorId: json['authorId'] as String,
      participantsIds: (json['participantsIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isCompleted: json['isCompleted'] as bool,
      averageSpeed: json['averageSpeed'] as int,
      distance: json['distance'] as int,
      climbing: json['climbing'] as int,
      duration: Duration(microseconds: json['duration'] as int),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      rideStartLocationName: json['location'] as String,
      rideMapLink: json['mapLink'] as String,
      rideDate: DateTime.parse(json['date'] as String),
      rideStartTime: json['startTime'] as String,
    );

Map<String, dynamic> _$RideToJson(Ride instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'authorId': instance.authorId,
      'participantsIds': instance.participantsIds,
      'isCompleted': instance.isCompleted,
      'location': instance.rideStartLocationName,
      'date': instance.rideDate.toIso8601String(),
      'startTime': instance.rideStartTime,
      'mapLink': instance.rideMapLink,
      'averageSpeed': instance.averageSpeed,
      'distance': instance.distance,
      'climbing': instance.climbing,
      'duration': instance.duration.inMicroseconds,
      'tags': instance.tags,
    };
