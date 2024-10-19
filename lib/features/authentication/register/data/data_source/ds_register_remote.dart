
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iChat/core/utils/safe_print.dart';

import '../../domain/entity/register_request_entity.dart';
import '../models/register_model.dart';

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
        await _firestore.collection('users').doc(userCredential.user?.uid).set({
          'email': registerRequestEntity.email,
          'name': registerRequestEntity.name,
          //'token': registerRequestEntity.token,
        });
      }
      return true;
    } catch (error) {
      throw Exception('Register failed');
    }
  }
  // Future<RegisterData?> _getUserData(String? uid) async {
  //   if (uid == null) return null;
  //
  //   try {
  //     DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
  //
  //     // Check if the document exists
  //     if (userDoc.exists) {
  //       // Safely access the document data
  //       var userData = userDoc.data() as Map<String, dynamic>;
  //
  //       return RegisterData(
  //         id: uid,
  //         email: userData['email'] ?? '',  // Handle case where field may be missing
  //         name: userData['name'] ?? '',
  //         token: userData['token'] ?? '',
  //       );
  //     } else {
  //       safePrint('User document does not exist.');
  //       return null;
  //     }
  //   } catch (e) {
  //     safePrint('Error fetching user data: $e');
  //     return null;
  //   }
  // }


  Future<void> saveUserData(RegisterData user) async {
    await _firestore.collection('users').doc(user.id).update({
      'email': user.email,
      'name': user.name,
      //'token': user.token,
    });
  }
}