class BaseResponse<T> {
  final String message; //can be an error message if status code is not 201,200,204(success)
  final int code; // status code
  final T? data;

  BaseResponse({
    required this.message,
    required this.code,
    this.data,
  });

  factory BaseResponse.fromJson(
      Map<String, dynamic> json,
      T? Function(dynamic json)? fromJsonT,
      ) {
    return BaseResponse(
      message: json["message"],
      code: json["code"],
      data: json["data"] != null && fromJsonT != null
          ? fromJsonT(json["data"])
          : null,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T)? toJsonT) => {
    "message": message,
    "code": code,
    "data": data != null && toJsonT != null ? toJsonT(data as T) : null,
  };
}