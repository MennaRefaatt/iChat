import 'package:json_annotation/json_annotation.dart';
part 'register_request_entity.g.dart';
@JsonSerializable()
class RegisterRequestEntity {
  final String name;
  final String email;
  final String password;

  RegisterRequestEntity({
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$RegisterRequestEntityToJson(this);
}