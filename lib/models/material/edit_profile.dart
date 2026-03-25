class EditProfileScreen {
  final int userId;
  final String firstName;
  final String lastName;
  final String email;

  EditProfileScreen({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory EditProfileScreen.fromJson(Map<String, dynamic> json) {
    return EditProfileScreen(
      userId: json['userId'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }
}
