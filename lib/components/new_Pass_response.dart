import 'dart:convert';

NewPassResponseModel newPassResponseJson(String str) =>
    NewPassResponseModel.fromJson(json.decode(str));

class NewPassResponseModel {
  NewPassResponseModel({required this.message, this.data});

  late final String message;
  late final dynamic data; // Use dynamic to handle various types

  NewPassResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'];
  }
}
