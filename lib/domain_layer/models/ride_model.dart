import 'package:flutter/material.dart';
import 'package:ride_with_me/domain_layer/models/user_model.dart';
import 'package:uuid/uuid.dart';

import '../../data_layer/dtos/ride.dart';

typedef Unit = int;

class RideModel {
  String id;
  String title;
  String authorId;
  DateTime createdAt;
  List<String> participantsIds;
  bool isCompleted;

  String rideStartLocationName;
  String rideMapLink;
  DateTime rideDate;
  String rideStartTime;

  Unit averageSpeed;
  Unit distance;
  Unit climbing;
  Duration duration;
  List<String> tags;

  late UserModel? author;
  late List<UserModel> participants;

  RideModel({
    required this.createdAt,
    required this.averageSpeed,
    required this.distance,
    required this.climbing,
    required this.duration,
    required this.tags,
    required this.participantsIds,
    required this.isCompleted,
    required this.title,
    required this.authorId,
    required this.id,
    required this.rideStartLocationName,
    required this.rideMapLink,
    required this.rideDate,
    required this.rideStartTime,
    this.author,
    this.participants = const [],
  });

  RideModel.id({
    required this.createdAt,
    required this.averageSpeed,
    required this.distance,
    required this.climbing,
    required this.duration,
    required this.tags,
    required this.participantsIds,
    required this.isCompleted,
    required this.title,
    required this.authorId,
    required this.rideStartLocationName,
    required this.rideMapLink,
    required this.rideDate,
    required this.rideStartTime,
    this.author,
    this.participants = const [],
  }) : id = Uuid().v4();

  factory RideModel.fromDto(Ride ride) => RideModel(
        createdAt: ride.createdAt,
        averageSpeed: ride.averageSpeed,
        distance: ride.distance,
        climbing: ride.climbing,
        duration: ride.duration,
        tags: ride.tags,
        participantsIds: ride.participantsIds,
        isCompleted: ride.isCompleted,
        title: ride.title,
        authorId: ride.authorId,
        id: ride.id,
        rideStartLocationName: ride.rideStartLocationName,
        rideMapLink: ride.rideMapLink,
        rideDate: ride.rideDate,
        rideStartTime: ride.rideStartTime,
      );

  Ride toDto() => Ride(
        id: id,
        title: title,
        authorId: authorId,
        participantsIds: participantsIds,
        isCompleted: isCompleted,
        averageSpeed: averageSpeed,
        distance: distance,
        climbing: climbing,
        duration: duration,
        tags: tags,
        rideStartLocationName: rideStartLocationName,
        rideMapLink: rideMapLink,
        rideDate: rideDate,
        rideStartTime: rideStartTime,
      );

  TimeOfDay get startTime {
    return TimeOfDay(
        hour: int.parse(rideStartTime.split(":")[0]),
        minute: int.parse(rideStartTime.split(":")[1])
    );
  }
}
