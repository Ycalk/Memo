import 'package:memo/domain/note.dart';
import 'package:memo/services/data/data_base.dart';

class LocalDataBase extends DataBase {
  

  LocalDataBase();

  @override
  Future<String> addNote(Note note) {
    return Future.value('');
  }

  @override
  Future<void> removeNote(Note note) {
    return Future.value();
  }

  @override
  Future<List<Note>> getNotes() {
    return Future.value([]);
  }

  @override
  Future<void> updateNote(Note note) {
    return Future.value();
  }
  
}