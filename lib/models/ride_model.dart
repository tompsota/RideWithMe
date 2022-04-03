import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'ride_model.g.dart';

// use this command to generate json_serializable stuff:
// flutter pub run build_runner build

@immutable
@JsonSerializable(explicitToJson: true, includeIfNull: false)
class RideModel {
  @JsonKey(name: 'id')
  final String id;
  // @JsonKey(name: 'authorId')
  // final String authorId;
  @JsonKey(name: 'name')
  final String name;


  RideModel.id(this.name) : id = const Uuid().v1();

  const RideModel(this.id, this.name);

  factory RideModel.fromJson(Map<String, dynamic> json) => _$RideModelFromJson(json);
  Map<String, dynamic> toJson() => _$RideModelToJson(this);
}