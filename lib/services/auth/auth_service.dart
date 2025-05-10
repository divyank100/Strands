import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:threads_clone/services/database/database_service.dart';

import 'auth_gate.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  // get current user & userId
  User? getCurrentUser() => _auth.currentUser;

  String getCurrentUserId() => _auth.currentUser!.uid;

  //Login
  Future<UserCredential> loginEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //Register
  Future<UserCredential> registerEmailPassword(String email, String password) async{
    try{
      final userCredential=_auth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    }
    on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }

  // Logout
  Future<void> logout() async{
    await _auth.signOut();
    // Navigator.of(context).pushAndRemoveUntil(
    //   MaterialPageRoute(builder: (context) => const AuthGate()),
    //       (route) => false,
    // );
    // Navigator.of(context).pushReplacement(newRoute)
  }

  // Delete account
  Future<void> deleteAccount() async{
    User? user= getCurrentUser();
    if(user != null){
      // delete user's fata from firestore
      await DatabaseService().deleteUserInfoFromFirebase(user.uid);
      await user.delete();
    }
  }
}
