
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:iChat/core/utils/safe_print.dart';

import '../../domain/entity/register_request_entity.dart';

abstract class DSRegisterRemote {
  Future<bool> register(RegisterRequestEntity registerRequestEntity);
}
class DSRegisterRemoteImpl implements DSRegisterRemote {
  DSRegisterRemoteImpl();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Future<bool> register(RegisterRequestEntity registerRequestEntity) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: registerRequestEntity.email,
          password: registerRequestEntity.password);
      safePrint("userCredential => ${userCredential.user?.uid}");
      if (userCredential.user != null) {
        String? deviceToken = await FirebaseMessaging.instance.getToken();
        await _firestore.collection('users').doc(userCredential.user?.uid).set({
          'email': registerRequestEntity.email,
          'name': registerRequestEntity.name,
          'token': deviceToken,
          "userId": DateTime.fromMillisecondsSinceEpoch(
              DateTime.now().millisecondsSinceEpoch).millisecondsSinceEpoch,
        });
      }
      return true;
    } catch (error) {
      rethrow;
    }
  }
}