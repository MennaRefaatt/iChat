import '../../domain/repo_base/login_repo_base.dart';
import '../data_source/ds_login_local.dart';
import '../data_source/ds_login_remote.dart';
import '../../domain/entities/login_request_entity.dart';
import '../models/login_data.dart';

class LoginRepoImpl implements LoginRepoBase {
  final DSLoginRemote remoteDataSource;
  final DSLoginLocal localDataSource;

  LoginRepoImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<LoginData?> login(LoginRequestEntity loginRequestEntity) async {
    try {
      final user = await remoteDataSource.login(loginRequestEntity);
      // await localDataSource.saveDataToLocal(loginData: user!);
      // await localDataSource.getCachedUser();
       if (user?.token != null) {
        await localDataSource.saveDataToLocal(loginData: user!);
      }
      return user;
    } catch (error) {
      rethrow;
    }
  }

}
