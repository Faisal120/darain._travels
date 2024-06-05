// To parse this JSON data, do
//
//     final notesMessages = notesMessagesFromJson(jsonString);

import 'dart:convert';

NotesMessages notesMessagesFromJson(String str) => NotesMessages.fromJson(json.decode(str));

String notesMessagesToJson(NotesMessages data) => json.encode(data.toJson());

class NotesMessages {
  int? statusCode;
  List<Message>? messages;

  NotesMessages({
    this.statusCode,
    this.messages,
  });

  factory NotesMessages.fromJson(Map<String, dynamic> json) => NotesMessages(
    statusCode: json["status_code"],
    messages: json["messages"] == null ? [] : List<Message>.from(json["messages"]!.map((x) => Message.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "messages": messages == null ? [] : List<dynamic>.from(messages!.map((x) => x.toJson())),
  };
}

class Message {
  int? id;
  String? appId;
  int? sender;
  String? mess;
  int? trashStatus;
  DateTime? createdAt;
  DateTime? updatedAt;

  Message({
    this.id,
    this.appId,
    this.sender,
    this.mess,
    this.trashStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json["id"],
    appId: json["app_id"],
    sender: json["sender"],
    mess: json["mess"],
    trashStatus: json["trash_status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "app_id": appId,
    "sender": sender,
    "mess": mess,
    "trash_status": trashStatus,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
