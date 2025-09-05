import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save user data
  Future<void> saveUserData(String userId, Map<String, dynamic> userData) async {
    await _firestore.collection('users').doc(userId).set(userData);
  }

  // Update user data
  Future<void> updateUserData(String userId, Map<String, dynamic> userData) async {
    await _firestore.collection('users').doc(userId).update(userData);
  }

  // Get user data
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    final docSnapshot = await _firestore.collection('users').doc(userId).get();
    return docSnapshot.data();
  }
}

