import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import '../core/constants.dart';
import '../model/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _fireStore;

  AuthRepository(this._auth, this._fireStore);

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signUp(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) throw AuthException("User creation failed.");

      final allUsers = await _fireStore.collection("users").get();
      final role = allUsers.docs.isEmpty ? "admin" : "user";

      final userModel = UserModel(
        uid: user.uid,
        email: email,
        role: role,
        profileImageUrl: AppStrings.imageProfileUrl,
      );

      await _fireStore.collection("users").doc(user.uid).set({
        ...userModel.toMap(),
        "createdAt": FieldValue.serverTimestamp(),
      });

      await _cacheUserToHive(userModel);
      return user;
    } catch (e) {
      throw AuthException("Sign Up Failed: ${_parseError(e)}");
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final doc =
          await _fireStore
              .collection("users")
              .doc(userCredential.user!.uid)
              .get();

      final userModel = UserModel.fromFireStore(doc);
      await _cacheUserToHive(userModel);
    } catch (e) {
      throw AuthException("Sign In Failed: ${_parseError(e)}");
    }
  }

  Future<void> deleteUserById(String uid) async {
    try {
      await _fireStore.collection("users").doc(uid).delete();
      await Hive.box<UserModel>('usersBox').delete(uid);
    } catch (e) {
      throw AuthException("Delete Failed: ${_parseError(e)}");
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw AuthException("Password Reset Failed: ${_parseError(e)}");
    }
  }

  Future<void> updateUserProfile({
    required String uid,
    required String email,
    required String profileImageUrl,
  }) async {
    try {
      await _fireStore.collection("users").doc(uid).update({
        "email": email,
        "profileImageUrl": profileImageUrl,
      });

      final usersBox = Hive.box<UserModel>('usersBox');
      final localUser = usersBox.get(uid);

      if (localUser != null) {
        localUser.email = email;
        localUser.profileImageUrl = profileImageUrl;
        await usersBox.put(uid, localUser);
      }
    } catch (e) {
      throw AuthException("Update Failed: ${_parseError(e)}");
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await Hive.box<UserModel>('usersBox').clear();
    } catch (e) {
      throw AuthException("Sign Out Failed: ${_parseError(e)}");
    }
  }

  Future<void> _cacheUserToHive(UserModel user) async {
    final usersBox = Hive.box<UserModel>('usersBox');
    await usersBox.put(user.uid, user);
  }

  String _parseError(Object e) {
    return e.toString().replaceFirst('Exception: ', '');
  }
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => message;
}
