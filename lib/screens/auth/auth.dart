import 'package:flutter/material.dart';
import 'package:memo_mind/services/auth/auth_service.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ElevatedButton(
          child: const Text('Continue with Google'),
          onPressed: () async => AuthService().signInWithGoogle()
        )
      ),
    );
  }
}