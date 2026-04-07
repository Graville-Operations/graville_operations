class Worker {
  final int id;
  final String firstName;
  final String lastName;

  Worker({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
    );
  }

  String get fullName => '$firstName $lastName';
}