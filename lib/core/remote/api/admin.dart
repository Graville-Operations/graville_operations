import 'package:graville_operations/core/remote/dto/requests/site_request.dart';
import 'package:graville_operations/core/remote/routes/admin_route.dart';
import 'package:graville_operations/core/utils/http.dart';

class AdminApi{

  static Future<ProjectResponse> createProject(CreateProjectRequest request) async {
    var response = await HttpUtil().post(
      AdminRoute.createProject,
      data: request.toJson(),
    );
    return ProjectResponse.fromJson(response);
  }

}