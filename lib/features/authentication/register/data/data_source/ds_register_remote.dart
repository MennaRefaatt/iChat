
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entity/register_request_entity.dart';
import '../models/register_model.dart';

abstract class DSRegisterRemote {
  Future<RegisterData?> register(RegisterRequestEntity registerRequestEntity);
}
class DSRegisterRemoteImpl implements DSRegisterRemote {
  DSRegisterRemoteImpl();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Future<RegisterData?> register(RegisterRequestEntity registerRequestEntity) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: registerRequestEntity.email,
          password: registerRequestEntity.password);
      return _getUserData(userCredential.user?.uid);
    } catch (error) {
      throw Exception('Register failed');
    }
  }
  Future<RegisterData?> _getUserData(String? uid) async {
    if (uid == null) return null;
    DocumentSnapshot userDoc =
    await _firestore.collection('users').doc(uid).get();
    return RegisterData(
      id: uid,
      email: userDoc['email'],
      name: userDoc['name'],
      token: userDoc['token'],
    );
  }

  Future<void> saveUserData(RegisterData user) async {
    await _firestore.collection('users').doc(user.id).update({
      'email': user.email,
      'name': user.name,
      'token': user.token,
    });
  }
}