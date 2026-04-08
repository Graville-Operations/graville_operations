class Worker {
  final String name;
  final String id;
  final String skillLevel;
  final String phone;
  final String specialty;
  final String rate;

  Worker({
    required this.name,
    required this.id,
    required this.skillLevel,
    required this.phone,
    required this.specialty,
    required this.rate,
  });

  static Object? fromJson(json) {}
}
