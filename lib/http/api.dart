import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:workquest_wallet_app/http/http_client.dart';
import 'package:workquest_wallet_app/model/transactions_response.dart';

import '../main.dart';
import '../model/txs_info_response.dart';

class Api {
  static const baseUrl = isRelease
      ? "https://app-ver1.workquest.co/api/v1"
      : "https://app.workquest.co/api/v1";

  static const isRelease = true;

  static const _register = "$baseUrl/auth/register";
  static const _login = "$baseUrl/auth/login/wallet";
  static const _confirmEmail = "$baseUrl/auth/confirm-email";
  static const _refreshTokens = "$baseUrl/auth/refresh-tokens";
  static const _resendEmail = "$baseUrl/auth/main/resend-email";
  static const _registerWallet = "$baseUrl/auth/register/wallet";

  String _transactions(String address) =>
      "https://dev-explorer.workquest.co/api/v1/account/$address/transactions";

  String _walletAddressProfile(String address) =>
      "$baseUrl/profile/wallet/$address";

  String _transactionsByToken({
    required String address,
    required String addressToken,
  }) =>
      "https://dev-explorer.workquest.co/api/v1/token/$addressToken/account/$address/transfers";

  String _transactionInfo({
    required String hashTx,
  }) =>
      "https://dev-explorer.workquest.co/api/v1/transaction/$hashTx";

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
      await handleError(e);
    }
    return null;
  }

  Future<Response?> register(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
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
    return null;
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
    return null;
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
        throw FormatException(response.data['msg']);
      }

      return response.data['ok'];
    } on DioError catch (e) {
      print('catch DioError');
      await handleError(e, translate: false);
    }
    return null;
  }

  Future<bool?> resendCodeEmail({required String email}) async {
    try {
      final response = await _dio.post(
        _resendEmail,
        data: {
          "email": email,
        },
      );

      if (response.statusCode != 200) {
        throw FormatException(response.data['msg']);
      }

      return response.data['ok'];
    } on DioError catch (e) {
      print('catch DioError');
      await handleError(e, translate: false);
    }
    return null;
  }

  Future<String?> getEmailProfile({required String address}) async {
    try {
      final response = await _dio.get(_walletAddressProfile(address));

      if (response.statusCode != 200) {
        throw FormatException(response.data['msg']);
      }

      return response.data['result']['email'];
    } on DioError catch (e) {
      print('catch DioError');
      await handleError(e, translate: false);
    }
    return null;
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
    return null;
  }

  Future<List<Tx>?> getTransactions(String address,
      {int limit = 10, int offset = 0}) async {
    try {
      final response = await _dio
          .get('${_transactions(address)}?limit=$limit&offset=$offset');

      if (response.statusCode != 200) {
        final message = await getTranslateMessage(
          code: response.data['code'],
          message: response.data['msg'],
        );
        throw FormatException(message);
      }

      return TransactionsResponse.fromJson(response.data).result!.txs;
    } on DioError catch (e) {
      await handleError(e);
    }
    return null;
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

      return List<Tx>.from(
          response.data['result']['txs'].map((x) => Tx.fromJson(x)));
    } on DioError catch (e) {
      await handleError(e);
    }
    return null;
  }


  Future<TxInfoResponse?> getTransaction({
    required String hashTx,
  }) async {
    try {
      final response = await _dio.get(_transactionInfo(hashTx: hashTx));

      if (response.statusCode != 200) {
        final message = await getTranslateMessage(
          code: response.data['code'],
          message: response.data['msg'],
        );
        throw FormatException(message);
      }

      return TxInfoResponse.fromJson(response.data);
    } on DioError catch (e) {
      await handleError(e);
    }
    return null;
  }

  handleError(DioError e, {bool translate = true}) async {
    if (e.response == null) {
      final message = await getTranslateMessage();
      throw FormatException(message);
    } else {
      if (translate) {
        final message = await getTranslateMessage(
          code: e.response!.data['code'],
          message: e.response!.data['msg'],
        );
        throw FormatException(message);
      } else {
        print('FormatException(e.response!.data[' "msg" '])');
        throw FormatException(e.response!.data['msg']);
      }
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
      if (EasyLocalization.of(globalContext!)!.locale ==
          const Locale("ru", "RU")) {
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
