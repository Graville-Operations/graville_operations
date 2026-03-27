
class MenuItem{
  final int id;
  final String name;
  final String title;
  final String? link;
  final String? icon;
  final int priority;
  final List<SubMenu> subMenus;

  const MenuItem({
    required this.id,
    required this.name,
    required this.title,
    this.link,
    this.icon,
    required this.priority,
    this.subMenus = const [],
  });
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as int,
      name: json['name'] as String,
      title: json['title'] as String,
      link: json['link'] as String?,
      icon: json['icon'] as String?,
      priority: json['priority'] as int,
      subMenus: (json['sub_menus'] as List<dynamic>?)
          ?.map((e) => SubMenu.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'link': link,
      'icon': icon,
      'priority': priority,
      'sub_menus': subMenus.map((e) => e.toJson()).toList(),
    };
  }
}


class SubMenu {
  final int id;
  final String name;
  final String title;
  final String? link;
  final String? icon;
  final int priority;

  const SubMenu({
    required this.id,
    required this.name,
    required this.title,
    this.link,
    this.icon,
    required this.priority,
  });
  factory SubMenu.fromJson(Map<String, dynamic> json) {
    return SubMenu(
      id: json['id'] as int,
      name: json['name'] as String,
      title: json['title'] as String,
      link: json['link'] as String?,
      icon: json['icon'] as String?,
      priority: json['priority'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'link': link,
      'icon': icon,
      'priority': priority,
    };
  }
}