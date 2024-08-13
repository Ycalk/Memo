import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memo_mind/presentation/screens/auth/auth.dart';
import 'package:memo_mind/presentation/screens/home/home.dart';
import 'package:memo_mind/services/auth/auth_service.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          AuthService().currentUser;
          return const HomePage();
        }
        return const AuthenticationPage();
      },
    );
  }
}