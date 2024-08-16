import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memo_mind/config/theme/colors.dart';
import 'package:memo_mind/config/theme/spacing.dart';
import 'package:memo_mind/domain/note.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    this.selected = false,
    this.onSelect,
    this.onTap,
  });

  final Note note;
  final bool selected;
  final Function()? onSelect;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return _AnimatedClipPath(
      duration: 100.ms,
      rectSize: selected ? AppSpacings.m : 0 ,
      borderRadius: const Radius.circular(AppSpacings.l),
      child: Material(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          splashColor: Colors.black12,
          onLongPress: onSelect,
          onTap: onTap,
          child: Container(
            color: note.color,
            constraints: const BoxConstraints(
              maxHeight: 300,
              minHeight: 100,
            ),
            padding: const EdgeInsets.all(AppSpacings.l,),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: AutoSizeText(
                        note.title,
                        presetFontSizes: const [35, 28, 26, 24, 22],
                        softWrap: true,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: AppColors.title,
                        ),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    const SizedBox(height: AppSpacings.m),
                    Text(
                      note.date,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w200,
                        fontSize: 17,
                        color: AppColors.title,
                      ),
                    ),
                  ],
                ),
                if (selected)
                  Align(
                    alignment: Alignment.topRight,
                    heightFactor: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 20,
                            color: note.color,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.check,
                          color: note.color,
                          size: 20,
                        ),
                      ),
                    ).animate().fadeIn(duration: 100.ms),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedClipPath extends StatelessWidget {
  final Widget? child;
  final Duration duration;
  final double rectSize;
  final Radius borderRadius;
  const _AnimatedClipPath({this.child, 
    required this.duration, 
    required this.rectSize,
    required this.borderRadius
  });


  Widget _builder(
      BuildContext context, double size, Widget? child) {
    return ClipPath(
      clipBehavior: Clip.antiAlias,
      clipper: _Clipper(size, borderRadius),
      child: child
    );
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween<double>(begin: 0, end: rectSize),
      builder: _builder,
      child: child,
    );
    
  }
}

class _Clipper extends CustomClipper<Path>{
  final double rectSize;
  final Radius radius;
  _Clipper(this.rectSize, this.radius);

  @override
  Path getClip(Size size) {
    final rect = Rect.fromLTWH(rectSize / 2, rectSize / 2, size.width - rectSize, size.height - rectSize);
    return Path()..addRRect(RRect.fromRectAndRadius(rect, radius));
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;

}



class _AnimatedClipRRect extends StatelessWidget {
  const _AnimatedClipRRect({
    required this.duration,
    required this.borderRadius,
    required this.child,
  }) ;

  final Duration duration;
  final BorderRadius borderRadius;
  final Widget child;

  static Widget _builder(
      BuildContext context, BorderRadius radius, Widget? child) {
    return ClipRRect(borderRadius: radius, child: child);
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<BorderRadius>(
      duration: duration,
      tween: Tween<BorderRadius>(begin: BorderRadius.zero, end: borderRadius),
      builder: _builder,
      child: child,
    );
  }
}