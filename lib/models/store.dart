
class Tool {
  final int id;
  final String name;
  final String description;

  Tool({required this.id, required this.name, required this.description});

  factory Tool.fromJson(Map<String, dynamic> json) => Tool(
    id: json['id'],
    name: json['name'],
    description: json['description'],
  );
}