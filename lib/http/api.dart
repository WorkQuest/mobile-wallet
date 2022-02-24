import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:workquest_wallet_app/http/http_client.dart';
import 'package:workquest_wallet_app/model/transactions_response.dart';

import '../main.dart';

class Api {
  static const baseUrl = isRelease
      ? "https://app-ver1.workquest.co/api/v1"
      : "https://app.workquest.co/api/v1";

  static const isRelease = true;

  static const _register = "$baseUrl/auth/register";
  static const _registerWallet = "$baseUrl/auth/register/wallet";
  static const _refreshTokens = "$baseUrl/auth/refresh-tokens";
  static const _confirmEmail = "$baseUrl/auth/confirm-email";
  static const _login = "$baseUrl/auth/login/wallet";

  String _transactions(String address) =>
      "https://dev-explorer.workquest.co/api/v1/account/$address/txs";

  String _transactionsByToken({
    required String address,
    required String addressToken,
  }) =>
      "https://dev-explorer.workquest.co/api/token/$addressToken/account/$address/transfers";

  final _dio = HttpClient().dio;

  Future<Response?> login(String signature, String address) async {
    try {
      final response = await _dio.post(
        _login,
        data: {
          "signature": signature,
          "address": address,
        },
      );
      if (response.statusCode != 200) {
        final message = await getTranslateMessage(
          code: response.data['code'],
          message: response.data['msg'],
        );
        throw FormatException(message);
      }

      HttpClient().setAccessToken = response.data['result']['access'];

      return response;
    } on DioError catch (e) {
      print('cry');
      handleError(e);
    }
  }

  Future<Response?> register(String firstName,
      String lastName,
      String email,
      String password,) async {
    try {
      final response = await _dio.post(
        _register,
        data: {
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "password": password,
        },
      );

      if (response.statusCode != 200) {
        final message = await getTranslateMessage(
          code: response.data['code'],
          message: response.data['msg'],
        );
        throw FormatException(message);
      }

      HttpClient().setAccessToken = response.data['result']['access'];

      return response;
    } on DioError catch (e) {
      await handleError(e);
    }
  }

  Future<bool?> registerWallet(String publicKey, String address) async {
    try {
      final response = await _dio.post(
        _registerWallet,
        data: {
          "publicKey": publicKey,
          "address": address,
        },
      );

      if (response.statusCode != 200) {
        final message = await getTranslateMessage(
          code: response.data['code'],
          message: response.data['msg'],
        );
        throw FormatException(message);
      }

      return response.data['ok'];
    } on DioError catch (e) {
      await handleError(e);
    }
  }

  Future<bool?> confirmEmail({
    required String code,
    required String role,
  }) async {
    try {
      final response = await _dio.post(
        _confirmEmail,
        data: {
          "confirmCode": code,
          "role": role,
        },
      );

      if (response.statusCode != 200) {
        final message = await getTranslateMessage(
          code: response.data['code'],
          message: response.data['msg'],
        );
        throw FormatException(message);
      }

      return response.data['ok'];
    } on DioError catch (e) {
      await handleError(e);
    }
  }

  Future<String?> refreshToken(String refreshToken) async {
    _dio.options.headers["authorization"] = 'bearer $refreshToken';

    try {
      final response = await _dio.post(_refreshTokens);

      if (response.statusCode != 200) {
        final message = await getTranslateMessage(
          code: response.data['code'],
          message: response.data['msg'],
        );
        throw FormatException(message);
      }

      HttpClient().accessToken = response.data['result']['access'];

      return response.data['result']['refresh'];
    } on DioError catch (e) {
      await handleError(e);
    }
  }

  Future<List<Tx>?> getTransactions(String address,
      {int limit = 10, int offset = 0}) async {
    try {
      final response =
      await _dio.get('${_transactions(address)}?limit=$limit&offset=$offset');

      if (response.statusCode != 200) {
        final message = await getTranslateMessage(
          code: response.data['code'],
          message: response.data['msg'],
        );
        throw FormatException(message);
      }

      return TransactionsResponse
          .fromJson(response.data!)
          .result!
          .txs!;
    } on DioError catch (e) {
      await handleError(e);
    }
  }

  Future<List<Tx>?> getTransactionsByToken({
    required String address,
    required String addressToken,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await _dio.get('${_transactionsByToken(
        address: address,
        addressToken: addressToken,
      )}?limit=$limit&offset=$offset');

      if (response.statusCode != 200) {
        final message = await getTranslateMessage(
          code: response.data['code'],
          message: response.data['msg'],
        );
        throw FormatException(message);
      }

      return TransactionsResponse
          .fromJson(response.data!)
          .result!
          .txs!;
    } on DioError catch (e) {
      await handleError(e);
    }
  }

  handleError(DioError e) async {
    if (e.response == null) {
      final message = await getTranslateMessage();
      throw FormatException(message);
    } else {
      final message = await getTranslateMessage(
        code: e.response!.data['code'],
        message: e.response!.data['msg'],
      );
      throw FormatException(message);
    }
  }

  Future<String> getTranslateMessage({int? code, String? message}) async {
    print("getmessage is called");
    if (code == null) {
      return 'errors.notInternet'.tr();
    }
    try {
      String fileString;
      print("language string ${EasyLocalization.of(globalContext!)!.locale}");
      if (EasyLocalization.of(globalContext!)!.locale == const Locale("ru", "RU")) {
        fileString = await rootBundle.loadString('assets/lang/ru-RU.json');
      } else {
        fileString = await rootBundle.loadString('assets/lang/en-US.json');
      }

      Map<String, dynamic> jsonDecoded = jsonDecode(fileString);
      var errorValue = jsonDecoded[code.toString()];
      if (errorValue == null) {
        return message!;
      }
      return errorValue;
    } catch (e) {
      return Future.value("Error. Code $code");
    }
  }
}
