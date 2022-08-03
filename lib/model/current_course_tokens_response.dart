// To parse this JSON data, do
//
//     final currentCourseTokensResponse = currentCourseTokensResponseFromJson(jsonString);

import 'dart:convert';

CurrentCourseTokensResponse currentCourseTokensResponseFromJson(String str) =>
    CurrentCourseTokensResponse.fromJson(json.decode(str));

String currentCourseTokensResponseToJson(CurrentCourseTokensResponse data) =>
    json.encode(data.toJson());

class CurrentCourseTokensResponse {
  CurrentCourseTokensResponse({
    this.ok,
    this.result,
  });

  bool? ok;
  List<Result>? result;

  factory CurrentCourseTokensResponse.fromJson(Map<String, dynamic> json) =>
      CurrentCourseTokensResponse(
        ok: json["ok"],
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "result": List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    this.symbol,
    this.price,
    this.timestamp,
  });

  String? symbol;
  String? price;
  String? timestamp;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        symbol: json["symbol"],
        price: json["price"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "price": price,
        "timestamp": timestamp,
      };
}
