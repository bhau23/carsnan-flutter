// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarModel _$CarModelFromJson(Map<String, dynamic> json) => CarModel(
  id: json['id'] as String,
  make: json['make'] as String,
  model: json['model'] as String,
  year: (json['year'] as num).toInt(),
  color: json['color'] as String,
  licensePlate: json['licensePlate'] as String,
  nickname: json['nickname'] as String?,
  type: $enumDecode(
    _$CarTypeEnumMap,
    json['type'],
    unknownValue: CarType.sedan,
  ),
  isDefault: json['isDefault'] as bool,
  createdAt: _dateTimeFromJson(json['createdAt'] as String),
  updatedAt: _dateTimeFromJson(json['updatedAt'] as String),
);

Map<String, dynamic> _$CarModelToJson(CarModel instance) => <String, dynamic>{
  'id': instance.id,
  'make': instance.make,
  'model': instance.model,
  'year': instance.year,
  'color': instance.color,
  'licensePlate': instance.licensePlate,
  'nickname': instance.nickname,
  'type': _$CarTypeEnumMap[instance.type]!,
  'isDefault': instance.isDefault,
  'createdAt': _dateTimeToJson(instance.createdAt),
  'updatedAt': _dateTimeToJson(instance.updatedAt),
};

const _$CarTypeEnumMap = {
  CarType.sedan: 'sedan',
  CarType.suv: 'suv',
  CarType.mini: 'mini',
};
