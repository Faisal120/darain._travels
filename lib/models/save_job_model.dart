import 'dart:convert';

SaveJob saveJobFromJson(String str) => SaveJob.fromJson(json.decode(str));

String saveJobToJson(SaveJob data) => json.encode(data.toJson());

class SaveJob {
  int statusCode;
  String statusMessage;

  SaveJob({
    required this.statusCode,
    required this.statusMessage,
  });

  factory SaveJob.fromJson(Map<String, dynamic> json) => SaveJob(
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_message": statusMessage,
  };
}
