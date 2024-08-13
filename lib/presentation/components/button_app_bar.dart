import 'package:flutter/material.dart';
import 'package:memo_mind/config/theme/colors.dart';
import 'package:memo_mind/config/theme/spacing.dart';

class ButtonAppBar extends StatelessWidget {
  final String? heroTag;
  final Widget? icon;
  final Function()? onPressed;
  final Alignment alignment;

  const ButtonAppBar({this.heroTag, this.icon, this.onPressed, super.key, this.alignment = Alignment.topLeft});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        alignment: alignment,
        padding: const EdgeInsets.all(AppSpacings.xl),
        child: FloatingActionButton(
            heroTag: heroTag,
            shape: const CircleBorder(),
            backgroundColor: AppColors.primary,
            onPressed: onPressed,
            child: icon
          ),
      ),
    );
  }
}
