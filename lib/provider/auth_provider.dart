import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';
import '../repository/auth_respository.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.read(firebaseAuthProvider),
    ref.read(firestoreProvider),
  );
});

final authStateProvider = StreamProvider<UserModel?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final fireStore = ref.watch(firestoreProvider);
  final usersBox = Hive.box<UserModel>('usersBox');

  return auth.authStateChanges().asyncMap((user) async {
    if (user == null) return null;

    try {
      final userDoc = await fireStore.collection("users").doc(user.uid).get();
      if (!userDoc.exists) return null;

      final userModel = UserModel.fromFireStore(userDoc);
      await usersBox.put(userModel.uid, userModel);
      return userModel;
    } catch (e) {
      return usersBox.get(user.uid);
    }
  });
});

final allUsersProvider = FutureProvider<List<UserModel>>((ref) async {
  final usersBox = Hive.box<UserModel>('usersBox');

  try {
    // Try fetching from FireStore
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    final users =
        snapshot.docs.map((doc) => UserModel.fromFireStore(doc)).toList();

    // Cache to Hive
    await usersBox.clear();
    for (var user in users) {
      await usersBox.put(user.uid, user);
    }

    return users;
  } catch (e) {
    return usersBox.values.toList();
  }
});

final authStatusProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  return isLoggedIn;
});
