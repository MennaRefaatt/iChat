
import '../../data/models/login_data.dart';
import '../entities/login_request_entity.dart';

abstract class LoginRepoBase {
  Future<LoginData?> login(LoginRequestEntity loginRequestEntity);
}