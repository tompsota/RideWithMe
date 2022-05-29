import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ride_with_me/models/user_model.dart';
import 'package:uuid/uuid.dart';

import '../data_layer/dtos/ride.dart';

typedef Unit = int;

class RideModel {

  String id;
  String title;
  String authorId;
  DateTime createdAt;
  List<String> participantsIds;
  bool isCompleted;

  // TODO: change data type? (to dynamic? will DB accept this? maybe 'json' data type?)
  // String location;

  // double latitude;
  // double longitude;

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
    this.author,
    this.participants = const [],
  }): id = Uuid().v4();

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
      id: ride.id
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
      tags: tags
  );

  // factory RideModel.fromJson(Map<String, dynamic> json) => _$RideModelFromJson(json);
  // Map<String, dynamic> toJson() => _$RideModelToJson(this);
}
