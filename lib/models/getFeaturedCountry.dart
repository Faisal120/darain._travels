// To parse this JSON data, do
//
//     final featuredCountry = featuredCountryFromJson(jsonString);

import 'dart:convert';

FeaturedCountry featuredCountryFromJson(String str) => FeaturedCountry.fromJson(json.decode(str));

String featuredCountryToJson(FeaturedCountry data) => json.encode(data.toJson());

class FeaturedCountry {
  int? statusCode;
  List<FeaturedCountryList>? data;

  FeaturedCountry({
    this.statusCode,
    this.data,
  });

  factory FeaturedCountry.fromJson(Map<String, dynamic> json) => FeaturedCountry(
    statusCode: json["status_code"],
    data: json["data"] == null ? [] : List<FeaturedCountryList>.from(json["data"]!.map((x) => FeaturedCountryList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class FeaturedCountryList {
  int? id;
  String? countryId;
  String? countryName;
  String? countryImg;
  int? feature;
  int? jobCount;
  String? status;
  String? trashStatus;
  DateTime? createdAt;
  DateTime? updatedAt;

  FeaturedCountryList({
    this.id,
    this.countryId,
    this.countryName,
    this.countryImg,
    this.feature,
    this.status,
    this.jobCount,
    this.trashStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory FeaturedCountryList.fromJson(Map<String, dynamic> json) => FeaturedCountryList(
    id: json["id"],
    countryId: json["country_id"],
    countryName: json["country_name"],
    countryImg: json["country_img"],
    feature: json["feature"],
    status: json["status"],
    trashStatus: json["trash_status"],
    jobCount: json["job_count"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "country_id": countryId,
    "country_name": countryName,
    "country_img": countryImg,
    "feature": feature,
    "status": status,
    "trash_status": trashStatus,
    "job_count":jobCount,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
