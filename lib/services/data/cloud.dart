import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memo/domain/note.dart';
import 'package:memo/services/auth/auth_service.dart';
import 'package:memo/services/data/data_base.dart';


class CloudDataBase implements DataBase {
  @override
  late final Stream<List<Note>> collectionStream;

  final CollectionReference<Map<String, dynamic>> _userNotes = 
    FirebaseFirestore.instance.collection('users').doc(AuthService().uid).collection('userNotes');

  CloudDataBase(){
    collectionStream = _userNotes.snapshots().map((snapshot) => 
      snapshot.docs.map((doc) => Note.fromMap(doc.data(), this, doc.id)).toList());
  }

  @override
  Future<String> addNote(Note note) => 
    _userNotes.add(note.toMap()).then((doc) => doc.id);

  @override
  Future<void> removeNote(Note note) => 
    _userNotes.doc(note.id).delete();

  @override
  Future<List<Note>> getNotes() => 
    _userNotes.get()
    .then((notes) => 
      notes.docs.map((e) => Note.fromMap(e.data(), this, e.id)).toList()
    );
  
  @override
  Future<void> updateNote(Note note) => 
    _userNotes.doc(note.id).set(note.toMap());
}