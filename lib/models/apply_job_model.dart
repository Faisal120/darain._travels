import 'dart:convert';

ApplyJob applyJobFromJson(String str) => ApplyJob.fromJson(json.decode(str));

String applyJobToJson(ApplyJob data) => json.encode(data.toJson());

class ApplyJob {
  int statusCode;
  String statusMessage;

  ApplyJob({
    required this.statusCode,
    required this.statusMessage,
  });

  factory ApplyJob.fromJson(Map<String, dynamic> json) => ApplyJob(
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_message": statusMessage,
  };
}
