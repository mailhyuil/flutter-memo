import 'package:flutter/material.dart';

class MemoModel {
  String id = UniqueKey().toString();
  final String content;
  final DateTime createdAt;
  final bool isCompleted;

  MemoModel({
    required this.content,
    required this.createdAt,
    this.isCompleted = false,
  });

  MemoModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        content = json['content'],
        createdAt = DateTime.parse(json['createdAt']),
        isCompleted = json['isCompleted'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        'isCompleted': isCompleted,
      };
}
