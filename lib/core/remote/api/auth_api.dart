
import 'package:graville_operations/core/remote/dto/requests/create_user.dart';
import 'package:graville_operations/core/remote/dto/requests/login.dart';
import 'package:graville_operations/core/remote/dto/response/auth_response.dart';
import 'package:graville_operations/core/remote/dto/response/base_response.dart';
import 'package:graville_operations/core/remote/routes/auth_route.dart';
import 'package:graville_operations/core/utils/http.dart';

class AuthApi{

  // static Future<BaseResponse<AuthLoginResponse>> login(LoginRequest request)async{
  //   var response = await HttpUtil().post(
  //       AuthRoute.login,
  //       data: request.toJson()
  //   );
  //   return BaseResponse.fromJson(
  //     response,
  //         (json) => AuthLoginResponse.fromJson(json), // 👈 deserializer for T
  //   );
  // }

  static Future<AuthLoginResponse> login(LoginRequest request)async{
    var response = await HttpUtil().post(
      AuthRoute.login,
      data: request.toJson()
    );
    return AuthLoginResponse.fromJson(response);
  }
  static Future<BaseResponse> logout()async{
    var response = await HttpUtil().post(
        AuthRoute.logout
    );
    return BaseResponse.fromJson(response, null);
  }

  static Future<BaseResponse> createUser(CreateUserRequest request)async{
    var response = await HttpUtil().post(
        AuthRoute.createUser,
        data: request.toJson()
    );
    return BaseResponse.fromJson(response, null);
  }

  static Future<BaseResponse> deleteAccount()async{
    var response = await HttpUtil().delete(AuthRoute.deleteAccount);
    return BaseResponse.fromJson(response, null);
  }

  static Future<MyAccountResponse> me()async{ // getting personal info
    var response = await HttpUtil().get(AuthRoute.myAccount);
    return MyAccountResponse.fromJson(response);
  }
}