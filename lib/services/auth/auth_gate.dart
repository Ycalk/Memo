import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memo_mind/screens/auth/auth.dart';
import 'package:memo_mind/screens/home/home.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData) {
          return const HomePage();
        } else {
          return const AuthenticationPage();
        }
      },
    );
  }
}