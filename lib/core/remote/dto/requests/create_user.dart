
class CreateUserRequest {
  final String email;
  final String phoneNo;
  final String firstName;
  final String middleName;
  final String lastName;
  final String nationalId;
  final String accountType;
  final String? gender;
  final String? company;
  final String? staffId;
  final String? longitude;
  final String? latitude;
  final String? password;

  CreateUserRequest({
    required this.email,
    required this.phoneNo,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.nationalId,
    required this.accountType,
    this.gender,
    this.company,
    this.staffId,
    this.longitude,
    this.latitude,
    this.password,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      "email": email,
      "phone_no": phoneNo,
      "first_name": firstName,
      "middle_name": middleName,
      "last_name": lastName,
      "national_id": nationalId,
      "account_type": accountType,
    };
    if (gender != null) map["gender"] = gender;
    if (company != null) map["company"] = company;
    if (staffId != null) map["staff_id"] = staffId;
    if (longitude != null) map["longitude"] = longitude;
    if (latitude != null) map["latitude"] = latitude;
    if (password != null) map["password"] = password;

    return map;
  }
}