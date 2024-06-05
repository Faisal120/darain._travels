// To parse this JSON data, do
//
//     final subscriptionPlan = subscriptionPlanFromJson(jsonString);

import 'dart:convert';

SubscriptionPlan subscriptionPlanFromJson(String str) => SubscriptionPlan.fromJson(json.decode(str));

String subscriptionPlanToJson(SubscriptionPlan data) => json.encode(data.toJson());

class SubscriptionPlan {
  int statusCode;
  List<PlanList> data;

  SubscriptionPlan({
    required this.statusCode,
    required this.data,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) => SubscriptionPlan(
    statusCode: json["status_code"],
    data: List<PlanList>.from(json["data"].map((x) => PlanList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class PlanList {
  int id;
  String planId;
  String name;
  String price;
  int finalPrice;
  int noJobCanApply;
  int maxMonth;
  String des;
  dynamic startDate;
  dynamic endDate;
  String status;
  String trashStatus;
  DateTime createdAt;
  DateTime updatedAt;

  PlanList({
    required this.id,
    required this.planId,
    required this.name,
    required this.price,
    required this.finalPrice,
    required this.noJobCanApply,
    required this.maxMonth,
    required this.des,
    this.startDate,
    this.endDate,
    required this.status,
    required this.trashStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PlanList.fromJson(Map<String, dynamic> json) => PlanList(
    id: json["id"]??"NA",
    planId: json["plan_id"]??"NA",
    name: json["name"]??"NA",
    price: json["price"]??"NA",
    finalPrice: json["final_price"]??"NA",
    noJobCanApply: json["no_job_can_apply"]??"NA",
    maxMonth: json["max_month"]??"NA",
    des: json["des"]??"Lorem ipsum dolor sit Lorem ipsum dolor sit",
    startDate: json["start_date"]??"NA",
    endDate: json["end_date"]??"NA",
    status: json["status"]??"NA",
    trashStatus: json["trash_status"]??"NA",
    createdAt: DateTime.parse(json["created at"]??"NA"),
    updatedAt: DateTime.parse(json["updated at"]??"NA"),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "plan_id": planId,
    "name": name,
    "price": price,
    "final_price": finalPrice,
    "no_job_can_apply": noJobCanApply,
    "max_month": maxMonth,
    "des": des,
    "start_date": startDate,
    "end_date": endDate,
    "status": status,
    "trash_status": trashStatus,
    "created at": createdAt.toIso8601String(),
    "updated at": updatedAt.toIso8601String(),
  };
}
