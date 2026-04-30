class Role {
  final int id;
  final String title;
  final String refId;
  final String description;
  final String modifiedBy;
  final String createdAt;
  final String updatedAt;

  Role({
    required this.id,
    required this.title,
    required this.refId,
    required this.description,
    required this.modifiedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json['id'] ?? 0,
        title: json['title'] ?? '',
        refId: json['ref_id'] ?? '',
        description: json['description'] ?? '',
        modifiedBy: json['modified_by'] ?? '',
        createdAt: json['created_at'] ?? '',
        updatedAt: json['updated_at'] ?? '',
      );

  String get readableTitle => title
      .replaceAll('_', ' ')
      .toLowerCase()
      .split(' ')
      .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
      .join(' ');
}

class SubMenu {
  final int id;
  final String name;
  final String title;
  final String? link;
  final String? icon;
  final int priority;

  SubMenu({
    required this.id,
    required this.name,
    required this.title,
    this.link,
    this.icon,
    required this.priority,
  });

  factory SubMenu.fromJson(Map<String, dynamic> json) => SubMenu(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        title: json['title'] ?? '',
        link: json['link'],
        icon: json['icon'],
        priority: json['priority'] ?? 0,
      );
}

class Menu {
  final int id;
  final String name;
  final String title;
  final String? link;
  final String? icon;
  final int priority;
  final List<SubMenu> subMenus;

  Menu({
    required this.id,
    required this.name,
    required this.title,
    this.link,
    this.icon,
    required this.priority,
    this.subMenus = const [],
  });

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        title: json['title'] ?? '',
        link: json['link'],
        icon: json['icon'],
        priority: json['priority'] ?? 0,
        subMenus: (json['sub_menus'] as List<dynamic>? ?? [])
            .map((s) => SubMenu.fromJson(s))
            .toList(),
      );
}

class Group {
  final int id;
  final String description;
  final String createdAt;
  final String title;
  final String refId;
  final String modifiedBy;
  final String updatedAt;
  final List<Role> roles;
  List<Menu> assignedMenus; // mutable so we can update locally after assignment

  Group({
    required this.id,
    required this.description,
    required this.createdAt,
    required this.title,
    required this.refId,
    required this.modifiedBy,
    required this.updatedAt,
    this.roles = const [],
    this.assignedMenus = const [],
  });

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        id: json['id'] ?? 0,
        description: json['description'] ?? '',
        createdAt: json['created_at'] ?? '',
        title: json['title'] ?? '',
        refId: json['ref_id'] ?? '',
        modifiedBy: json['modified_by'] ?? '',
        updatedAt: json['updated_at'] ?? '',
        roles: (json['roles'] as List<dynamic>? ?? [])
            .map((r) => Role.fromJson(r))
            .toList(),
        assignedMenus: (json['menus'] as List<dynamic>? ?? [])
            .map((m) => Menu.fromJson(m))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'created_at': createdAt,
        'title': title,
        'ref_id': refId,
        'modified_by': modifiedBy,
        'updated_at': updatedAt,
      };

  String get readableTitle => title
      .replaceAll('_', ' ')
      .toLowerCase()
      .split(' ')
      .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
      .join(' ');
}
