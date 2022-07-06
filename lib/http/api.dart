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

class Api {
  static final Api _instance = Api._internal();

  factory Api() => _instance;

  Api._internal();

  Network get _network => AccountRepository().notifierNetwork.value;

  String get _courseWQT {
    // if (_network == Network.testnet) {
    //   return "https://testnet-oracle.workquest.co/api/v1/oracle/sign-price/tokens";
    // }
    return "https://mainnet-oracle.workquest.co/api/v1/oracle/sign-price/tokens";
  }

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

  final _dio = MyHttpClient().dio;

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
      final _indexWQT =
          result.result!.symbols!.indexWhere((element) => element == 'WQT');
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
