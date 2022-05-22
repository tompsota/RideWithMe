import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ride_with_me/models/user_model.dart';
import 'package:uuid/uuid.dart';

part 'ride_model.g.dart';

// use this command to generate json_serializable stuff:
// flutter pub run build_runner build


typedef Unit = int;

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class RideModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'title')
  final String title;

  // ID (email) of author
  // change to authorId ?
  // should we also have (nullable) UserModel attribute so that we can assign the author/user after getting in from DB?
  //   - to access name, avatarURL, links etc.
  //   or do we keep that in a different class (e.g. RideInfo), that has e.g. attributes:
  //      - RideModel ride,
  //      - UserModel author (fetched from DB based on ride.author)
  //      - List<UserModel> participants (fetched from DB based on ride.participants)
  //   and we keep List<RideInfo> in a ChangeNotifier class?

  @JsonKey(name: 'authorId')
  final String authorId;

  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  // ID's (emails) of participants/users
  @JsonKey(name: 'participantsIds')
  final List<String> participantsIds;

  @JsonKey(name: 'isCompleted')
  final bool isCompleted;

  // TODO: change data type? (to dynamic? will DB accept this? maybe 'json' data type?)
  // final String location;

  // final double latitude;
  // final double longitude;

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

  @JsonKey(ignore: true)
  late UserModel? author;
  @JsonKey(ignore: true)
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
  }): id = Uuid().v1();

  factory RideModel.fromJson(Map<String, dynamic> json) => _$RideModelFromJson(json);
  Map<String, dynamic> toJson() => _$RideModelToJson(this);
}