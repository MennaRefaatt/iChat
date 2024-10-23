import 'package:json_annotation/json_annotation.dart';

part 'login_data.g.dart';

@JsonSerializable()
class LoginData {
  int? userId;
  String? name;
  String? email;
  String? token;

  LoginData({
    required this.userId,
    required this.name,
    required this.email,
    required this.token,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);
}
