// To parse this JSON data, do
//
//     final offerResponse = offerResponseFromJson(jsonString);

import 'dart:convert';

// OfferResponse offerResponseFromJson(String str) => OfferResponse.fromJson(json.decode(str));

// String offerResponseToJson(OfferResponse data) => json.encode(data.toJson());

class OfferResponse {
  DiscountInfo? discountInfo;
  String? error;

  OfferResponse({
    this.discountInfo,
    this.error,
  });

  factory OfferResponse.fromJson(Map<String, dynamic> json) => OfferResponse(
    discountInfo: json["discount_info"] == null ? null : DiscountInfo.fromJson(json["discount_info"]),
    error: json["error"],
  );

  // Map<String, dynamic> toJson() => {
  //   "discount_info": discountInfo?.toJson(),
  // };
}

OfferResponse parseResponse(String responseJson) {
  final Map<String, dynamic> json = jsonDecode(responseJson);

  if (json.containsKey('discount_info')) {
    return OfferResponse(discountInfo: DiscountInfo.fromJson(json["discount_info"]), error: null);
  } else if (json.containsKey('error')) {
    return OfferResponse(discountInfo: null, error: json['error']);
  } else {
    throw Exception("Invalid response format");
  }
}

class DiscountInfo {
  String? type;
  int? value;

  DiscountInfo({
    this.type,
    this.value,
  });

  factory DiscountInfo.fromJson(Map<String, dynamic> json) => DiscountInfo(
    type: json["type"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "value": value,
  };
}
