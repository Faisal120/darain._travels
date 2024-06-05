// To parse this JSON data, do
//
//     final updateProfile = updateProfileFromJson(jsonString);

import 'dart:convert';

UpdateProfile updateProfileFromJson(String str) => UpdateProfile.fromJson(json.decode(str));

String updateProfileToJson(UpdateProfile data) => json.encode(data.toJson());

class UpdateProfile {
  int statusCode;
  String statusMessage;
  User user;

  UpdateProfile({
    required this.statusCode,
    required this.statusMessage,
    required this.user,
  });

  factory UpdateProfile.fromJson(Map<String, dynamic> json) => UpdateProfile(
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
    user: User.fromJson(json["user"]),
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
  String profileUrl;
  String category;
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
  String cv;
  dynamic idProof;
  dynamic passport;
  dynamic visa;
  dynamic panCard;

  User({
    required this.id,
    required this.userId,
    this.addedBy,
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
    this.leadSource,
    this.positionId,
    required this.overseasExp,
    required this.indianExp,
    this.language,
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
    this.idProof,
    this.passport,
    this.visa,
    this.panCard,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"]??0,
    userId: json["user_id"]??"NA",
    addedBy: json["added_by"]??"NA",
    name: json["name"]??"NA",
    cCode: json["c_code"]??"NA",
    mobile: json["mobile"]??"NA",
    email: json["email"]??"NA",
    otp: json["otp"]??"NA",
    dob: DateTime.parse(json["dob"]??"NA"),
    gender: json["gender"]??"NA",
    profileUrl: json["profile_url"]??"NA",
    category: json["category"]??"NA",
    nationality: json["nationality"]??"NA",
    location: json["location"]??"NA",
    qualification: json["qualification"]??"NA",
    leadSource: json["lead_source"]??"NA",
    positionId: json["position_id"]??"NA",
    overseasExp: json["overseas_exp"]??"NA",
    indianExp: json["indian_exp"]??"NA",
    language: json["language"]??"NA",
    plan: json["plan"]??"NA",
    status: json["status"]??"NA",
    kycFormStatus: json["kyc_form_status"]??"NA",
    loginStatus: json["login_status"]??"NA",
    verif: json["verif"]??"NA",
    adminStatus: json["admin_status"]??"NA",
    trashStatus: json["trash_status"]??"NA",
    createdAt: DateTime.parse(json["created_at"]??"NA"),
    updatedAt: DateTime.parse(json["updated_at"]??"NA"),
    cv: json["cv"]??"NA",
    idProof: json["id_proof"]??"NA",
    passport: json["passport"]??"NA",
    visa: json["visa"]??"NA",
    panCard: json["pan_card"]??"NA",
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
