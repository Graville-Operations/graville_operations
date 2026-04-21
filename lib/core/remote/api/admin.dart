import 'package:graville_operations/core/remote/dto/requests/site_request.dart';
import 'package:graville_operations/core/remote/routes/admin_route.dart';
import 'package:graville_operations/core/utils/http.dart';
import 'package:graville_operations/models/site/site_model.dart';

class AdminApi{

  static Future<ProjectResponse> createProject(CreateProjectRequest request) async {
    var response = await HttpUtil().post(
      AdminRoute.createProject,
      data: request.toJson(),
    );
    return ProjectResponse.fromJson(response);
  }

  static Future<List<SiteModel>> fetchProjects() async {
    var response = await HttpUtil().get(AdminRoute.fetchProjects);
    print(response);
    return (response as List).map((site) => SiteModel.fromJson(site)).toList();
  }


}