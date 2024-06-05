// To parse this JSON data, do
//
//     final planValidityRes = planValidityResFromJson(jsonString);

import 'dart:convert';

PlanValidityRes planValidityResFromJson(String str) => PlanValidityRes.fromJson(json.decode(str));

String planValidityResToJson(PlanValidityRes data) => json.encode(data.toJson());

class PlanValidityRes {
  int? statusCode;
  String? planName;
  String? mess;
  DateTime? date;
  DateTime? activeDate;
  int? jobLeft;
  int? totalAvJob;
  int? totalApplied;

  PlanValidityRes({
    this.statusCode,
    this.planName,
    this.mess,
    this.date,
    this.jobLeft,
    this.activeDate,
    this.totalAvJob,
    this.totalApplied
  });

  factory PlanValidityRes.fromJson(Map<String, dynamic> json) => PlanValidityRes(
    statusCode: json["status_code"],
    planName: json["plan_name"],
    mess: json["mess"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    activeDate: json["active_date"] == null ? null : DateTime.parse(json["active_date"]),
    jobLeft: json["job_left"],
    totalAvJob: json["total_av_job"],
    totalApplied: json["total_applied"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "plan_name": planName,
    "mess": mess,
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "active_date": "${activeDate!.year.toString().padLeft(4, '0')}-${activeDate!.month.toString().padLeft(2, '0')}-${activeDate!.day.toString().padLeft(2, '0')}",
    "job_left": jobLeft,
    "total_av_job": totalAvJob,
    "total_applied": totalApplied,
  };
}
