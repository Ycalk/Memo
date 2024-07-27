

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInAnon() async => await _auth.signInAnonymously();

  Future<UserCredential> signInWithEmail(String email, String password) async => 
    await _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<UserCredential> registerWithEmail(String email, String password) async =>
    await _auth.createUserWithEmailAndPassword(email: email, password: password);

  Future<void> signOut() async => await _auth.signOut();
}