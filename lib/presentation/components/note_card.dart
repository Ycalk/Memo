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
    return Material(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(AppSpacings.m),
      color: note.color,
      child: InkWell(
        splashColor: Colors.black12,
        onLongPress: onSelect,
        onTap: onTap,
        child: Container(
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
                        Icons.check_circle_outline_outlined,
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
    );
  }
}
