// To parse this JSON data, do
//
//     final employerResponse = employerResponseFromJson(jsonString);

import 'dart:convert';

EmployerResponse employerResponseFromJson(String str) => EmployerResponse.fromJson(json.decode(str));

String employerResponseToJson(EmployerResponse data) => json.encode(data.toJson());

class EmployerResponse {
  int? statusCode;
  List<EmployerList>? data;

  EmployerResponse({
    this.statusCode,
    this.data,
  });

  factory EmployerResponse.fromJson(Map<String, dynamic> json) => EmployerResponse(
    statusCode: json["status_code"],
    data: json["data"] == null ? [] : List<EmployerList>.from(json["data"]!.map((x) => EmployerList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class EmployerList {
  int? id;
  String? employerName;
  String? logo;
  int? trashStatus;
  DateTime? createdAt;
  dynamic updatedAt;

  EmployerList({
    this.id,
    this.employerName,
    this.logo,
    this.trashStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory EmployerList.fromJson(Map<String, dynamic> json) => EmployerList(
    id: json["id"],
    employerName: json["employer_name"],
    logo: json["logo"],
    trashStatus: json["trash_status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "employer_name": employerName,
    "logo": logo,
    "trash_status": trashStatus,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt,
  };
}
