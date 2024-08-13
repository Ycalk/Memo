import 'package:flutter/material.dart';
import 'package:memo_mind/domain/note.dart';
import 'package:memo_mind/services/data/data_base.dart';


class NoteProvider extends ChangeNotifier {
  List<Note> _notes = [];
  late final DataBase database;
  Iterable<Note> get notes => _notes;

  Future<void> setDatabase(DataBase database) async {
    this.database = database;
    database.collectionStream.listen((event) {
      _notes = event;
      notifyListeners();
    });
    _notes.clear();
    _notes.addAll(await database.getNotes());
    notifyListeners();
  }
  
  NoteProvider();

  void add(Note note) {
    _notes.add(note);
    notifyListeners();
  }

  void remove(Note note) {
    _notes.remove(note);
    notifyListeners();
  }
}