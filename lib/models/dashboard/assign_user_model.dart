import 'dart:ui';

class UserModel {
  final int id;
  final String initials;
  final String firstName;
  final String lastName;
  final String phone;

  const UserModel({
    required this.id,
    required this.initials,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  String get fullName => '$firstName $lastName';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final first = json['first_name']?.toString() ?? '';
    final last = json['last_name']?.toString() ?? '';
    final initials =
        '${first.isNotEmpty ? first[0] : ''}${last.isNotEmpty ? last[0] : ''}'
            .toUpperCase();
    return UserModel(
      id: json['id'] as int,
      firstName: first,
      lastName: last,
      initials: initials,
      phone: json['phone_no']?.toString() ?? '',
    );
  }
}

class GroupModel {
  final int id;
  final String name;
  final String description;
  final List<String> roles;
  final Color color;
  final Color iconColor;

  const GroupModel({
    required this.id,
    required this.name,
    required this.description,
    required this.roles,
    required this.color,
    required this.iconColor,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    const colorPairs = [
      [Color(0xFFB5D4F4), Color(0xFF0C447C)],
      [Color(0xFF9FE1CB), Color(0xFF085041)],
      [Color(0xFFFAC775), Color(0xFF633806)],
      [Color(0xFFF4C0D1), Color(0xFF72243E)],
      [Color(0xFFD3D1C7), Color(0xFF444441)],
    ];
    final idx = ((json['id'] as int? ?? 0) - 1) % colorPairs.length;
    final pair = colorPairs[idx];

    final rawRoles = json['roles'];
    List<String> roleList = [];
    if (rawRoles is List) {
      roleList = rawRoles
          .map((r) {
            if (r is Map<String, dynamic>) {
              return r['name']?.toString() ?? r['title']?.toString() ?? '';
            }

            final str = r.toString();

            final nameMatch = RegExp(r'name:\s*([^,}]+)').firstMatch(str);
            if (nameMatch != null) return nameMatch.group(1)!.trim();

            final titleMatch = RegExp(r'title:\s*([^,}]+)').firstMatch(str);
            if (titleMatch != null) return titleMatch.group(1)!.trim();

            return '';
          })
          .where((e) => e.isNotEmpty)
          .toList();
    }

    return GroupModel(
      id: json['id'] as int,
      name: json['name']?.toString() ??
          json['group_name']?.toString() ??
          json['title']?.toString() ??
          '',
      description: json['description']?.toString() ?? '',
      roles: roleList,
      color: pair[0],
      iconColor: pair[1],
    );
  }
}
