import 'package:flutter/material.dart';
import 'package:memo_mind/services/auth/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('Sign out'),
          onPressed: AuthService().signOut,
        ),
      )
    );
  }
}