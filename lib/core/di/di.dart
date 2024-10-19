import 'package:get_it/get_it.dart';
import '../../features/authentication/login/data/data_source/ds_login_local.dart';
import '../../features/authentication/login/data/data_source/ds_login_remote.dart';
import '../../features/authentication/login/data/repos_impl/login_repo.dart';
import '../../features/authentication/login/domain/repo_base/login_repo_base.dart';
import '../../features/authentication/login/domain/usecases/login_usecase.dart';
import '../../features/authentication/register/data/data_source/ds_register_remote.dart';
import '../../features/authentication/register/data/repo_impl/repo_register_impl.dart';
import '../../features/authentication/register/domain/repo_base/repo_base.dart';
import '../../features/authentication/register/domain/usecases/register_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {

  //login

  sl.registerLazySingleton<DSLoginRemote>(() => DSLoginRemoteImpl());
  sl.registerLazySingleton<DSLoginLocal>(() => DSLoginLocalImpl());
  sl.registerLazySingleton<LoginRepoBase>(
      () => LoginRepoImpl(remoteDataSource: sl(), localDataSource: sl()));
  sl.registerLazySingleton(() => LoginUseCase(loginRepo: sl<LoginRepoBase>()));

  // Register
  sl.registerLazySingleton(
      () => RegisterUseCase(registerRepo: sl<RegisterRepoBase>()));
  sl.registerLazySingleton<DSRegisterRemote>(() => DSRegisterRemoteImpl());
  sl.registerLazySingleton<RegisterRepoBase>(
    () => RegisterRepoImpl(remoteDataSource: sl(),),
  );

}
