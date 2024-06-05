// To parse this JSON data, do
//
//     final jobDetailsModel = jobDetailsModelFromJson(jsonString);

import 'dart:convert';

JobDetailsModel jobDetailsModelFromJson(String str) => JobDetailsModel.fromJson(json.decode(str));

String jobDetailsModelToJson(JobDetailsModel data) => json.encode(data.toJson());

class JobDetailsModel {
  int statusCode;
  int count;
  List<JobList> jobs;

  JobDetailsModel({
    required this.statusCode,
    required this.count,
    required this.jobs,
  });

  factory JobDetailsModel.fromJson(Map<String, dynamic> json) => JobDetailsModel(
    statusCode: json["status_code"]??0,
    count: json["count"]??0,
    jobs: json["jobs"] != null ? List<JobList>.from(json["jobs"].map((x) => JobList.fromJson(x))) : [],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "count": count,
    "jobs": List<dynamic>.from(jobs.map((x) => x.toJson())),
  };
}

class JobList {
  int id;
  String jobId;
  String addedBy;
  String title;
  String category;
  String img;
  String jobType;
  int noOfJob;
  String location;
  String salary;
  String selectionMode;
  DateTime? expireAt;
  String description;
  int featured;
  int status;
  int trashStatus;
  DateTime createdAt;
  DateTime updatedAt;
  String appStatus;
  dynamic statusNote;
  String catId;
  String catName;
  String catNameHindi;
  DateTime formattedDate;
  String jobImg;
  String applied;
  String appStatusName;
  String saved;

  JobList({
    required this.id,
    required this.jobId,
    required this.addedBy,
    required this.title,
    required this.category,
    required this.img,
    required this.jobType,
    required this.noOfJob,
    required this.location,
    required this.salary,
    this.expireAt,
    required this.description,
    required this.featured,
    required this.status,
    required this.trashStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.appStatus,
    this.statusNote,
    required this.selectionMode,
    required this.catId,
    required this.catName,
    required this.catNameHindi,
    required this.formattedDate,
    required this.jobImg,
    required this.applied,
    required this.appStatusName,
    required this.saved,
  });

  factory JobList.fromJson(Map<String, dynamic> json) => JobList(
    id: json["id"]??0,
    jobId: json["job_id"]??"NA",
    addedBy: json["added_by"]??"NA",
    title: json["title"]??"NA",
    category: json["category"]??"NA",
    img: json["img"]??"NA",
    jobType: json["job_type"]??"NA",
    noOfJob: json["no_of_job"]??0,
    location: json["location"]??"NA",
    salary: json["salary"]??"NA",
    selectionMode: json["selection_mode"]??"NA",
    expireAt: json["expire_at"] == null ? null : DateTime.parse(json["expire_at"]),
    description: json["description"]??"NA",
    featured: json["featured"]??0,
    status: json["status"]??0,
    trashStatus: json["trash_status"]??0,
    createdAt: DateTime.parse(json["created_at"]??"0000-00-00"),
    updatedAt: DateTime.parse(json["updated_at"]??"0000-00-00"),
    appStatus: json["app_status"]??"NA",
    statusNote: json["status_note"]??"",
    catId: json["cat_id"]??"NA",
    catName: json["cat_name"]??"NA",
    catNameHindi: json["cat_name_hindi"]??"NA",
    formattedDate: DateTime.parse(json["formatted_date"]??"0000-00-00"),
    jobImg: json["job_img"]??"NA",
    applied: json["applied"]??"NA",
    appStatusName: json["app_status_name"]??"NA",
    saved: json["saved"]??"NA",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "job_id": jobId,
    "added_by": addedBy,
    "title": title,
    "category": category,
    "img": img,
    "job_type": jobType,
    "no_of_job": noOfJob,
    "location": location,
    "salary": salary,
    "selection_mode": selectionMode,
    "expire_at": "${expireAt!.year.toString().padLeft(4, '0')}-${expireAt!.month.toString().padLeft(2, '0')}-${expireAt!.day.toString().padLeft(2, '0')}",
    "description": description,
    "featured": featured,
    "status": status,
    "trash_status": trashStatus,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "app_status": appStatus,
    "status_note": statusNote,
    "cat_id": catId,
    "cat_name": catName,
    "cat_name_hindi": catNameHindi,
    "formatted_date": "${formattedDate.year.toString().padLeft(4, '0')}-${formattedDate.month.toString().padLeft(2, '0')}-${formattedDate.day.toString().padLeft(2, '0')}",
    "job_img": jobImg,
    "applied": applied,
    "app_status_name": appStatusName,
    "saved": saved,
  };
}
