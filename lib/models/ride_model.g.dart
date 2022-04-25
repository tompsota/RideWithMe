// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RideModel _$RideModelFromJson(Map<String, dynamic> json) => RideModel(
      participantsIds: (json['participantsIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      // participants: (json['participants'] as List<dynamic>?)
      //         ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
      //         .toList() ??
      //     const [],
      isCompleted: json['isCompleted'] as bool,
      title: json['title'] as String,
      authorId: json['authorId'] as String,
      // author: json['author'] == null
      //     ? null
      //     : UserModel.fromJson(json['author'] as Map<String, dynamic>),
      id: json['id'] as String,
    );

Map<String, dynamic> _$RideModelToJson(RideModel instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'title': instance.title,
    'authorId': instance.authorId,
    'participantsIds': instance.participantsIds,
    'isCompleted': instance.isCompleted,
  };

  // void writeNotNull(String key, dynamic value) {
  //   if (value != null) {
  //     val[key] = value;
  //   }
  // }
  //
  // writeNotNull('author', instance.author?.toJson());
  // val['participants'] = instance.participants.map((e) => e.toJson()).toList();
  return val;
}
