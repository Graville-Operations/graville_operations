class PersonalSettings {
  final int? id;
  final String? language;
  final String? theme;

  PersonalSettings({this.id, this.language, this.theme});

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (language != null) 'language': language,
      if (theme != null) 'theme': theme,
    };
  }

  factory PersonalSettings.fromJson(Map<String, dynamic> json) {
    return PersonalSettings(
      id: json['id'],
      language: json['language'],
      theme: json['theme'],
    );
  }
}
