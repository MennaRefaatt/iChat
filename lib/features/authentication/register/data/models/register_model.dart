import 'package:json_annotation/json_annotation.dart';

part 'register_model.g.dart';

@JsonSerializable()
class RegisterData {
  String? id;
  String? name;
  String? email;
  String? token;

  RegisterData({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
  });
  factory RegisterData.fromJson(Map<String, dynamic> json) =>
      _$RegisterDataFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterDataToJson(this);
}
