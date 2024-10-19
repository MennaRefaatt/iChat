import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      return _getUserData(userCredential.user?.uid);
    } catch (error) {
      throw Exception('Login failed');
    }
  }

  Future<LoginData?> _getUserData(String? uid) async {
    if (uid == null) return null;
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(uid).get();
    return LoginData(
      userId: uid,
      email: userDoc['email'],
      name: userDoc['name'],
      token: uid,
    );
  }

  Future<void> saveUserData(LoginData user) async {
    await _firestore.collection('users').doc(user.userId).update({
      'email': user.email,
      'name': user.name,
      'token': user.token,
    });
  }
}
