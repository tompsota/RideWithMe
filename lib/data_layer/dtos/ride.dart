import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'ride.g.dart';

// use this command to generate `toJson` and `fromJson` implementations:
// 'flutter pub run build_runner build'

/// A single ride item.
/// 
/// Rides are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [fromJson]
/// respectively.
@immutable
@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Ride {

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'authorId')
  final String authorId;

  // ID's of participants/users
  @JsonKey(name: 'participantsIds')
  final List<String> participantsIds;

  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  @JsonKey(name: 'isCompleted')
  final bool isCompleted;

  @JsonKey(name: 'location')
  final String rideStartLocationName;

  @JsonKey(name: 'date')
  final DateTime rideDate;

  @JsonKey(name: 'startTime')
  final String rideStartTime;

  @JsonKey(name: 'mapLink')
  final String rideMapLink;

  // in km/h
  @JsonKey(name: 'averageSpeed')
  final int averageSpeed;

  // in km
  @JsonKey(name: 'distance')
  final int distance;

  // in meters
  @JsonKey(name: 'climbing')
  final int climbing;

  // e.g. 4h 20min
  @JsonKey(name: 'duration')
  final Duration duration;

  @JsonKey(name: 'tags')
  final List<String> tags;

  Ride({
    required this.id,
    required this.title,
    required this.authorId,
    required this.participantsIds,
    required this.isCompleted,
    required this.averageSpeed,
    required this.distance,
    required this.climbing,
    required this.duration,
    required this.tags,
    required this.rideStartLocationName,
    required this.rideMapLink,
    required this.rideDate,
    required this.rideStartTime,
  }) : createdAt = DateTime.now();

  Ride.id({
    required this.title,
    required this.authorId,
    required this.participantsIds,
    required this.isCompleted,
    required this.averageSpeed,
    required this.distance,
    required this.climbing,
    required this.duration,
    required this.tags,
    required this.rideStartLocationName,
    required this.rideMapLink,
    required this.rideDate,
    required this.rideStartTime,
  })  : id = Uuid().v4(),
        createdAt = DateTime.now();

  factory Ride.fromJson(Map<String, dynamic> json) => _$RideFromJson(json);

  Map<String, dynamic> toJson() => _$RideToJson(this);
}
