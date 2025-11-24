class NoteModel {
  int? id;
  String title;
  String content;

  NoteModel({this.id, required this.title, required this.content});

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{'title': title, 'content': content};
    if (id != null) map['id'] = id;
    return map;
  }
}