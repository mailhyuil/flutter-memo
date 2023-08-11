class MemoModel {
  final String content;
  final DateTime createdAt;

  MemoModel({
    required this.content,
    required this.createdAt,
  });

  MemoModel.fromJson(Map<String, dynamic> json)
      : content = json['content'],
        createdAt = DateTime.parse(json['createdAt']);

  Map<String, dynamic> toJson() => {
        'content': content,
        'createdAt': createdAt.toIso8601String(),
      };
}
