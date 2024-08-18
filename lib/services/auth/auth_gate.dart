import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memo/domain/provider.dart';
import 'package:memo/presentation/screens/auth/auth.dart';
import 'package:memo/presentation/screens/home/home.dart';
import 'package:memo/services/data/cloud.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Provider.of<NoteProvider>(context, listen: false)
          .setDatabase(CloudDataBase());
          return const HomePage();
        }
        return const AuthenticationPage();
      },
    );
  }
}