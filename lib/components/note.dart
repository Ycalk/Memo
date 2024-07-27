import 'package:flutter/material.dart';

class Note {
  String _title;
  String _content;

  String get title => _title;
  String get content => _content;

  set title(String title) => _title = title;
  set content(String content) => _content = content;

  Note({String title = "", String content = ""}) : _title = title, _content = content;
}

class NoteWidget extends StatelessWidget {
  final Note note;
  const NoteWidget({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}