// To parse this JSON data, do
//
//     final dashboardResponse = dashboardResponseFromJson(jsonString);

import 'dart:convert';

DashboardResponse dashboardResponseFromJson(String str) => DashboardResponse.fromJson(json.decode(str));

String dashboardResponseToJson(DashboardResponse data) => json.encode(data.toJson());

class DashboardResponse {
  int? statusCode;
  List<BannersData>? banners;
  List<JobData>? recentJob;
  List<Update>? update;
  List<JobData>? featureJob;
  List<FeatureEmployer>? featureEmployer;
  List<FeatureCountry>? featureCountry;

  DashboardResponse({
    this.statusCode,
    this.banners,
    this.recentJob,
    this.update,
    this.featureJob,
    this.featureEmployer,
    this.featureCountry,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) => DashboardResponse(
    statusCode: json["status_code"]??404,
    banners: json["banners"] == null ? [] : List<BannersData>.from(json["banners"]!.map((x) => BannersData.fromJson(x))),
    recentJob: json["recent_job"] == null ? [] : List<JobData>.from(json["recent_job"]!.map((x) => JobData.fromJson(x))),
    update: json["update"] == null ? [] : List<Update>.from(json["update"]!.map((x) => Update.fromJson(x))),
    featureJob: json["feature_job"] == null ? [] : List<JobData>.from(json["feature_job"]!.map((x) => JobData.fromJson(x))),
    featureEmployer: json["feature_employer"] == null ? [] : List<FeatureEmployer>.from(json["feature_employer"]!.map((x) => FeatureEmployer.fromJson(x))),
    featureCountry: json["feature_country"] == null ? [] : List<FeatureCountry>.from(json["feature_country"]!.map((x) => FeatureCountry.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "banners": banners == null ? [] : List<dynamic>.from(banners!.map((x) => x.toJson())),
    "recent_job": recentJob == null ? [] : List<dynamic>.from(recentJob!.map((x) => x.toJson())),
    "update": update == null ? [] : List<dynamic>.from(update!.map((x) => x.toJson())),
    "feature_job": featureJob == null ? [] : List<dynamic>.from(featureJob!.map((x) => x.toJson())),
    "feature_employer": featureEmployer == null ? [] : List<dynamic>.from(featureEmployer!.map((x) => x.toJson())),
    "feature_country": featureCountry == null ? [] : List<dynamic>.from(featureCountry!.map((x) => x.toJson())),
  };
}

class BannersData {
  int? id;
  String? name;
  String? fileName;
  String? filePath;
  int? status;
  int? trashStatus;
  DateTime? createdAt;
  dynamic updatedAt;

  BannersData({
    this.id,
    this.name,
    this.fileName,
    this.filePath,
    this.status,
    this.trashStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory BannersData.fromJson(Map<String, dynamic> json) => BannersData(
    id: json["id"]??0,
    name: json["name"]??"NA",
    fileName: json["file_name"]??"NA",
    filePath: json["file_path"]??"NA",
    status: json["status"]??"NA",
    trashStatus: json["trash_status"]??"NA",
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"]??"NA",
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

class FeatureCountry {
  int? id;
  String? countryId;
  String? countryName;
  String? countryImg;
  int? feature;
  String? status;
  String? trashStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? jobCount;

  FeatureCountry({
    this.id,
    this.countryId,
    this.countryName,
    this.countryImg,
    this.feature,
    this.status,
    this.trashStatus,
    this.createdAt,
    this.updatedAt,
    this.jobCount,
  });

  factory FeatureCountry.fromJson(Map<String, dynamic> json) => FeatureCountry(
    id: json["id"]??0,
    countryId: json["country_id"]??"0",
    countryName: json["country_name"]??"NA",
    countryImg: json["country_img"]??"NA",
    feature: json["feature"]??0,
    status: json["status"]??"NA",
    trashStatus: json["trash_status"]??"0",
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    jobCount: json["job_count"]??"NA",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "country_id": countryId,
    "country_name": countryName,
    "country_img": countryImg,
    "feature": feature,
    "status": status,
    "trash_status": trashStatus,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "job_count": jobCount,
  };
}

class FeatureEmployer {
  int? id;
  String? employerName;
  String? logo;
  int? featureEmployer;
  int? trashStatus;
  DateTime? createdAt;
  DateTime? updatedAt;

  FeatureEmployer({
    this.id,
    this.employerName,
    this.logo,
    this.featureEmployer,
    this.trashStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory FeatureEmployer.fromJson(Map<String, dynamic> json) => FeatureEmployer(
    id: json["id"]??0,
    employerName: json["employer_name"]??"NA",
    logo: json["logo"]??"NA",
    featureEmployer: json["feature_employer"]??0,
    trashStatus: json["trash_status"]??0,
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "employer_name": employerName,
    "logo": logo,
    "feature_employer": featureEmployer,
    "trash_status": trashStatus,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class JobData {
  int? id;
  String? jobId;
  String? employerId;
  AddedBy? addedBy;
  String? title;
  String? category;
  String? img;
  String? jobType;
  int? noOfJob;
  String? location;
  dynamic city;
  String? state;
  String? country;
  String? salary;
  DateTime? expireAt;
  String? description;
  int? featured;
  int? status;
  int? trashStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? catId;
  String? catName;
  String? catNameHindi;
  DateTime? formattedDate;
  String? jobImg;
  Applied? applied;
  String? appStatusName;
  String? statusNote;
  Saved? saved;

  JobData({
    this.id,
    this.jobId,
    this.employerId,
    this.addedBy,
    this.title,
    this.category,
    this.img,
    this.jobType,
    this.noOfJob,
    this.location,
    this.city,
    this.state,
    this.country,
    this.salary,
    this.expireAt,
    this.description,
    this.featured,
    this.status,
    this.trashStatus,
    this.createdAt,
    this.updatedAt,
    this.catId,
    this.catName,
    this.catNameHindi,
    this.formattedDate,
    this.jobImg,
    this.applied,
    this.appStatusName,
    this.statusNote,
    this.saved,
  });

  factory JobData.fromJson(Map<String, dynamic> json) => JobData(
    id: json["id"]??0,
    jobId: json["job_id"]??"NA",
    employerId: json["employer_id"]??"NA",
    addedBy: addedByValues.map[json["added_by"]??"NA"]!,
    title: json["title"]??"NA",
    category: json["category"]??"NA",
    img: json["img"]??"NA",
    jobType: json["job_type"]??"NA",
    noOfJob: json["no_of_job"]??"NA",
    location: json["location"]??"NA",
    city: json["city"]??"NA",
    state: json["state"]??"NA",
    country: json["country"]??"NA",
    salary: json["salary"]??"NA",
    expireAt: json["expire_at"] == null ? null : DateTime.parse(json["expire_at"]),
    description: json["description"]??"NA",
    featured: json["featured"]??0,
    status: json["status"]??0,
    trashStatus: json["trash_status"]??0,
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    catId: json["cat_id"]??"NA",
    catName: json["cat_name"]??"NA",
    catNameHindi: json["cat_name_hindi"]??"NA",
    formattedDate: json["formatted_date"] == null ? null : DateTime.parse(json["formatted_date"]),
    jobImg: json["job_img"]??"NA",
    applied: appliedValues.map[json["applied"]]!,
    appStatusName: json["app_status_name"]??"NA",
    statusNote: json["status_note"]??"NA",
    saved: savedValues.map[json["saved"]??"NA"]!,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "job_id": jobId,
    "employer_id": employerId,
    "added_by": addedByValues.reverse[addedBy],
    "title": title,
    "category": category,
    "img": img,
    "job_type": jobType,
    "no_of_job": noOfJob,
    "location": locationValues.reverse[location],
    "city": city,
    "state": state,
    "country": country,
    "salary": salary,
    "expire_at": "${expireAt!.year.toString().padLeft(4, '0')}-${expireAt!.month.toString().padLeft(2, '0')}-${expireAt!.day.toString().padLeft(2, '0')}",
    "description": description,
    "featured": featured,
    "status": status,
    "trash_status": trashStatus,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "cat_id": catId,
    "cat_name": catName,
    "cat_name_hindi": catNameHindi,
    "formatted_date": "${formattedDate!.year.toString().padLeft(4, '0')}-${formattedDate!.month.toString().padLeft(2, '0')}-${formattedDate!.day.toString().padLeft(2, '0')}",
    "job_img": jobImg,
    "applied": appliedValues.reverse[applied],
    "app_status_name": appStatusName,
    "status_note": statusNote,
    "saved": savedValues.reverse[saved],
  };
}

enum AddedBy {
  SUPER_ADMIN
}

final addedByValues = EnumValues({
  "SuperAdmin": AddedBy.SUPER_ADMIN
});

enum Applied {
  APPLIED,
  NOT
}

final appliedValues = EnumValues({
  "applied": Applied.APPLIED,
  "not": Applied.NOT
});

enum Location {
  MUMBAI,
  RIYADH_SAUDIA,
  WHILEMINA_MCCONNELL
}

final locationValues = EnumValues({
  "Mumbai": Location.MUMBAI,
  "Riyadh Saudia": Location.RIYADH_SAUDIA,
  "Whilemina Mcconnell": Location.WHILEMINA_MCCONNELL
});

enum Saved {
  NOT,
  SAVED
}

final savedValues = EnumValues({
  "not": Saved.NOT,
  "saved": Saved.SAVED
});

class Update {
  int? id;
  String? title;
  String? desc;
  int? trashStatus;
  DateTime? createdAt;
  dynamic updatedAt;

  Update({
    this.id,
    this.title,
    this.desc,
    this.trashStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory Update.fromJson(Map<String, dynamic> json) => Update(
    id: json["id"]??0,
    title: json["title"]??"NA",
    desc: json["desc"]??"NA",
    trashStatus: json["trash_status"]??0,
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"]??"NA",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "desc": desc,
    "trash_status": trashStatus,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt,
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
