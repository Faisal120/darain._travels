// To parse this JSON data, do
//
//     final ticketModel = ticketModelFromJson(jsonString);

import 'dart:convert';

TicketModel ticketModelFromJson(String str) => TicketModel.fromJson(json.decode(str));

String ticketModelToJson(TicketModel data) => json.encode(data.toJson());

class TicketModel {
  List<TicketList> data;
  int count;

  TicketModel({
    required this.data,
    required this.count,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) => TicketModel(
    data: List<TicketList>.from(json["data"].map((x) => TicketList.fromJson(x))),
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "count": count,
  };
}

class TicketList {
  int id;
  String userId;
  String subject;
  String desc;
  dynamic img;
  int status;
  int trashStatus;
  DateTime createdAt;
  DateTime updatedAt;

  TicketList({
    required this.id,
    required this.userId,
    required this.subject,
    required this.desc,
    this.img,
    required this.status,
    required this.trashStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TicketList.fromJson(Map<String, dynamic> json) => TicketList(
    id: json["id"],
    userId: json["user_id"],
    subject: json["subject"],
    desc: json["desc"],
    img: json["img"],
    status: json["status"],
    trashStatus: json["trash_status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "subject": subject,
    "desc": desc,
    "img": img,
    "status": status,
    "trash_status": trashStatus,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
