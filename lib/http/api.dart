import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/http/http_client.dart';
import 'package:workquest_wallet_app/main.dart';
import 'package:workquest_wallet_app/model/course_tokens_response.dart';
import 'package:workquest_wallet_app/model/current_course_tokens_response.dart';
import 'package:workquest_wallet_app/model/transactions_response.dart';
import 'package:workquest_wallet_app/model/tx_other_network_response.dart';
import 'package:workquest_wallet_app/repository/session_repository.dart';
import 'package:workquest_wallet_app/utils/web3_utils.dart';

class Api {
  static final Api _instance = Api._internal();

  factory Api() => _instance;

  Api._internal();

  Network get _network => GetIt.I.get<SessionRepository>().notifierNetwork.value;

  bool get _isTestnet => _network == Network.testnet;

  String get _courseWQT {
    if (_isTestnet) {
      return "https://testnet-oracle.workquest.co/api/v1/oracle/sign-price/tokens";
    }
    return "https://mainnet-oracle.workquest.co/api/v1/oracle/sign-price/tokens";
  }

  String get _courseTokens {
    if (_isTestnet) {
      return "https://testnet-oracle.workquest.co/api/v1/oracle/current-prices";
    }
    return "https://mainnet-oracle.workquest.co/api/v1/oracle/current-prices";
  }

  String _transactions(String address) {
    if (_isTestnet) {
      return "https://testnet-explorer-api.workquest.co/api/v1/account/$address/transactions";
    } else {
      return "https://mainnet-explorer-api.workquest.co/api/v1/account/$address/transactions";
    }
  }

  String _transactionsByToken({
    required String address,
    required String addressToken,
  }) {
    if (_isTestnet) {
      return "https://testnet-explorer-api.workquest.co/api/v1/token/$addressToken/account/$address/transfers";
    } else {
      return "https://mainnet-explorer-api.workquest.co/api/v1/token/$addressToken/account/$address/transfers";
    }
  }

  String _transactionOtherNetwork({
    required SwitchNetworkNames network,
  }) {
    switch (network) {
      case SwitchNetworkNames.WORKNET:
        return '';
      case SwitchNetworkNames.ETH:
        return _isTestnet ? 'https://api-rinkeby.etherscan.io/api' : '';
      case SwitchNetworkNames.BSC:
        return _isTestnet ? 'https://api-testnet.bscscan.com/api' : '';
      case SwitchNetworkNames.POLYGON:
        return _isTestnet ? 'https://api-testnet.polygonscan.com/api' : '';
    }
  }

  final _dio = MyHttpClient().dio;

  Future<List<Tx>?> getTransactions(String address, {int limit = 10, int offset = 0}) async {
    try {
      final response = await _dio.get('${_transactions(address)}?limit=$limit&offset=$offset');

      if (response.statusCode != 200) {
        final message = await getTranslateMessage(
          code: response.data['code'],
          message: response.data['msg'],
        );
        throw ApiException(message);
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
        throw ApiException(message);
      }

      return List<Tx>.from(response.data['result']['txs'].map((x) => Tx.fromJson(x)));
    } on DioError catch (e) {
      await handleError(e);
    }
    return null;
  }

  Future<List<TxOther>?> getTransactionsOtherNetwork({
    required NetworkName network,
    required String userAddress,
    int page = 0,
    int offset = 0,
  }) async {
    try {
      final key = Web3Utils.getKeyExplorer(Web3Utils.getNetworkNameForSwitch(network));
      if (key == null) {
        throw ApiException('Invalid key.');
      }
      final response = await _dio.get(
          '${_transactionOtherNetwork(network: Web3Utils.getNetworkNameForSwitch(network))
          }?module=account&action=txList&address=$userAddress&startblock=0&endblock=99999999&page=$page&offset=10'
          '&sort=desc&apiKey=$key');
      if (response.statusCode != 200) {
        throw ApiException('Failed getting txs in ${_network.name}');
      }

      return TxOtherNetworkResponse.fromJson(response.data).result;
    } on DioError catch (_) {
      throw ApiException('Failed getting txs in ${_network.name}');
    }
  }

  Future<double?> getCourseWQT() async {
    try {
      final response = await _dio.get(_courseWQT);

      if (response.statusCode != 200) {
        final message = await getTranslateMessage(
          code: response.data['code'],
          message: response.data['msg'],
        );
        throw ApiException(message);
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

  Future<CurrentCourseTokensResponse?> getCourseTokens() async {
    try {
      final response = await _dio.get(_courseTokens);

      if (response.statusCode != 200) {
        final message = await getTranslateMessage(
          code: response.data['code'],
          message: response.data['msg'],
        );
        throw ApiException(message);
      }

      return CurrentCourseTokensResponse.fromJson(response.data);
    } on DioError catch (_) {
      // print('getCourseTokens | $e\n$trace');
      return null;
    }
  }

  handleError(DioError e, {bool translate = true}) async {
    if (e.response == null) {
      final message = await getTranslateMessage();
      throw ApiException(message);
    } else {
      if (translate) {
        final message = await getTranslateMessage(
          code: e.response!.data['code'],
          message: e.response!.data['msg'],
        );
        throw ApiException(message);
      } else {
        print('ApiException(e.response!.data[' "msg" '])');
        throw ApiException(e.response!.data['msg']);
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

class ApiException implements Exception {
  final String message;

  ApiException([this.message = 'Unknown api error']);

  @override
  String toString() => message;
}
