class NoteModel {
  String title;
  String desc;
  int? time;

  NoteModel({required this.title, required this.desc, this.time});

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(title: map['title'], desc: map['desc'], time: map['time']);
  }

  Map<String, dynamic> toMap() {
    return {"title": title, "desc": desc, "time" : DateTime.now().millisecondsSinceEpoch};
  }
}
