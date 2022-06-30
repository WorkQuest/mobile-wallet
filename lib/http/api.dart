import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/http/http_client.dart';
import 'package:workquest_wallet_app/model/transactions_response.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';

import '../main.dart';
import '../model/course_tokens_response.dart';
import '../model/txs_info_response.dart';

class Api {
  static final Api _instance = Api._internal();

  factory Api() => _instance;

  Api._internal();

  String get _baseUrl {
    if (_network == Network.testnet) {
      return 'https://dev-app.workquest.co/api/v1';
    } else if (_network == Network.mainnet) {
      return 'https://app.workquest.co/api/v1';
    }
    return 'https://app.workquest.co/api/v1';
  }

  Network get _network => AccountRepository().notifierNetwork.value;

  String get _register => "$_baseUrl/auth/register";

  String get _login => "$_baseUrl/auth/login/wallet";

  String get _confirmEmail => "$_baseUrl/auth/confirm-email";

  String get _refreshTokens => "$_baseUrl/auth/refresh-tokens";

  String get _resendEmail => "$_baseUrl/auth/main/resend-email";

  String get _registerWallet => "$_baseUrl/auth/register/wallet";

  String get _courseWQT {
    if (_network == Network.testnet) {

    } else {

    }
    return "https://dev-oracle.workquest.co/api/v1/oracle/sign-price/tokens";
  }

  String _walletAddressProfile(String address) => "$_baseUrl/profile/wallet/$address";

  String _transactions(String address) {
    if (_network == Network.testnet) {
      return "https://testnet-explorer-api.workquest.co/api/v1/account/$address/transactions";
    } else {
      return "https://mainnet-explorer-api.workquest.co/api/v1/account/$address/transactions";
    }
  }

  String _transactionsByToken({
    required String address,
    required String addressToken,
  }) {
    if (_network == Network.testnet) {
      return "https://testnet-explorer-api.workquest.co/api/v1/token/$addressToken/account/$address/transfers";
    } else {
      return "https://mainnet-explorer-api.workquest.co/api/v1/token/$addressToken/account/$address/transfers";
    }
  }

  String _transactionInfo({
    required String hashTx,
  }) =>
      "https://testnet-explorer-api.workquest.co/api/v1/transaction/$hashTx";

  final _dio = MyHttpClient().dio;

  Future<Response?> login(String signature, String address, {bool? isMain}) async {
    try {
      final response = await _dio.post(
        isMain == null
            ? _login
            : (isMain
                ? 'https://app.workquest.co/api/v1/auth/login/wallet'
                : 'https://dev-app.workquest.co/api/v1/auth/login/wallet'),
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

      MyHttpClient().setAccessToken = response.data['result']['access'];

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

      MyHttpClient().setAccessToken = response.data['result']['access'];

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

      MyHttpClient().accessToken = response.data['result']['access'];

      return response.data['result']['refresh'];
    } on DioError catch (e) {
      await handleError(e);
    }
    return null;
  }

  Future<List<Tx>?> getTransactions(String address, {int limit = 10, int offset = 0}) async {
    try {
      final response = await _dio.get('${_transactions(address)}?limit=$limit&offset=$offset');

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

      return List<Tx>.from(response.data['result']['txs'].map((x) => Tx.fromJson(x)));
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

  Future<double?> getCourseWQT() async {
    try {
      final response = await _dio.get(_courseWQT);

      if (response.statusCode != 200) {
        final message = await getTranslateMessage(
          code: response.data['code'],
          message: response.data['msg'],
        );
        throw FormatException(message);
      }

      final result = CourseTokenResponse.fromJson(response.data);
      final _indexWQT = result.result!.symbols!.indexWhere((element) => element == 'WQT');
      final _course = result.result!.prices![_indexWQT];
      return double.parse(_course) * pow(10, -18);
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
