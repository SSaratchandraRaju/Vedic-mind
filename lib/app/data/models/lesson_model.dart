class LessonModel {
  final String id;
  final String title;
  final String category;
  final String description;

  LessonModel({this.id = '', this.title = '', this.category = '', this.description = ''});

  factory LessonModel.fromJson(Map<String, dynamic> json) => LessonModel(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        category: json['category'] ?? '',
        description: json['description'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'description': description,
      };
}
