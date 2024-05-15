class Task {
  int? id;
  String title;
  String notes;
  DateTime date;
  String? priority;
  int? status;
  String? timeValue;
  String? timeType;
  int time;
  String? imagePath;
  late bool hasImage;
  late bool hasMap;
  late bool hasAttachment;
  List<String> categories;

  Task(
      {required this.title,
      required this.notes,
      required this.date,
      required this.categories,
      required this.time,
      this.imagePath});
  Task.withId(
      {required this.id,
      required this.title,
      required this.notes,
      required this.date,
      required this.categories,
      required this.time,
      this.imagePath});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['notes'] = notes;
    map['date'] = date.toIso8601String();
    map['categories'] = getCategories();
    map['time'] = time;
    map['imagePath'] = imagePath;
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task.withId(
        id: map['id'],
        title: map['title'],
        notes: map['notes'],
        date: DateTime.parse(map['date']),
        categories: map['categories'].toString().split(','),
        time: map['time'],
        imagePath: map['imagePath']);
  }

  String getCategories() {
    String cats = '';

    for (var cat in categories) {
      if (cat != '') {
        cats = cats + cat + ',';
      }
    }
    return cats;
  }
}
