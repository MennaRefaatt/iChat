import 'package:json_annotation/json_annotation.dart';

part 'login_request_entity.g.dart';
@JsonSerializable()
class LoginRequestEntity {
  final String email;
  final String password;

  const LoginRequestEntity({
    required this.email,
    required this.password,
  });
  factory LoginRequestEntity.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestEntityFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestEntityToJson(this);
}
