

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInAnon() => _auth.signInAnonymously().then((value) => value.user);

  Future<User?> signInWithGoogle() async {
    final googleAccount = await GoogleSignIn().signIn();
    final googleAuth = await googleAccount?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await _auth.signInWithCredential(credential).then((value) => value.user);
  }

  Future<void> signOut() async => await _auth.signOut();
}