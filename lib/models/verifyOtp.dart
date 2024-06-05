// To parse this JSON data, do
//
//     final verifyOtp = verifyOtpFromJson(jsonString);

import 'dart:convert';

VerifyOtp verifyOtpFromJson(String str) => VerifyOtp.fromJson(json.decode(str));

String verifyOtpToJson(VerifyOtp data) => json.encode(data.toJson());

class VerifyOtp {
  VerifyOtp({
    required this.statusCode,
    required this.statusMessage,
    required this.form,
    required this.name
  });

  int statusCode;
  String statusMessage;
  String name;
  int form;

  factory VerifyOtp.fromJson(Map<String, dynamic> json) => VerifyOtp(
    statusCode: json["status_code"]??0,
    statusMessage: json["status_message"]??"NA",
    name: json["name"]??"NA",
    form : json["form"]??0,
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_message": statusMessage,
    "name": name,
    "form":form
  };
}
