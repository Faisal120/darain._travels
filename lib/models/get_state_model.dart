// To parse this JSON data, do
//
//     final getStateModel = getStateModelFromJson(jsonString);

import 'dart:convert';

GetStateModel getStateModelFromJson(String str) => GetStateModel.fromJson(json.decode(str));

String getStateModelToJson(GetStateModel data) => json.encode(data.toJson());

class GetStateModel {
  int? statusCode;
  List<AllStateList>? data;

  GetStateModel({
    this.statusCode,
    this.data,
  });

  factory GetStateModel.fromJson(Map<String, dynamic> json) => GetStateModel(
    statusCode: json["status_code"],
    data: json["data"] == null ? [] : List<AllStateList>.from(json["data"]!.map((x) => AllStateList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class AllStateList {
  int? id;
  String? stateId;
  int? cId;
  String? state;
  String? status;
  String? trashStatus;
  DateTime? createdAt;
  DateTime? updatedAt;

  AllStateList({
    this.id,
    this.stateId,
    this.cId,
    this.state,
    this.status,
    this.trashStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory AllStateList.fromJson(Map<String, dynamic> json) => AllStateList(
    id: json["id"],
    stateId: json["state_id"],
    cId: json["c_id"],
    state: json["state"],
    status: json["status"],
    trashStatus: json["trash_status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "state_id": stateId,
    "c_id": cId,
    "state": state,
    "status": status,
    "trash_status": trashStatus,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
