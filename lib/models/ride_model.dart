import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ride_with_me/models/user_model.dart';
import 'package:ride_with_me/utils/db_utils.dart';
import 'package:uuid/uuid.dart';

part 'ride_model.g.dart';

// use this command to generate json_serializable stuff:
// flutter pub run build_runner build

// TODO: needs to be immutable? then we need to create a new instance every time we want to change an attribute (e.g. add new participant)
@immutable
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
  //
  // final DateTime createdAt;
  //
  // // // ID's (emails) of participants/users
  @JsonKey(name: 'participantsIds')
  final List<String> participantsIds;

  @JsonKey(name: 'isCompleted')
  final bool isCompleted;

  // TODO: change data type? (to dynamic? will DB accept this? maybe 'json' data type?)
  // final String location;
  //
  // // in km/h
  // final double avgSpeed;
  // // in km
  // final double distance;
  // // in meters
  // final double climbing;
  // // e.g. 4h 20min
  // final Duration duration;
  //
  // final List<String> tags;

  @JsonKey(ignore: true)
  late UserModel? author;
  @JsonKey(ignore: true)
  late List<UserModel> participants;

  RideModel({required this.participantsIds, this.participants = const [], required this.isCompleted, required this.title, required this.authorId, this.author, required this.id});
  RideModel.id({required this.participantsIds, this.participants = const [], required this.isCompleted, required this.title, required this.authorId, this.author}): id = Uuid().v1();

  factory RideModel.fromJson(Map<String, dynamic> json) => _$RideModelFromJson(json);
  Map<String, dynamic> toJson() => _$RideModelToJson(this);


  // RideModel _$RideModelFromJson(Map<String, dynamic> json) => RideModel(
//       json['id'] as String,
//       json['name'] as String,
//     );
//
// Map<String, dynamic> _$RideModelToJson(RideModel instance) => <String, dynamic>{
//       'id': instance.id,
//       'name': instance.title,
//     };


//   factory RideModel.fromJson(Map<String, dynamic> json) => RideModel(
//     id: json['id'] as String,
//     title: json['title'] as String,
//     authorId: json['authorId'] as String,
//     author: null,
//     participantsIds: json['participantsIds'] as List<String>,
//     participants: null,
//     isCompleted: json['isCompleted'] as bool
//   );

}