import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
        padding: const EdgeInsets.fromLTRB(16, 16, 48, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Account'),
            _settingsCard(
              context,
              items: [
                _item(Icons.person_outline, 'Edit profile'),
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
                _item(Icons.language, 'Language'),
                _item(Icons.dark_mode_outlined, 'Theme'),
              ],
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

  Widget _settingsCard(
    BuildContext context, {
    required List<_SettingsItem> items,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),

      child: Column(
        children: items.map((item) {
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(item.icon, color: Colors.black54),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

_SettingsItem _item(IconData icon, String title) {
  return _SettingsItem(icon: icon, title: title);
}

class _SettingsItem {
  final IconData icon;
  final String title;

  _SettingsItem({required this.icon, required this.title});
}
