import 'package:flutter/material.dart';
import 'package:memo_mind/services/data/data_base.dart';

class Note {
  String get title => _title;
  String get content => _content;
  Color get color => _color;

  set title(String title) {
    _title = title;
    storage.updateNote(this);
  }
  set content(String content) {
    _content = content;
    storage.updateNote(this);
  }
  set color(Color color){
    _color = color;
    storage.updateNote(this);
  }
  
  final DateTime created;
  final DataBase storage;
  late final String id;

  String _title;
  String _content;
  Color _color;


  @override
  int get hashCode => _title.hashCode ^ _content.hashCode ^ _color.hashCode ^ created.hashCode;

  @override
  String toString() {
    return 'Note {_title: $_title, _content: $_content, _color: $_color, created: $created}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Note &&
      other._title == _title &&
      other._content == _content &&
      other._color == _color &&
      other.created == created;
  }

  Map<String, dynamic> toMap() {
    return {
      'title': _title,
      'content': _content,
      'color': _color.value,
      'created': created.toString(),
    };
  }

  Note.fromMap(Map<String, dynamic> map, this.storage, this.id) : 
    _title = map['title'], _content = map['content'], _color = Color(map['color']), created = DateTime.parse(map['created']);


  Note({String title = "", String content = "", Color color = Colors.white, required this.storage}) : 
    _title = title, _content = content, _color = color, created = DateTime.now(){
    storage.addNote(this).then((v) => id = v);
  }
}

