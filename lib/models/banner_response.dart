// To parse this JSON data, do
//
//     final bannersResposne = bannersResposneFromJson(jsonString);

import 'dart:convert';

BannersResposne bannersResposneFromJson(String str) => BannersResposne.fromJson(json.decode(str));

String bannersResposneToJson(BannersResposne data) => json.encode(data.toJson());

class BannersResposne {
  int? statusCode;
  List<BannersList>? data;

  BannersResposne({
    this.statusCode,
    this.data,
  });

  factory BannersResposne.fromJson(Map<String, dynamic> json) => BannersResposne(
    statusCode: json["status_code"],
    data: json["data"] == null ? [] : List<BannersList>.from(json["data"]!.map((x) => BannersList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class BannersList {
  int? id;
  dynamic name;
  String? fileName;
  String? filePath;
  int? status;
  int? trashStatus;
  DateTime? createdAt;
  dynamic updatedAt;

  BannersList({
    this.id,
    this.name,
    this.fileName,
    this.filePath,
    this.status,
    this.trashStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory BannersList.fromJson(Map<String, dynamic> json) => BannersList(
    id: json["id"],
    name: json["name"],
    fileName: json["file_name"],
    filePath: json["file_path"],
    status: json["status"],
    trashStatus: json["trash_status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "file_name": fileName,
    "file_path": filePath,
    "status": status,
    "trash_status": trashStatus,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt,
  };
}
