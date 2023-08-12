class MemoModel {
  final String content;
  final DateTime createdAt;
  final bool isCompleted;

  MemoModel({
    required this.content,
    required this.createdAt,
    this.isCompleted = false,
  });

  MemoModel.fromJson(Map<String, dynamic> json)
      : content = json['content'],
        createdAt = DateTime.parse(json['createdAt']),
        isCompleted = json['isCompleted'];

  Map<String, dynamic> toJson() => {
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        'isCompleted': isCompleted,
      };
}
