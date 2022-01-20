import 'package:dio/dio.dart';
import 'package:workquest_wallet_app/http/http_client.dart';
import 'package:workquest_wallet_app/model/transactions_response.dart';

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

  final _dio = HttpClient().dio;

  Future<Response?> register(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    final response = await _dio.post(
      _register,
      data: {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
      },
    ).catchError((e) {
      if (e is DioError) {
        return e.response;
      } else {
        throw e;
      }
    });

    if (response.statusCode != 200) {
      throw FormatException(response.data['msg']);
    }

    HttpClient().setAccessToken = response.data['result']['access'];

    return response;
  }

  Future<bool> registerWallet(String publicKey, String address) async {
    final response = await _dio.post(
      _registerWallet,
      data: {
        "publicKey": publicKey,
        "address": address,
      },
    ).catchError((e) {
      if (e is DioError) {
        return e.response;
      } else {
        throw e;
      }
    });

    if (response.statusCode != 200) {
      throw FormatException(response.data['msg']);
    }

    return response.data['ok'];
  }

  Future<String> refreshToken(String refreshToken) async {
    _dio.options.headers["authorization"] = 'bearer $refreshToken';

    final response = await _dio.post(_refreshTokens).catchError((e) {
      if (e is DioError) {
        return e.response;
      } else {
        throw e;
      }
    });

    if (response.statusCode != 200) {
      throw FormatException(response.data['msg']);
    }

    HttpClient().accessToken = response.data['result']['access'];

    return response.data['result']['refresh'];
  }

  Future<bool> confirmEmail(String code) async {
    final response = await _dio.post(_confirmEmail,
        data: {"confirmCode": code, "role": "worker"}).catchError((e) {
      if (e is DioError) {
        return e.response;
      } else {
        throw e;
      }
    });

    if (response.statusCode != 200) {
      throw FormatException(response.data['msg']);
    }

    return response.data['ok'];
  }

  Future<Response?> login(String signature, String address) async {
    final response = await _dio.post(
      _login,
      data: {
        "signature": signature,
        "address": address,
      },
    ).catchError((e) {
      if (e is DioError) {
        return e.response;
      } else {
        throw e;
      }
    });

    if (response.statusCode != 200) {
      throw FormatException(response.data['msg']);
    }

    HttpClient().setAccessToken = response.data['result']['access'];

    return response;
  }

  Future<List<Tx>> getTransactions(String address,
      {int limit = 10, int offset = 0}) async {
    final response = await _dio
        .get(
      '${_transactions(address)}?limit=$limit&offset=$offset',
    ).catchError((e) {
        if (e is DioError) {
          return e.response;
        } else {
          throw e;
        }
      },
    );

    if (response.statusCode != 200) {
      throw FormatException(response.data['msg']);
    }

    return TransactionsResponse.fromJson(response.data!).result!.txs!;
  }

//https://dev-explorer.workquest.co/api/v1/account/0xcb28c869cc6cc6b7408627a45b0dac326aaec630/txs?limit=10&offset=0
//https://dev-explorer.workquest.co/api/v1/account/0xcb28c869cc6cc6b7408627a45b0dac326aaec630/txs?limit=10&offset=0
}
