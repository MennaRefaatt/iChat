
import '../../data/models/login_data.dart';
import '../entities/login_request_entity.dart';
import '../repo_base/login_repo_base.dart';
class LoginUseCase {
  final LoginRepoBase loginRepo;
  LoginUseCase({required this.loginRepo});

  Future<LoginData?> execute(LoginRequestEntity loginRequestEntity) async{
    return loginRepo.login(loginRequestEntity);
  }
}
