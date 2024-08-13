import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memo_mind/config/theme/colors.dart';
import 'package:memo_mind/config/theme/notes_colors.dart';
import 'package:memo_mind/config/theme/spacing.dart';
import 'package:memo_mind/domain/note.dart';
import 'package:memo_mind/presentation/components/button_app_bar.dart';
import 'package:memo_mind/presentation/components/choose_color.dart';

class NewNotePage extends StatefulWidget {
  const NewNotePage({super.key});

  @override
  State<NewNotePage> createState() => _NewNotePageState();
}

class _NewNotePageState extends State<NewNotePage> {
  int _colorCount = 0;
  static const double _chooseColorWidgetSize = 50;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState(){
    super.initState();
    _colorCount = Random().nextInt(NotesColors.colors.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 300),
        color: NotesColors.colors[_colorCount],
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.only(left: AppSpacings.s, top: 150, right: AppSpacings.l),
              children: [
                TextField(
                  maxLength: Note.maxTitleLength,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  controller: _titleController,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 40,
                    color: AppColors.title,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    counterText: '',
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(color: AppColors.title.withOpacity(0.5),)
                ),
                const SizedBox(height: AppSpacings.xl,),
                TextField(
                  controller: _contentController,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: AppColors.title,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Content',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  ),
                  maxLines: null,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ButtonAppBar(
                      onPressed: () => Navigator.of(context).pop(),
                      heroTag: 'back',
                      icon: const Icon(Icons.arrow_back),
                    ),
                    ButtonAppBar(
                      onPressed: () => Navigator.of(context).pop(),
                      heroTag: 'save',
                      icon: const Icon(Icons.save),
                      alignment: Alignment.topRight,
                    ),
                  ],
                ),
                SizedBox(
                  height: _chooseColorWidgetSize * 2,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: NotesColors.colors.map((color) => 
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => setState(() => _colorCount = NotesColors.colors.indexOf(color)),
                        child: ChooseColor(
                          color: color, 
                          size: _chooseColorWidgetSize,
                          isSelected: NotesColors.colors.indexOf(color) == _colorCount,
                        )
                      ),
                    )).toList(),
                  ),
                ),
              ],
            )
          ],
        ),
      ) 
    );
  }
}