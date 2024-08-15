import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memo_mind/config/theme/colors.dart';
import 'package:memo_mind/config/theme/notes_colors.dart';
import 'package:memo_mind/config/theme/spacing.dart';
import 'package:memo_mind/domain/note.dart';
import 'package:memo_mind/domain/provider.dart';
import 'package:memo_mind/presentation/components/button_app_bar.dart';
import 'package:memo_mind/presentation/components/choose_color.dart';
import 'package:provider/provider.dart';

class NotePage extends StatefulWidget {
  final Note? note;

  const NotePage({super.key, this.note, });

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  int _colorCount = 0;
  static const double _chooseColorWidgetSize = 50;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState(){
    super.initState();
    if (widget.note != null){
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
    _colorCount = widget.note == null ? Random().nextInt(NotesColors.colors.length) : 
      NotesColors.colors.indexOf(widget.note!.color);
  }

  Note createNote(){
    final note = Note(
      title: _titleController.text,
      content: _contentController.text,
      color: NotesColors.colors[_colorCount],
      storage: Provider.of<NoteProvider>(context, listen: false).database,
    );
    return note;
  }

  void saveChanges(){
    widget.note?.title = _titleController.text;
    widget.note?.content = _contentController.text;
    Navigator.of(context).pop(widget.note);
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
                      onPressed: () {
                        if (widget.note == null){
                          if (_titleController.text.isEmpty && _contentController.text.isEmpty){
                            Navigator.of(context).pop();
                            return;
                          }
                          final note = createNote();
                          Navigator.of(context).pop(note);
                        } else {
                          saveChanges();
                        }
                      },
                      heroTag: 'back',
                      icon: const Icon(Icons.arrow_back),
                    ),
                    ButtonAppBar(
                      onPressed: () {
                        if (widget.note == null){
                          final note = createNote();
                          Navigator.of(context).pop(note);
                        } else {
                          saveChanges();
                        }
                      },
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