import 'package:flutter/material.dart';
import 'package:memo_mind/components/note.dart';


class NoteProvider extends ChangeNotifier {
  final List<Note> _notes = [];

  Iterable<Note> get notes => _notes;

  void add(Note note) {
    _notes.add(note);
    notifyListeners();
  }

  void remove(Note note) {
    _notes.remove(note);
    notifyListeners();
  }
}