
import 'package:iChat/features/authentication/login/data/models/login_data.dart';
import '../../../../../core/secure_storage/secure_keys.dart';
import '../../../../../core/secure_storage/secure_storage.dart';
import '../../../../../core/shared_preferences/my_shared.dart';
import '../../../../../core/shared_preferences/my_shared_keys.dart';

abstract class DSLoginLocal {
  Future<void> cacheUserToken(String token);

  Future<void> saveDataToLocal({required LoginData loginData});

  Future<LoginData?> getCachedUser();

  Future<void> clear();
}

class DSLoginLocalImpl implements DSLoginLocal {
  DSLoginLocalImpl();

  @override
  Future<void> cacheUserToken(String token) async {
    await SecureStorageService.writeData(SecureKeys.token,token);
  }

  @override
  Future<void> clear() async {
    SharedPref.clear();
    SecureStorageService.deleteData(SecureKeys.token);

  }

  @override
  Future<LoginData?> getCachedUser() async {
   SharedPref.getString(key: MySharedKeys.phone);
   SharedPref.getString(key: MySharedKeys.userName);
   SharedPref.getString(key: MySharedKeys.email);
   SecureStorageService.readData(SecureKeys.token);
   return null;

  }
  @override
  Future<void> saveDataToLocal({required LoginData loginData}) async {
    SharedPref.putString(key: MySharedKeys.email, value: loginData.email);
    SharedPref.putString(key: MySharedKeys.userId, value: loginData.userId.toString());
    SharedPref.putString(key: MySharedKeys.userName, value: loginData.name);
    await SecureStorageService.writeData(SecureKeys.token, loginData.token!);

  }
}
