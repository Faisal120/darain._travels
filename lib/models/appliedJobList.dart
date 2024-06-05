// To parse this JSON data, do
//
//     final appliedJobList = appliedJobListFromJson(jsonString);

import 'dart:convert';

AppliedJobList appliedJobListFromJson(String str) => AppliedJobList.fromJson(json.decode(str));

String appliedJobListToJson(AppliedJobList data) => json.encode(data.toJson());

class AppliedJobList {
  int statusCode;
  int count;
  List<AppliedJobs> jobs;

  AppliedJobList({
    required this.statusCode,
    required this.count,
    required this.jobs,
  });

  factory AppliedJobList.fromJson(Map<String, dynamic> json) => AppliedJobList(
    statusCode: json["status_code"]??"NA",
    count: json["count"]??"NA",
    jobs: List<AppliedJobs>.from(json["jobs"].map((x) => AppliedJobs.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "count": count,
    "jobs": List<dynamic>.from(jobs.map((x) => x.toJson())),
  };
}

class AppliedJobs {
  int id;
  String appId;
  String userId;
  String jobId;
  int trash;
  DateTime createdAt;
  DateTime updatedAt;
  String title;
  String category;
  String img;
  String jobType;
  String? location;
  String salary;
  String statusNote;
  DateTime expireAt;
  String description;
  int featured;
  int status;
  int trashStatus;
  String catId;
  String catName;
  String? catNameHindi;
  DateTime formattedDate;

  AppliedJobs({
    required this.id,
    required this.appId,
    required this.userId,
    required this.jobId,
    required this.trash,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.category,
    required this.img,
    required this.jobType,
    this.location,
    required this.statusNote,
    required this.salary,
    required this.expireAt,
    required this.description,
    required this.featured,
    required this.status,
    required this.trashStatus,
    required this.catId,
    required this.catName,
    this.catNameHindi,
    required this.formattedDate,
  });

  factory AppliedJobs.fromJson(Map<String, dynamic> json) => AppliedJobs(
    id: json["id"]??"NA",
    appId: json["app_id"]??"NA",
    userId: json["user_id"]??"NA",
    jobId: json["job_id"]??"NA",
    trash: json["trash"]??"NA",
    createdAt: DateTime.parse(json["created_at"]??"NA"),
    updatedAt: DateTime.parse(json["updated_at"]??"NA"),
    title: json["title"]??"NA",
    category: json["category"]??"NA",
    img: json["img"]??"NA",
    jobType: json["job_type"]??"NA",
    location: json["location"]??"NA",
    salary: json["salary"]??"NA",
    expireAt: DateTime.parse(json["expire_at"]??"NA"),
    description: json["description"]??"NA",
    featured: json["featured"]??"NA",
    status: json["status"]??"NA",
    trashStatus: json["trash_status"]??"NA",
    catId: json["cat_id"]??"NA",
    catName: json["cat_name"]??"NA",
    catNameHindi: json["cat_name_hindi"]??"NA",
    formattedDate: DateTime.parse(json["formatted_date"]??"NA"),
    statusNote: json["status_note"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "app_id": appId,
    "user_id": userId,
    "job_id": jobId,
    "trash": trash,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "title": title,
    "category": category,
    "img": img,
    "job_type": jobType,
    "location": location,
    "salary": salary,
    "status_note": statusNote,
    "expire_at": "${expireAt.year.toString().padLeft(4, '0')}-${expireAt.month.toString().padLeft(2, '0')}-${expireAt.day.toString().padLeft(2, '0')}",
    "description": description,
    "featured": featured,
    "status": status,
    "trash_status": trashStatus,
    "cat_id": catId,
    "cat_name": catName,
    "cat_name_hindi": catNameHindi,
    "formatted_date": "${formattedDate.year.toString().padLeft(4, '0')}-${formattedDate.month.toString().padLeft(2, '0')}-${formattedDate.day.toString().padLeft(2, '0')}",
  };
}
