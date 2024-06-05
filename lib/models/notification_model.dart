// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
  int? statusCode;
  List<NotificationList>? data;

  NotificationModel({
    this.statusCode,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    statusCode: json["status_code"],
    data: json["data"] == null ? [] : List<NotificationList>.from(json["data"]!.map((x) => NotificationList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class NotificationList {
  int? id;
  dynamic type;
  String? userId;
  dynamic notifiableType;
  dynamic notifiableId;
  dynamic data;
  String? title;
  String? body;
  dynamic readAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  NotificationList({
    this.id,
    this.type,
    this.userId,
    this.notifiableType,
    this.notifiableId,
    this.data,
    this.title,
    this.body,
    this.readAt,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationList.fromJson(Map<String, dynamic> json) => NotificationList(
    id: json["id"],
    type: json["type"],
    userId: json["user_id"],
    notifiableType: json["notifiable_type"],
    notifiableId: json["notifiable_id"],
    data: json["data"],
    title: json["title"],
    body: json["body"],
    readAt: json["read_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "user_id": userId,
    "notifiable_type": notifiableType,
    "notifiable_id": notifiableId,
    "data": data,
    "title": title,
    "body": body,
    "read_at": readAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
