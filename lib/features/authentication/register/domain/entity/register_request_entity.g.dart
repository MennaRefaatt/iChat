// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_request_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterRequestEntity _$RegisterRequestEntityFromJson(
        Map<String, dynamic> json) =>
    RegisterRequestEntity(
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$RegisterRequestEntityToJson(
        RegisterRequestEntity instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
    };
