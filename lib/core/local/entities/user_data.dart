
import 'package:graville_operations/core/local/entities/group_data.dart';

class UserData{
  int? id;
  String? refId;
  String? nationalId;
  String? email;
  String? phoneNo;
  String? firstName;
  String? middleName;
  String? lastName;
  String? accountType;
  String? accountStatus;
  String? gender;
  String? createdBy;
  String? modifiedBy;
  String? createdAt;
  String? updatedAt;
  bool? emailVerified;
  bool? phoneVerified;
  bool? kycComplete;
  bool? enabled;
  String? company;
  String? staffId;
  String? longitude;
  String? latitude;
  List<GroupData>? groups;

  UserData({
    this.id,
    this.refId,
    this.nationalId,
    this.email,
    this.phoneNo,
    this.firstName,
    this.middleName,
    this.lastName,
    this.accountType,
    this.accountStatus,
    this.gender,
    this.createdBy,
    this.modifiedBy,
    this.createdAt,
    this.updatedAt,
    this.emailVerified,
    this.phoneVerified,
    this.kycComplete,
    this.enabled,
    this.groups,
    this.company,
    this.staffId,
    this.longitude,
    this.latitude,
  });



  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
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
          .map((group) => GroupData.fromJson(group))
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
    "groups": groups?.map((g) => g.toJson()).toList(),
    "company": company,
    "staff_id": staffId,
    "longitude": longitude,
    "latitude": latitude,
  };
  String get fullName => "$firstName $middleName $lastName";
}