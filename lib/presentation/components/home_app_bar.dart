import 'package:flutter/material.dart';
import 'package:memo_mind/config/theme/colors.dart';
import 'package:memo_mind/config/theme/spacing.dart';
import 'package:memo_mind/services/auth/auth_service.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  CircleAvatar getAvatar(){
    final String? imageUrl = AuthService().currentUser?.photoURL;
    if (imageUrl !=null && imageUrl.isNotEmpty ) {
      return CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
          radius: AppSpacings.xxl,
        );
    }
    return const CircleAvatar(
      backgroundColor: AppColors.primary,
      radius: AppSpacings.xxl,
      child: Icon(Icons.person, size: AppSpacings.xxl,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(top: AppSpacings.xl, left: AppSpacings.xl),
        child: GestureDetector(
          onTap: AuthService().signOut,
          child: getAvatar(),
        ) 
      ),
    );
  }
}
