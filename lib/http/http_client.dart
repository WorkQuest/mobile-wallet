import 'package:dio/dio.dart';
import 'package:workquest_wallet_app/utils/storage.dart';

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();

  factory HttpClient() => _instance;

  HttpClient._internal() {
    _setUpDio();
    _setInterceptors();
  }

  Dio dio = Dio();

  String? accessToken;

  set setAccessToken(String accessToken) => this.accessToken = accessToken;

  void _setUpDio() {
    dio = Dio();
    dio.options.connectTimeout = 60000;
    dio.options.receiveTimeout = 60000;
  }

  void _setInterceptors() {
    try {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (RequestOptions options, handler) {
            print('\n---------------- onRequest ----------------');
            if (accessToken != null) {
              options.headers['authorization'] = "Bearer $accessToken";
            }
            // print("url: ${options.path}");
            // print("queryParameters: ${options.queryParameters}");
            // print("headers: ${options.headers}");
            // print('method: ${options.method}');
            // print("Adding accessToken $accessToken");
            if (options.data != null) print("url ${options.data}");
            print('-------------------------------------------');
            return handler.next(options);
          },
          onResponse: (Response response, handler) {
            print('\n---------------- Response ----------------');
            // print("response: ${response.data}");
            // print("path: ${response.requestOptions.path}");
            // print("method: ${response.requestOptions.method}");
            // print("headers: ${response.requestOptions.headers}");
            try {
              if (response.statusCode == 200) {
                print('response.status - Success');
              } else {
                print('response.status - Failed');
              }
            } catch (e) {}
            print('-------------------------------------------');
            handler.next(response);
          },
          onError: (DioError e, handler) {
            print('\n---------------- DioError ----------------');
            // print("method ${e.requestOptions.method} ${e.toString()}");
            // print("url ${e.requestOptions.path} ${e.toString()}");
            // print("message ${e.type} ${e.message}");
            // print("response ${e.type} ${e.response}");
            print('-------------------------------------------');
            try {
              if (e.response?.data["code"] == 401001) {
                return handleRefreshToken(e);
              }
              if (e.response?.data["code"] == 401002) {
                return handleChangeToken(e);
              }
            } catch (e) {
              print('error $e');
            }
            return handler.next(e);
          },
        ),
      );
    } catch (e, trace) {
      print('_setInterceptors e -> $e, trace -> $trace');
    }
  }

  void handleChangeToken(DioError e) async {
    accessToken = null;
    Storage.delete(Storage.refreshKey);
    return;
  }

  void handleRefreshToken(DioError e) async {
    accessToken = null;
    final refreshToken = await Storage.read(Storage.refreshKey);
    //TODO refresh Token
    // var response = await Api().authRequest.refreshTokens(refreshToken);
    // if (response != null) {
    //   return response;
    // } else {
    //   return e;
    // }
  }
}
