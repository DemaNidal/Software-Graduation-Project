import 'dart:convert';

import 'package:JAFFA/components/new_Pass_response.dart';
import 'package:http/http.dart' as http;
import 'package:JAFFA/components/otp_login_response_model.dart';
import 'package:JAFFA/components/config.dart';

class APIService {
  static var client = http.Client();

  static Future<OtpLoginResponseModel> otpLogin(String email) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    var url = Uri.http(Config.apiURL, Config.otpLoginAPI);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(
        {"email": email},
      ),
    );

    return otpLoginResponseJson(response.body);
  }

  static Future<OtpLoginResponseModel> verifyOTP(
    String email,
    String otpHash,
    String otpCode,
  ) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    var url = Uri.http(Config.apiURL, Config.otpVerifyAPI);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(
        {
          "email": email,
          "otp": otpCode,
          "hash": otpHash,
        },
      ),
    );

    return otpLoginResponseJson(response.body);
  }

  static Future<NewPassResponseModel> newPass(
      String email, String newPassword) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    var url = Uri.http(Config.apiURL, Config.newPassAPI);

    var response = await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode(
        {"email": email, "newPassword": newPassword},
      ),
    );

    return NewPassResponseModel.fromJson(jsonDecode(response.body));
  }
}
