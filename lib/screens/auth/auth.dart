import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/uil.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:memo_mind/common/theme/colors.dart';
import 'package:memo_mind/common/theme/spacing.dart';
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Iconify(
                Ic.round_edit_note, 
                size: 120, 
                color: AppColors.description,
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                child: const Padding(
                  padding: EdgeInsets.all(AppSpacings.l),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Iconify(Uil.signin, size: 30, color: AppColors.description,),
                      SizedBox(width: 15),
                      Text('Sign in with Google',)
                    ],
                  ),
                ),
                onPressed: () async => AuthService().signInWithGoogle(),
              ),
              const SizedBox(height: 10),
              TextButton(
                child: const Text('Continue as guest', 
                  style: TextStyle(
                    color: AppColors.description,
                    fontSize: 16,)
                ),
                onPressed: () async => AuthService().signInAnon(),
              )
            ],
          ),
        )
      ),
    );
  }
}