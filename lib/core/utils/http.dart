import 'dart:async';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide FormData;
import 'package:graville_operations/core/local/store/user_store.dart';
import 'package:graville_operations/core/utils/utils.dart';

class HttpUtil {
  static final HttpUtil _instance = HttpUtil._internal();
  factory HttpUtil() => _instance;

  late Dio dio;
  CancelToken cancelToken = CancelToken();

  HttpUtil._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: appBaseUrl,
      connectTimeout: const Duration(milliseconds: 30000),
      receiveTimeout: const Duration(milliseconds: 20000),
      headers: {},
      contentType: 'application/json; charset=utf-8',
      responseType: ResponseType.json,
    );

    dio = Dio(options);

    // ← Only add CookieManager on non-web platforms
    if (!kIsWeb) {
      CookieJar cookieJar = CookieJar();
      dio.interceptors.add(CookieManager(cookieJar));
    }

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (Get.isRegistered<UserStore>() && UserStore.to.hasToken) {
          final token = UserStore.to.token;
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        ErrorEntity eInfo = createErrorEntity(e);
        onError(eInfo);
        return handler.next(e);
      },
    ));
  }

  void onError(ErrorEntity eInfo) {
    print('error.code -> ${eInfo.code}, error.message -> ${eInfo.message}');
    switch (eInfo.code) {
      case 401:
        EasyLoading.showError(eInfo.message);
        break;
      default:
        EasyLoading.showError('unknown error');
        break;
    }
  }

  ErrorEntity createErrorEntity(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        return ErrorEntity(code: -1, message: "Request cancellation");
      case DioExceptionType.connectionTimeout:
        return ErrorEntity(code: -1, message: "Connection timed out");
      case DioExceptionType.sendTimeout:
        return ErrorEntity(code: -1, message: "Request timed out");
      case DioExceptionType.receiveTimeout:
        return ErrorEntity(code: -1, message: "Response timeout");
      case DioExceptionType.badCertificate:
        return ErrorEntity(code: -1, message: "Bad Certificate");
      case DioExceptionType.badResponse:
        {
          try {
            int errCode =
                error.response != null ? error.response!.statusCode! : -1;
            switch (errCode) {
              case 400:
                return ErrorEntity(code: errCode, message: "Request syntax error");
              case 401:
                return ErrorEntity(code: errCode, message: "Permission denied");
              case 403:
                return ErrorEntity(code: errCode, message: "Server refuses to execute");
              case 404:
                return ErrorEntity(code: errCode, message: "Cannot reach server");
              case 405:
                return ErrorEntity(code: errCode, message: "Request method is forbidden");
              case 500:
                return ErrorEntity(code: errCode, message: "Server internal error");
              case 502:
                return ErrorEntity(code: errCode, message: "Invalid request");
              case 503:
                return ErrorEntity(code: errCode, message: "The server is down");
              case 505:
                return ErrorEntity(code: errCode, message: "HTTP protocol not supported");
              default:
                return ErrorEntity(
                  code: errCode,
                  message: error.response != null
                      ? error.response!.statusMessage!
                      : "",
                );
            }
          } on Exception catch (_) {
            return ErrorEntity(code: -1, message: "Unknown mistake");
          }
        }
      default:
        return ErrorEntity(code: -1, message: error.message ?? "Unknown error");
    }
  }

  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }

  Future get(String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool refresh = false,
    bool list = false,
    String cacheKey = '',
    bool cacheDisk = false,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.extra ??= {};
    requestOptions.extra!.addAll({
      "refresh": refresh,
      "list": list,
      "cacheKey": cacheKey,
      "cacheDisk": cacheDisk,
    });
    var response = await dio.get(
      path,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  Future post(String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers ??= {};
    var response = await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  Future put(String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers ??= {};
    var response = await dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  Future patch(String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers ??= {};
    var response = await dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  Future delete(String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers ??= {};
    var response = await dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  Future postForm(String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers ??= {};
    var response = await dio.post(
      path,
      data: FormData.fromMap(data),
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }
}

class ErrorEntity implements Exception {
  int code = -1;
  String message = "";
  ErrorEntity({required this.code, required this.message});

  @override
  String toString() {
    if (message == "") return "Exception";
    return "Exception: code $code, $message";
  }
}