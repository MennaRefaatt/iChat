
import '../../../../../core/secure_storage/secure_keys.dart';
import '../../../../../core/secure_storage/secure_storage.dart';
import '../../../../../core/shared_preferences/my_shared.dart';
import '../../../../../core/shared_preferences/my_shared_keys.dart';
import '../models/register_model.dart';

abstract class DSRegisterLocal {
  Future<void> cacheUserToken(String token);
  Future<void> saveRegisterDataToLocal({required RegisterData registerData});
  Future<RegisterData?> getCachedUser();
  Future<void> clear();
}

class DSRegisterLocalImpl implements DSRegisterLocal {
  @override
  Future<void> cacheUserToken(String token) async {
    await SecureStorageService.writeData(SecureKeys.token, token);
  }

  @override
  Future<void> clear() async {
    SharedPref.clear();
    SecureStorageService.deleteData(SecureKeys.token);
  }

  @override
  Future<RegisterData?> getCachedUser() async {
    final id = SharedPref.getString(key: MySharedKeys.userId);
    final name = SharedPref.getString(key: MySharedKeys.userName);
    final email = SharedPref.getString(key: MySharedKeys.email);
    final token = await SecureStorageService.readData(SecureKeys.token);
    return RegisterData(name: name, email: email, token: token, id:id );
  }

  @override
  Future<void> saveRegisterDataToLocal(
      {required RegisterData registerData}) async {
    SharedPref.putString(key: MySharedKeys.userId, value: registerData.id!);
    SharedPref.putString(key: MySharedKeys.userName, value: registerData.name!);
    SharedPref.putString(key: MySharedKeys.email, value: registerData.email!);
    await SecureStorageService.writeData(SecureKeys.token, registerData.token!);
  }
}
