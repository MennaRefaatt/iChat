import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:iChat/features/authentication/login/data/models/login_data.dart';
import '../../../../../core/secure_storage/secure_keys.dart';
import '../../../../../core/secure_storage/secure_storage.dart';
import '../../../../../core/shared_preferences/my_shared.dart';
import '../../../../../core/shared_preferences/my_shared_keys.dart';
import '../../../../../core/utils/safe_print.dart';

abstract class DSLoginLocal {
  Future<void> cacheUserToken(String token);
  Future<void> saveDataToLocal({required LoginData loginData});
  Future<void> getCachedUser();
  Future<void> clear();
}

class DSLoginLocalImpl implements DSLoginLocal {
  DSLoginLocalImpl();

  @override
  Future<void> cacheUserToken(String token) async {
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    if (deviceToken != null) {
      await SecureStorageService.writeData(SecureKeys.token, deviceToken);
    }
  }

  @override
  Future<void> clear() async {
    SharedPref.clear();
    SecureStorageService.deleteData(SecureKeys.token);
  }

  @override
  Future<void> getCachedUser() async {
    int? userId = SharedPref.getInt(key: MySharedKeys.userId);
    String? userName = SharedPref.getString(key: MySharedKeys.userName);
    String? email = SharedPref.getString(key: MySharedKeys.email);
    String? token = await SecureStorageService.readData(SecureKeys.token);
    safePrint("Cached User Data:");
    safePrint(
        " UserId: $userId, UserName: $userName, Email: $email, Token: $token");
  }

  @override
  Future<void> saveDataToLocal({required LoginData loginData}) async {
    SharedPref.putString(key: MySharedKeys.email, value: loginData.email);
    SharedPref.putInt(key: MySharedKeys.userId, value: loginData.userId);
    SharedPref.putString(key: MySharedKeys.userName, value: loginData.name);
    cacheUserToken(loginData.token!);
    // Logging saved user ID
    safePrint("Saving user ID: ${loginData.userId}");
     await getCachedUser();
  }
}
