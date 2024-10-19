
import 'package:iChat/core/utils/safe_print.dart';

import '../../domain/entity/register_request_entity.dart';
import '../../domain/repo_base/repo_base.dart';
import '../data_source/ds_register_remote.dart';

class RegisterRepoImpl implements RegisterRepoBase {
  final DSRegisterRemote remoteDataSource;

  RegisterRepoImpl({
    required this.remoteDataSource,
  });
  @override
  Future<bool> register(
      RegisterRequestEntity registerRequestEntity) async {
    final response = await remoteDataSource.register(registerRequestEntity);
    if (response ==true) {
      safePrint("response => $response");
      return response;
    }
    return response;
  }
}
