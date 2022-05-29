import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'ride.g.dart';

// use this command to generate json_serializable stuff:
// 'flutter pub run build_runner build'

typedef Unit = int;

// TODO: fix description

/// {@template ride}
/// A single ride item.
///
/// Contains a [title], [id], a [isCompleted] flag, ...
///
/// If an [id] is provided, it cannot be empty. If no [id] is provided, one
/// will be generated.
///
/// [Ride]s are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [fromJson]
/// respectively.
/// {@endtemplate}
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
  final Unit averageSpeed;

  // in km
  @JsonKey(name: 'distance')
  final Unit distance;

  // in meters
  @JsonKey(name: 'climbing')
  final Unit climbing;

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
    required this.participantsIds, // could default to [authorId]
    required this.isCompleted, // could default to false
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

  /// Returns a copy of this ride with the given values updated.
  Ride copyWith({
    String? id,
    String? title,
    String? authorId,
    List<String>? participantsIds,
    bool? isCompleted,
    Unit? averageSpeed,
    Unit? distance,
    Unit? climbing,
    Duration? duration,
    List<String>? tags,
    String? rideStartLocationName,
    String? rideMapLink,
    DateTime? rideDate,
    String? rideStartTime,
  }) {
    return Ride(
      id: id ?? this.id,
      title: title ?? this.title,
      authorId: authorId ?? this.authorId,
      participantsIds: participantsIds ?? this.participantsIds,
      isCompleted: isCompleted ?? this.isCompleted,
      averageSpeed: averageSpeed ?? this.averageSpeed,
      distance: distance ?? this.distance,
      climbing: climbing ?? this.climbing,
      duration: duration ?? this.duration,
      tags: tags ?? this.tags,
      rideDate: rideDate ?? this.rideDate,
      rideMapLink: rideMapLink ?? this.rideMapLink,
      rideStartLocationName: rideStartLocationName ?? this.rideStartLocationName,
      rideStartTime: rideStartTime ?? this.rideStartTime,
    );
  }

  factory Ride.fromJson(Map<String, dynamic> json) => _$RideFromJson(json);

  Map<String, dynamic> toJson() => _$RideToJson(this);
}
