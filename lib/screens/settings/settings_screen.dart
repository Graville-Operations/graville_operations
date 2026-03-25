import 'package:flutter/material.dart';
//import 'package:graville_operations/models/material/edit_profile.dart';
import 'package:graville_operations/providers/language_provider.dart';
import 'package:graville_operations/providers/theme_provider.dart';
import 'package:graville_operations/screens/commons/widgets/custom_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:graville_operations/screens/settings/edit_profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? selectedLanguage = 'en';
  String? selectedTheme = 'system';

  final List<String> languages = ['en', 'sw'];

  final List<String> themes = ['light', 'dark', 'system'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Account'),
            _settingsCard(
              context,
              items: [
                _item(
                  Icons.person_outline,
                  'Edit profile',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  },
                ),
                _item(Icons.security, 'Security'),
                _item(Icons.notifications_none, 'Notifications'),
                _item(Icons.lock_outline, 'Privacy'),
              ],
            ),

            const SizedBox(height: 20),

            _sectionTitle('Preferences'),
            _settingsCard(
              context,
              items: [
                CustomDropdown<String>(
                  label: 'Language',

                  value: Provider.of<LanguageProvider>(
                    context,
                  ).locale.languageCode,

                  items: const ["en", "sw"],

                  displayMapper: (value) {
                    switch (value) {
                      case "sw":
                        return "Swahili";
                      default:
                        return "English";
                    }
                  },

                  prefixIcon: const Icon(Icons.language),

                  onChanged: (value) {
                    if (value != null) {
                      Provider.of<LanguageProvider>(
                        context,
                        listen: false,
                      ).setLanguage(value);
                    }
                  },
                ),
                CustomDropdown<String>(
                  label: 'Theme',

                  // 🔥 bind to global theme instead of local state
                  value:
                      Provider.of<ThemeProvider>(context).themeMode ==
                          ThemeMode.dark
                      ? "dark"
                      : Provider.of<ThemeProvider>(context).themeMode ==
                            ThemeMode.light
                      ? "light"
                      : "system",

                  items: themes,
                  displayMapper: themeLabel,
                  prefixIcon: const Icon(Icons.dark_mode_outlined),

                  onChanged: (value) {
                    if (value != null) {
                      // 🔥 update GLOBAL theme
                      Provider.of<ThemeProvider>(
                        context,
                        listen: false,
                      ).setTheme(value);

                      // OPTIONAL: keep local state if you still need it
                      setState(() {
                        selectedTheme = value;
                      });
                    }
                  },
                ),

                const SizedBox(height: 20),

                _sectionTitle('Support & About'),
                _settingsCard(
                  context,
                  items: [
                    _item(Icons.help_outline, 'Help & Support'),
                    _item(Icons.info_outline, 'Terms and Policies'),
                  ],
                ),

                const SizedBox(height: 20),

                _sectionTitle('Actions'),
                _settingsCard(
                  context,
                  items: [
                    _item(Icons.flag_outlined, 'Report a problem'),
                    _item(Icons.person_add_alt, 'Add account'),
                    _item(Icons.logout, 'Log out'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _settingsCard(BuildContext context, {required List<Widget> items}) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: item,
          );
        }).toList(),
      ),
    );
  }

  Widget _item(IconData icon, String title, {VoidCallback? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }

  String languageLabel(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'fr':
        return 'French';
      case 'it':
        return 'Italian';
      case 'es':
        return 'Spanish';
      case 'zh':
        return 'Chinese';
      case 'ar':
        return 'Arabic';
      case 'de':
        return 'German';
      case 'ja':
        return 'Japanese';
      default:
        return code;
    }
  }

  String themeLabel(String theme) {
    switch (theme) {
      case 'light':
        return 'Light';
      case 'dark':
        return 'Dark';
      case 'system':
        return 'System';
      default:
        return theme;
    }
  }
}
