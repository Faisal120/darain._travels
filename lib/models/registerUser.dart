// To parse this JSON data, do
//
//     final registerUser = registerUserFromJson(jsonString);

import 'dart:convert';

RegisterUser registerUserFromJson(String str) => RegisterUser.fromJson(json.decode(str));

String registerUserToJson(RegisterUser data) => json.encode(data.toJson());

class RegisterUser {
  int statusCode;
  String statusMessage;
  User user;

  RegisterUser({
    required this.statusCode,
    required this.statusMessage,
    required this.user,
  });

  factory RegisterUser.fromJson(Map<String, dynamic> json) => RegisterUser(
    statusCode: json["status_code"]??"",
    statusMessage: json["status_message"]??"",
    user: User.fromJson(json["user"]??[]),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_message": statusMessage,
    "user": user.toJson(),
  };
}

class User {
  int id;
  String userId;
  dynamic addedBy;
  String name;
  String cCode;
  String mobile;
  String email;
  String otp;
  DateTime dob;
  String gender;
  dynamic profileUrl;
  dynamic category;
  String nationality;
  String location;
  String qualification;
  dynamic leadSource;
  dynamic positionId;
  int overseasExp;
  int indianExp;
  dynamic language;
  String plan;
  int status;
  int kycFormStatus;
  String loginStatus;
  String verif;
  String adminStatus;
  String trashStatus;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic cv;
  dynamic idProof;
  dynamic passport;
  dynamic visa;
  dynamic panCard;

  User({
    required this.id,
    required this.userId,
    required this.addedBy,
    required this.name,
    required this.cCode,
    required this.mobile,
    required this.email,
    required this.otp,
    required this.dob,
    required this.gender,
    required this.profileUrl,
    required this.category,
    required this.nationality,
    required this.location,
    required this.qualification,
    required this.leadSource,
    required this.positionId,
    required this.overseasExp,
    required this.indianExp,
    required this.language,
    required this.plan,
    required this.status,
    required this.kycFormStatus,
    required this.loginStatus,
    required this.verif,
    required this.adminStatus,
    required this.trashStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.cv,
    required this.idProof,
    required this.passport,
    required this.visa,
    required this.panCard,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"]??"",
    userId: json["user_id"]??"",
    addedBy: json["added_by"]??"",
    name: json["name"]??"",
    cCode: json["c_code"]??"",
    mobile: json["mobile"]??"",
    email: json["email"]??"",
    otp: json["otp"]??"",
    dob: DateTime.parse(json["dob"]??""),
    gender: json["gender"]??"",
    profileUrl: json["profile_url"]??"",
    category: json["category"]??"",
    nationality: json["nationality"]??"",
    location: json["location"]??"",
    qualification: json["qualification"]??"",
    leadSource: json["lead_source"]??"",
    positionId: json["position_id"]??"",
    overseasExp: json["overseas_exp"]??"",
    indianExp: json["indian_exp"]??"",
    language: json["language"]??"",
    plan: json["plan"]??"",
    status: json["status"]??"",
    kycFormStatus: json["kyc_form_status"]??"",
    loginStatus: json["login_status"]??"",
    verif: json["verif"]??"",
    adminStatus: json["admin_status"]??"",
    trashStatus: json["trash_status"]??"",
    createdAt: DateTime.parse(json["created_at"]??""),
    updatedAt: DateTime.parse(json["updated_at"]??""),
    cv: json["cv"]??"",
    idProof: json["id_proof"]??"",
    passport: json["passport"]??"",
    visa: json["visa"]??"",
    panCard: json["pan_card"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "added_by": addedBy,
    "name": name,
    "c_code": cCode,
    "mobile": mobile,
    "email": email,
    "otp": otp,
    "dob": "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
    "gender": gender,
    "profile_url": profileUrl,
    "category": category,
    "nationality": nationality,
    "location": location,
    "qualification": qualification,
    "lead_source": leadSource,
    "position_id": positionId,
    "overseas_exp": overseasExp,
    "indian_exp": indianExp,
    "language": language,
    "plan": plan,
    "status": status,
    "kyc_form_status": kycFormStatus,
    "login_status": loginStatus,
    "verif": verif,
    "admin_status": adminStatus,
    "trash_status": trashStatus,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "cv": cv,
    "id_proof": idProof,
    "passport": passport,
    "visa": visa,
    "pan_card": panCard,
  };
}
