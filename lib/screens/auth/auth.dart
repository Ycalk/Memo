import 'package:flutter/material.dart';

enum AuthMode {
  login,
  register,
}

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  AuthMode _authMode = AuthMode.login;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}