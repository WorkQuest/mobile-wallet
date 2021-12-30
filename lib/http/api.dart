import 'package:dio/dio.dart';
import 'package:workquest_wallet_app/http/http_client.dart';

class Api {
  static const baseUrl = isRelease
      ? "https://app.workquest.co/api/v1"
      : "https://app-ver1.workquest.co/api/v1";

  static const isRelease = true;

  static const _register = "$baseUrl/auth/register";
  static const _registerWallet = "$baseUrl/auth/register/wallet";
  static const _refreshTokens = "$baseUrl/auth/refresh-tokens";
  static const _login = "$baseUrl/auth/login/wallet";

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

    final response = await _dio.post(_refreshTokens);

    if (response.statusCode != 200) {
      throw Exception("Server error");
    }

    HttpClient().accessToken = response.data['result']['access'];

    return response.data['result']['refresh'];
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
}
