import 'dart:async';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide FormData;
import 'package:graville_operations/core/local/store/user_store.dart';
import 'package:graville_operations/core/utils/utils.dart';
import 'package:flutter/foundation.dart';

/*
  * http operation class
  *
  * Manual
  * https://github.com/cfug/dio/blob/main/dio/README.md
*/
class HttpUtil {
  static final HttpUtil _instance = HttpUtil._internal();
  factory HttpUtil() => _instance;

  late Dio dio;
  CancelToken cancelToken = CancelToken();

  HttpUtil._internal() {
    // BaseOptions、Options、RequestOptions Parameters can be configured, the priorities increase in order, and parameters can be overridden according to the priority.

    BaseOptions options = BaseOptions(
      // Request base address, can include sub-paths
      baseUrl: appBaseUrl,

      // baseUrl: storage.read(key: STORAGE_KEY_APIURL) ?? SERVICE_API_BASEURL,
      //Connection server timeout, unit is milliseconds.
      connectTimeout: const Duration(milliseconds: 30000),

      // The interval between two received data on the response stream, in milliseconds。
      receiveTimeout: const Duration(milliseconds: 60000),

      // Http request header.
      headers: {},

      /// Content-Type of the request, the default value is "application/json; charset=utf-8".
      /// If you want to encode request data in "application/x-www-form-urlencoded" format,
      /// You can set this option to `Headers.formUrlEncodedContentType`, so [Dio]
      /// The request body will be automatically encoded.
      contentType: 'application/json; charset=utf-8',

      /// [responseType] indicates the format (method) in which response data is expected to be received.
      /// Currently [ResponseType] accepts three types: `JSON`, `STREAM`, `PLAIN`.
      ///
      /// The default value is `JSON`. When the content-type in the response header is "application/json", dio will automatically convert the response content into a json object.
      /// If you want to receive the response data in binary form, such as downloading a binary file, you can use `STREAM`.
      ///
      /// If you want to receive response data in text (string) format, use `PLAIN`.
      responseType: ResponseType.json,
    );

    dio = Dio(options);

    // Cookie management
    CookieJar cookieJar = CookieJar();
    // if (!kIsWeb) {
      dio.interceptors.add(CookieManager(cookieJar));
    // }

    //Add interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Do something before request is sent
        if (Get.isRegistered<UserStore>() && UserStore.to.hasToken) {
          final token = UserStore.to.token;
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options); //continue
        // If you want to complete the request and return some custom data, you can resolve a Response object `handler.resolve(response)`.
        // In this way, the request will be terminated, the upper-level then will be called, and the data returned in then will be your custom response.
        //
        // If you want to terminate the request and trigger an error, you can return a `DioError` object, such as `handler.reject(error)`,
        // In this way, the request will be aborted and an exception will be triggered, and the upper layer catchError will be called.
      },
      onResponse: (response, handler) {
        // Do something with response data
        return handler.next(response); // continue
        // If you want to terminate the request and trigger an error, you can reject a `DioError` object, such as `handler.reject(error)`,
        // In this way, the request will be aborted and an exception will be triggered, and the upper layer catchError will be called.
      },
      onError: (DioException e, handler) {
        // Do something with response error
        // Loading.dismiss();
        ErrorEntity eInfo = createErrorEntity(e);
        onError(eInfo);
        return handler.next(e); //continue
        // If you want to complete the request and return some custom data, you can resolve a `Response`, such as `handler.resolve(response)`.
        // In this way, the request will be terminated, the upper layer then will be called, and the data returned in then will be your custom response.
      },
    ));
  }

  /*
   * Unified processing of errors
   */

  // error handling
  void onError(ErrorEntity eInfo) {
    print('error.code -> ${eInfo.code}, error.message -> ${eInfo.message}');

    // EasyLoading.init();
    switch (eInfo.code) {
      case 401:
        // UserStore.to.onLogout();
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
            // String errMsg = error.response.statusMessage;
            // return ErrorEntity(code: errCode, message: errMsg);
            switch (errCode) {
              case 400:
                return ErrorEntity(
                    code: errCode, message: "Request syntax error");
              case 401:
                return ErrorEntity(code: errCode, message: "permission denied");
              case 403:
                return ErrorEntity(
                    code: errCode, message: "Server refuses to execute");
              case 404:
                return ErrorEntity(
                    code: errCode, message: "can not reach server");
              case 405:
                return ErrorEntity(
                    code: errCode, message: "Request method is forbidden");
              case 500:
                return ErrorEntity(
                    code: errCode, message: "Server internal error");
              case 502:
                return ErrorEntity(code: errCode, message: "Invalid request");
              case 503:
                return ErrorEntity(
                    code: errCode, message: "The server is down");
              case 505:
                return ErrorEntity(
                    code: errCode,
                    message: "HTTP protocol requests are not supported");
              default:
                {
                  // return ErrorEntity(code: errCode, message: "unknown mistake");
                  return ErrorEntity(
                    code: errCode,
                    message: error.response != null
                        ? error.response!.statusMessage!
                        : "",
                  );
                }
            }
          } on Exception catch (_) {
            return ErrorEntity(code: -1, message: "unknown mistake");
          }
        }
      default:
        {
          return ErrorEntity(code: -1, message: error.message!);
        }
    }
  }

/*
    * Cancel request
    *
    * The same cancel token can be used for multiple requests. When a cancel token is canceled, all requests using this cancel token will be cancelled.
    * So the parameters are optional
    */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }

  /// restful get operation
  /// refresh whether to pull down to refresh, default false
  /// noCache Whether not to cache, default true
  /// Is list a list? Default false
  /// cacheKey cache key
  /// cacheDisk whether disk cache
  Future get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool refresh = false,
    // bool noCache = !CACHE_ENABLE,
    bool list = false,
    String cacheKey = '',
    bool cacheDisk = false,
  }) async {
    Options requestOptions = options ?? Options();
    if (requestOptions.extra == null) {
      requestOptions.extra = Map();
    }
    requestOptions.extra!.addAll({
      "refresh": refresh,
      // "noCache": noCache,
      "list": list,
      "cacheKey": cacheKey,
      "cacheDisk": cacheDisk,
    });
    requestOptions.headers = requestOptions.headers ?? {};
    var response = await dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful post operation
  Future post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    var response = await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful put operation
  Future put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    var response = await dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful patch operation
  Future patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    var response = await dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful delete operation
  Future delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    var response = await dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful post form form submission operation
  Future postForm(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    var response = await dio.post(
      path,
      data: FormData.fromMap(data),
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful post Stream  data
  Future postStream(
    String path, {
    dynamic data,
    int dataLength = 0,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    requestOptions.headers!.addAll({
      Headers.contentLengthHeader: dataLength.toString(),
    });
    var response = await dio.post(
      path,
      data: Stream.fromIterable(data.map((e) => [e])),
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }
}

// exception handling
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
