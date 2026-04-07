// import 'package:json_annotation/json_annotation.dart';

// @JsonSerializable()
// class UserProfile {
//   final int id;
//   final String email;
//   @JsonKey(name: 'first_name')
//   final String? firstName;
//   @JsonKey(name: 'last_name')
//   final String? lastName;
//   @JsonKey(name: 'phone_number')
//   final String? phoneNumber;
//   @JsonKey(name: 'profile_picture')
//   final String? profilePicture;
//   final String role;
//   @JsonKey(name: 'is_active')
//   final bool isActive;
//   @JsonKey(name: 'created_at')
//   final DateTime? createdAt;
//   @JsonKey(name: 'updated_at')
//   final DateTime? updatedAt;

//   UserProfile({
//     required this.id,
//     required this.email,
//     this.firstName,
//     this.lastName,
//     this.phoneNumber,
//     this.profilePicture,
//     required this.role,
//     required this.isActive,
//     this.createdAt,
//     this.updatedAt,
//   });

//   String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
//   String get initials =>
//       '${firstName?.substring(0, 1) ?? ''}${lastName?.substring(0, 1) ?? ''}'
//           .toUpperCase();

//   factory UserProfile.fromJson(Map<String, dynamic> json) =>
//       _$UserProfileFromJson(json);
//   Map<String, dynamic> toJson() => _$UserProfileToJson(this);
// }
// // GENERATED CODE - DO NOT MODIFY BY HAND

// // **************************************************************************
// // JsonSerializableGenerator
// // **************************************************************************

// UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
//       id: (json['id'] as num).toInt(),
//       email: json['email'] as String,
//       firstName: json['first_name'] as String?,
//       lastName: json['last_name'] as String?,
//       phoneNumber: json['phone_number'] as String?,
//       profilePicture: json['profile_picture'] as String?,
//       role: json['role'] as String,
//       isActive: json['is_active'] as bool,
//       createdAt: json['created_at'] == null
//           ? null
//           : DateTime.parse(json['created_at'] as String),
//       updatedAt: json['updated_at'] == null
//           ? null
//           : DateTime.parse(json['updated_at'] as String),
//     );

// Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
//     <String, dynamic>{
//       'id': instance.id,
//       'email': instance.email,
//       'first_name': instance.firstName,
//       'last_name': instance.lastName,
//       'phone_number': instance.phoneNumber,
//       'profile_picture': instance.profilePicture,
//       'role': instance.role,
//       'is_active': instance.isActive,
//       'created_at': instance.createdAt?.toIso8601String(),
//       'updated_at': instance.updatedAt?.toIso8601String(),
//     };
