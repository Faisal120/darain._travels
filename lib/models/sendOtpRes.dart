// To parse this JSON data, do
//
//     final sendOtpRes = sendOtpResFromJson(jsonString);

import 'dart:convert';

SendOtpRes sendOtpResFromJson(String str) => SendOtpRes.fromJson(json.decode(str));

String sendOtpResToJson(SendOtpRes data) => json.encode(data.toJson());

class SendOtpRes {
  SendOtpRes({
    required this.statusCode,
    required this.statusHint,
    required this.userId,
    required this.statusMessage,
  });

  int statusCode;
  String statusHint;
  String userId;
  String statusMessage;

  factory SendOtpRes.fromJson(Map<String, dynamic> json) => SendOtpRes(
    statusCode: json["status_code"],
    statusHint: json["status_hint"],
    userId: json["user_id"],
    statusMessage: json["status_message"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_hint": statusHint,
    "user_id": userId,
    "status_message": statusMessage,
  };
}
