import 'package:iChat/features/authentication/register/data/models/register_model.dart';

import '../entity/register_request_entity.dart';

abstract class RegisterRepoBase {
  Future<RegisterData?> register(RegisterRequestEntity registerRequestEntity);
}