// To parse this JSON data, do
//
//     final getProfile = getProfileFromJson(jsonString);

import 'dart:convert';

GetProfile getProfileFromJson(String str) => GetProfile.fromJson(json.decode(str));

String getProfileToJson(GetProfile data) => json.encode(data.toJson());

class GetProfile {
  int statusCode;
  String statusMessage;
  UserProfileCard data;
  List<String> cat;

  GetProfile({
    required this.statusCode,
    required this.statusMessage,
    required this.data,
    required this.cat,
  });

  factory GetProfile.fromJson(Map<String, dynamic> json) => GetProfile(
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
    data: UserProfileCard.fromJson(json["data"]),
    cat: List<String>.from(json["cat"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_message": statusMessage,
    "data": data.toJson(),
    "cat": List<dynamic>.from(cat.map((x) => x)),
  };
}

class UserProfileCard {
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
  String? expCert;
  String? eduCert;


  UserProfileCard({
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
    this.expCert,
    this.eduCert,
  });

  factory UserProfileCard.fromJson(Map<String, dynamic> json) => UserProfileCard(
    id: json["id"]??0,
    userId: json["user_id"]??"NA",
    addedBy: json["added_by"]??"NA",
    name: json["name"]??"NA",
    cCode: json["c_code"]??"NA",
    mobile: json["mobile"]??"NA",
    email: json["email"]??"NA",
    otp: json["otp"]??"NA",
    dob: DateTime.parse(json["dob"]??"NA"),
    gender: json["gender"]??"Select Gender",
    profileUrl: json["profile_url"]??"NA",
    category: json["category"]??"NA",
    nationality: json["nationality"]??"Country",
    location: json["location"]??"State",
    qualification: json["qualification"]??"Education",
    leadSource: json["lead_source"]??"NA",
    positionId: json["position_id"]??"NA",
    overseasExp: json["overseas_exp"]??0,
    indianExp: json["indian_exp"]??0,
    language: json["language"]??"NA",
    plan: json["plan"]??"NA",
    status: json["status"]??0,
    kycFormStatus: json["kyc_form_status"]??0,
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
    expCert: json["exp_cert"]??"NA",
    eduCert: json["edu_cert"]??"NA"
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
    "exp_cert":expCert,
    "edu_cert":eduCert
  };
}
