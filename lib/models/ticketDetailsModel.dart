// To parse this JSON data, do
//
//     final ticketDetailsModel = ticketDetailsModelFromJson(jsonString);

import 'dart:convert';

TicketDetailsModel ticketDetailsModelFromJson(String str) => TicketDetailsModel.fromJson(json.decode(str));

String ticketDetailsModelToJson(TicketDetailsModel data) => json.encode(data.toJson());

class TicketDetailsModel {
  int statusCode;
  TicketDetails ticketDetails;
  List<Chat> chats;

  TicketDetailsModel({
    required this.statusCode,
    required this.ticketDetails,
    required this.chats,
  });

  factory TicketDetailsModel.fromJson(Map<String, dynamic> json) => TicketDetailsModel(
    statusCode: json["status_code"],
    ticketDetails: TicketDetails.fromJson(json["ticket_details"]),
    chats: List<Chat>.from(json["chats"].map((x) => Chat.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "ticket_details": ticketDetails.toJson(),
    "chats": List<dynamic>.from(chats.map((x) => x.toJson())),
  };
}

class Chat {
  int id;
  String ticketId;
  String senderId;
  String recId;
  String mess;
  int mesType;
  String filePath;
  DateTime createdAt;
  DateTime updatedAt;

  Chat({
    required this.id,
    required this.ticketId,
    required this.senderId,
    required this.recId,
    required this.mess,
    required this.mesType,
    required this.filePath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    id: json["id"]??0,
    ticketId: json["ticket_id"]??"NA",
    senderId: json["sender_id"]??"NA",
    recId: json["rec_id"]??"NA",
    mess: json["mess"]??"NA",
    mesType: json["mes_type"]??0,
    filePath: json["file_path"]??"",
    createdAt: DateTime.parse(json["created_at"]??"2023-07-17 20:27:36"),
    updatedAt: DateTime.parse(json["updated_at"]??"2023-07-17 20:27:36"),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ticket_id": ticketId,
    "sender_id": idValues.reverse[senderId],
    "rec_id": idValues.reverse[recId],
    "mess": mess,
    "mes_type": mesType,
    "file_path": filePath,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

enum Id { ADMIN, JOB98398, USER }

final idValues = EnumValues({
  "Admin": Id.ADMIN,
  "JOB98398": Id.JOB98398,
  "User": Id.USER
});

class TicketDetails {
  int id;
  Id userId;
  String subject;
  String desc;
  dynamic img;
  int status;
  int trashStatus;
  DateTime createdAt;
  DateTime updatedAt;
  String name;

  TicketDetails({
    required this.id,
    required this.userId,
    required this.subject,
    required this.desc,
    this.img,
    required this.status,
    required this.trashStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
  });

  factory TicketDetails.fromJson(Map<String, dynamic> json) => TicketDetails(
    id: json["id"]??0,
    userId: idValues.map[json["user_id"]??"NA"]!,
    subject: json["subject"]??"NA",
    desc: json["desc"]??"NA",
    img: json["img"]??"NA",
    status: json["status"]??"NA",
    trashStatus: json["trash_status"]??"NA",
    createdAt: DateTime.parse(json["created_at"]??"2023-07-17 20:27:36"),
    updatedAt: DateTime.parse(json["updated_at"]??"2023-07-17 20:27:36"),
    name: json["name"]??"NA",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": idValues.reverse[userId],
    "subject": subject,
    "desc": desc,
    "img": img,
    "status": status,
    "trash_status": trashStatus,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "name": name,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
