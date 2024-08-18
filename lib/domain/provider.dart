import 'package:flutter/material.dart';
import 'package:memo/domain/note.dart';
import 'package:memo/services/data/data_base.dart';


class NoteProvider extends ChangeNotifier {
  List<Note> _notes = [];
  bool _initialized = false;
  late final DataBase database;
  Iterable<Note> get notes => _notes;

  Future<void> setDatabase(DataBase database) async {
    if (!_initialized){
      this.database = database;
      database.collectionStream.listen((event) {
        _notes = event;
        notifyListeners();
      });
      _notes.clear();
      _notes.addAll(await database.getNotes());
      notifyListeners();
      _initialized = true;
    }

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