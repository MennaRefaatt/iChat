import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:iChat/core/utils/safe_print.dart';
import '../../domain/entities/login_request_entity.dart';
import '../models/login_data.dart';

abstract class DSLoginRemote {
  Future<LoginData?> login(LoginRequestEntity loginRequestEntity);
}

class DSLoginRemoteImpl implements DSLoginRemote {
  DSLoginRemoteImpl();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Future<LoginData?> login(LoginRequestEntity loginRequestEntity) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: loginRequestEntity.email,
          password: loginRequestEntity.password);
      await updateToken();
      return _getUserData(userCredential.user?.uid);
    } catch (error) {
      rethrow;
    }
  }

  Future<LoginData?> _getUserData(String? uid) async {
    if (uid == null) return null;
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(uid).get();
    if (!userDoc.exists) return null;
    // String? token = await _auth.currentUser?.getIdToken();
    String? token = await FirebaseMessaging.instance.getToken();
    return LoginData(
      userId: userDoc['userId'],
      email: userDoc['email'],
      name: userDoc['name'],
      token: token,
    );
  }
  Future<void> updateToken() async {
    try {
      // String? token = await _auth.currentUser?.getIdToken(true);
      String? token = await FirebaseMessaging.instance.getToken();
      await _firestore.collection('users').doc(_auth.currentUser?.uid).update({
        'token': token
      });
    } catch (error) {
      safePrint("Failed to update token: $error");
    }
  }
}
