
import 'package:graville_operations/core/remote/dto/requests/site_request.dart';
import 'package:graville_operations/core/remote/routes/site_route.dart';
import 'package:graville_operations/core/utils/http.dart';


class ProjectApi{
  static Future<ProjectResponse> createSite(CreateProjectRequest request)async{
    var response = await HttpUtil().post(SiteRoute.createSite,data: request.toJson());
    return ProjectResponse.fromJson(response);
  }
}