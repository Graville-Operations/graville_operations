import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LanguageProvider() {
    loadLanguage();
  }

  void setLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("language", langCode);

    _locale = Locale(langCode);
    notifyListeners();
  }

  void loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedLang = prefs.getString("language");

    if (savedLang != null) {
      _locale = Locale(savedLang);
      notifyListeners();
    }
  }
}
