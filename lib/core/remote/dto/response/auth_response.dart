import 'package:graville_operations/core/local/entities/group_data.dart';
import 'package:graville_operations/core/local/entities/user_data.dart';
import 'package:graville_operations/core/remote/dto/response/group_response.dart';

class AuthLoginResponse {
  final String accessToken;
  final String tokenType;
  final String sessionId;
  final String accountType;
  final int expiresIn;
  final int? userId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNo;
  final String? role;

  AuthLoginResponse({
    required this.accessToken,
    required this.tokenType,
    required this.sessionId,
    required this.accountType,
    required this.expiresIn,
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNo,
    this.role,
  });

  factory AuthLoginResponse.fromJson(Map<String, dynamic> json) {
    final user = json["user"] as Map<String, dynamic>?; // ← this was missing
    return AuthLoginResponse(
      accessToken: json["access_token"],
      tokenType: json["token_type"],
      sessionId: json["session_id"] ?? '',
      accountType: json["account_type"] ?? '',
      expiresIn: json["expires_in"] ?? 0,
      userId: user?["id"],
      firstName: user?["first_name"],
      lastName: user?["last_name"],
      email: user?["email"],
      phoneNo: user?["phone_no"],
      role: user?["role"] ?? json["role"],
    );
  }

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "session_id": sessionId,
        "account_type": accountType,
        "expires_in": expiresIn,
      };
}

class MyAccountResponse {
  final int id;
  final String refId;
  final String nationalId;
  final String email;
  final String phoneNo;
  final String firstName;
  final String middleName;
  final String lastName;
  final String accountType;
  final String accountStatus;
  final String gender;
  final String createdBy;
  final String modifiedBy;
  final String createdAt;
  final String updatedAt;
  final bool emailVerified;
  final bool phoneVerified;
  final bool kycComplete;
  final bool enabled;
  final String? company;
  final String? staffId;
  final String? longitude;
  final String? latitude;
  final List<GroupResponse> groups;

  MyAccountResponse({
    required this.id,
    required this.refId,
    required this.nationalId,
    required this.email,
    required this.phoneNo,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.accountType,
    required this.accountStatus,
    required this.gender,
    required this.createdBy,
    required this.modifiedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.emailVerified,
    required this.phoneVerified,
    required this.kycComplete,
    required this.enabled,
    required this.groups,
    this.company,
    this.staffId,
    this.longitude,
    this.latitude,
  });

  factory MyAccountResponse.fromJson(Map<String, dynamic> json) {
    return MyAccountResponse(
      id: json["id"],
      refId: json["ref_id"],
      nationalId: json["national_id"],
      email: json["email"],
      phoneNo: json["phone_no"],
      firstName: json["first_name"],
      middleName: json["middle_name"],
      lastName: json["last_name"],
      accountType: json["account_type"],
      accountStatus: json["account_status"],
      gender: json["gender"],
      createdBy: json["created_by"],
      modifiedBy: json["modified_by"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      emailVerified: json["email_verified"],
      phoneVerified: json["phone_verified"],
      kycComplete: json["kyc_complete"],
      enabled: json["enabled"],
      groups: (json["groups"] as List<dynamic>)
          .map((group) => GroupResponse.fromJson(group))
          .toList(),
      company: json["company"],
      staffId: json["staff_id"],
      longitude: json["longitude"],
      latitude: json["latitude"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "ref_id": refId,
        "national_id": nationalId,
        "email": email,
        "phone_no": phoneNo,
        "first_name": firstName,
        "middle_name": middleName,
        "last_name": lastName,
        "account_type": accountType,
        "account_status": accountStatus,
        "gender": gender,
        "created_by": createdBy,
        "modified_by": modifiedBy,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "email_verified": emailVerified,
        "phone_verified": phoneVerified,
        "kyc_complete": kycComplete,
        "enabled": enabled,
        "groups": groups.map((g) => g.toJson()).toList(),
        "company": company,
        "staff_id": staffId,
        "longitude": longitude,
        "latitude": latitude,
      };

  String get fullName => "$firstName $middleName $lastName";

  UserData toUserData() {
    return UserData(
      id: id,
      refId: refId,
      nationalId: nationalId,
      email: email,
      phoneNo: phoneNo,
      firstName: firstName,
      middleName: middleName,
      lastName: lastName,
      accountType: accountType,
      accountStatus: accountStatus,
      gender: gender,
      createdBy: createdBy,
      modifiedBy: modifiedBy,
      createdAt: createdAt,
      updatedAt: updatedAt,
      emailVerified: emailVerified,
      phoneVerified: phoneVerified,
      kycComplete: kycComplete,
      enabled: enabled,
      company: company,
      staffId: staffId,
      longitude: longitude,
      latitude: latitude,
      groups: groups
          .map(
            (g) => GroupData(
              id: g.id,
              description: g.description,
              createdAt: g.createdAt,
              title: g.title,
              refId: g.refId,
              modifiedBy: g.modifiedBy,
              updatedAt: g.updatedAt,
            ),
          )
          .toList(),
    );
  }
}
