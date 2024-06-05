// To parse this JSON data, do
//
//     final getCountriesModel = getCountriesModelFromJson(jsonString);

import 'dart:convert';

GetCountriesModel getCountriesModelFromJson(String str) => GetCountriesModel.fromJson(json.decode(str));

String getCountriesModelToJson(GetCountriesModel data) => json.encode(data.toJson());

class GetCountriesModel {
  int statusCode;
  List<AllCountryList> data;

  GetCountriesModel({
    required this.statusCode,
    required this.data,
  });

  factory GetCountriesModel.fromJson(Map<String, dynamic> json) => GetCountriesModel(
    statusCode: json["status_code"],
    data: List<AllCountryList>.from(json["data"].map((x) => AllCountryList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class AllCountryList {
  int id;
  String countryId;
  String countryName;
  String status;
  String trashStatus;
  DateTime createdAt;
  DateTime updatedAt;

  AllCountryList({
    required this.id,
    required this.countryId,
    required this.countryName,
    required this.status,
    required this.trashStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AllCountryList.fromJson(Map<String, dynamic> json) => AllCountryList(
    id: json["id"]??0,
    countryId: json["country_id"]??"NA",
    countryName: json["country_name"]??"Select Country",
    status: json["status"]??"0",
    trashStatus: json["trash_status"]??"0",
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "country_id": countryId,
    "country_name": countryName,
    "status": status,
    "trash_status": trashStatus,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
