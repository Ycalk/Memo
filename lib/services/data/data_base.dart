import 'package:memo_mind/domain/note.dart';

abstract class DataBase{


  // returns note id
  Future<String> addNote(Note note);
  Future<void> removeNote(Note note);
  Future<void> updateNote(Note note);

  Future<List<Note>> getNotes();
  late final Stream<List<Note>> collectionStream;
}