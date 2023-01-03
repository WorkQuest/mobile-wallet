import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

class MyHttpClient {
  static final MyHttpClient _instance = MyHttpClient._internal();

  factory MyHttpClient() => _instance;

  MyHttpClient._internal() {
    _setUpDio();
    _setInterceptors();
  }

  Dio dio = Dio();

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
            print("url: ${options.path}");
            print("queryParameters: ${options.queryParameters}");
            print("headers: ${options.headers}");
            print('method: ${options.method}');
            if (options.data != null) print("url ${options.data}");
            print('-------------------------------------------');
            return handler.next(options);
          },
          onResponse: (Response response, handler) {
            print('\n---------------- Response ----------------');
            print("response: ${response.data}");
            print("path: ${response.requestOptions.path}");
            print("method: ${response.requestOptions.method}");
            print("headers: ${response.requestOptions.headers}");
            try {
              if (response.statusCode == 200) {
                print('response.status - Success');
              } else {
                print('response.status - Failed');
              }
            } catch (e) {
              // print('onResponse e -> $e, trace -> $trace');
            }
            print('-------------------------------------------');
            handler.next(response);
          },
          onError: (DioError e, handler) {
            print('\n---------------- DioError ----------------');
            print("method ${e.requestOptions.method} ${e.toString()}");
            print("url ${e.requestOptions.path} ${e.toString()}");
            print("message ${e.type} ${e.message}");
            print("response ${e.type} ${e.response}");
            print('-------------------------------------------');
            return handler.next(e);
          },
        ),
      );
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    } catch (e) {
      // print('_setInterceptors e -> $e, trace -> $trace');
    }
  }
}
