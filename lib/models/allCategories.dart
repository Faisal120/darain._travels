// To parse this JSON data, do
//
//     final allCategories = allCategoriesFromJson(jsonString);

import 'dart:convert';

AllCategories allCategoriesFromJson(String str) => AllCategories.fromJson(json.decode(str));

String allCategoriesToJson(AllCategories data) => json.encode(data.toJson());

class AllCategories {
  AllCategories({
    required this.statusCode,
    required this.data,
  });

  int statusCode;
  List<Datum> data;

  factory AllCategories.fromJson(Map<String, dynamic> json) => AllCategories(
    statusCode: json["status_code"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.id,
    required this.catId,
    required this.img,
    required this.catName,
    required this.catNameHindi,
    required this.status,
    required this.trashStatus,
    required this.createdAt,
    required this.updatedAt,
    this.isSelected,
  });

  int id;
  String catId;
  String img;
  String catName;
  String catNameHindi;
  String status;
  String trashStatus;
  DateTime createdAt;
  DateTime updatedAt;
  bool? isSelected;


  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"]??0,
    catId: json["cat_id"]??"123",
    img: json["img"]??"NA",
    catName: json["cat_name"]??"NA",
    catNameHindi: json["cat_name_hindi"]??"NA",
    status: json["status"]??"NA",
    trashStatus: json["trash_status"]??"NA",
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    isSelected: json["isSelected"]??false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cat_id": catId,
    "img": img,
    "cat_name": catName,
    "cat_name_hindi": catNameHindi,
    "status": status,
    "trash_status": trashStatus,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "isSelected": isSelected
  };
}
