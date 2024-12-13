// To parse this JSON data, do
//
//     final taskModel = taskModelFromJson(jsonString);

import 'dart:convert';

List<TaskModel> taskModelFromJson(String str) => List<TaskModel>.from(json.decode(str).map((x) => TaskModel.fromJson(x)));

String taskModelToJson(List<TaskModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TaskModel {
  int? id;
  String? createdAt;
  String? taskContent;
  bool? isDone;
  String? userId;

  TaskModel({
    this.id,
    this.createdAt,
    this.taskContent,
    this.isDone,
    this.userId,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json["id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]).toString().substring(0, 10),
        taskContent: json["task_content"],
        isDone: json["is_done"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt?.substring(0, 10),
        "task_content": taskContent,
        "is_done": isDone,
        "user_id": userId,
      };
}
