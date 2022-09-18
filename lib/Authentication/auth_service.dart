import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'user_model.dart';

class AuthService {
  final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;
  String loginErrorCode = '';
  String signupErrorCode = '';
  String userEmail = '';
  String pass = '';

  theUser? userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }
    return theUser(user.uid, user.email);
  }

  Stream<theUser?>? get user {
    return firebaseAuth.authStateChanges().map(userFromFirebase);
  }

  Future<theUser?> signIn(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      userEmail = email;
      pass = password;
      loginErrorCode = '';
      return userFromFirebase(credential.user);
    } on FirebaseAuthException catch (e) {
      loginErrorCode = e.code;
    }
  }

  Future<theUser?> createUser(String email, String password) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      signupErrorCode = '';
      return userFromFirebase(credential.user);
    } on FirebaseAuthException catch (e) {
      signupErrorCode = e.code;
    }
  }

  Future deleteUser() async {
    signIn(userEmail, pass);
    User user = await firebaseAuth.currentUser!;
    user.delete();
  }

  Future<void> signOut() async {
    return await firebaseAuth.signOut();
  }
}
