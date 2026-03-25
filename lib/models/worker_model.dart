class Worker {
  final int? id;
  final String firstName;
  final String lastName;
  final int nationalId;
  final String skillType;
  final String phoneNumber;
  final double amount;
  final String? imageUrl;
  final String? site;
  final int? taskId;
  final int? siteId;
  final DateTime? createdAt;

  Worker({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.nationalId,
    required this.skillType,
    required this.phoneNumber,
    required this.amount,
    this.imageUrl,
    this.site,
    this.taskId,
    this.siteId,
    this.createdAt,
  });
  
  String get fullName => '$firstName $lastName';

  Map<String, dynamic> toCreateJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'national_id': nationalId,
      'skill_type': skillType,
      'joined_date': DateTime.now().toIso8601String().split('T').first,
      'phone': phoneNumber,
      'amount': amount,
      if (imageUrl != null) 'image_url': imageUrl,
      if (site != null) 'site': site,
      if (taskId != null) 'task_id': taskId,
      //if (siteId != null) 'site_id': siteId,
    };
  }
  
  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      nationalId: json['national_id'] ?? 0,
      skillType: json['skill_type'] ?? '',
      phoneNumber: json['phone'] ?? '',
      amount: 0.0, 
      imageUrl: json['image_url'],
      site: json['site'],
      taskId: json['task_id'],
      siteId: json['site_id'],
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
    );
  }


}