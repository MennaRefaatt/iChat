
import 'package:iChat/features/authentication/register/data/models/register_model.dart';

import '../../domain/entity/register_request_entity.dart';
import '../../domain/repo_base/repo_base.dart';
import '../data_source/ds_register_local.dart';
import '../data_source/ds_register_remote.dart';

class RegisterRepoImpl implements RegisterRepoBase {
  final DSRegisterRemote remoteDataSource;
  final DSRegisterLocal localDataSource;

  RegisterRepoImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  @override
  Future<RegisterData?> register(
      RegisterRequestEntity registerRequestEntity) async {
    final response = await remoteDataSource.register(registerRequestEntity);
    if (response != null) {
      return response;
    }
    return response;
  }
}
