import 'package:flutter/material.dart';
import 'package:graville_operations/core/local/store/user_store.dart';
import 'package:graville_operations/models/auth/user.dart';
import 'package:graville_operations/models/personal_settings.dart';
import 'package:graville_operations/screens/commons/widgets/custom_dropdown.dart';
import 'package:graville_operations/screens/settings/edit_profile_screen.dart';
import 'package:graville_operations/screens/support/support_screen.dart';
import 'package:graville_operations/services/profile_api_service.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _service = ProfileApiService();

  User? _user;
  PersonalSettings? _settings;
  String? _error;
  bool _loading = true;

  String _selectedLanguage = 'en';
  String _selectedTheme = 'system';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final userId = UserStore.to.userId;
      print('DEBUG: userId = $userId'); // 👈 add this
      final user = await _service.getProfile(userId);
      print('DEBUG: user loaded = ${user.fullName}'); // 👈 add this
      setState(() {
        _user = user;
        _selectedLanguage = _settings?.language ?? 'en';
        _selectedTheme = _settings?.theme ?? 'system';
        _loading = false;
      });
    } catch (e) {
      print('DEBUG: error loading profile = $e'); // 👈 add this
      setState(() {
        _error = 'Failed to load profile';
        _loading = false;
      });
    }
  }

  Future<void> _saveSettings() async {
    try {
      final userId = UserStore.to.userId;
      await _service.updatePersonalSettings(userId, {
        'language': _selectedLanguage,
        'theme': _selectedTheme,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings saved')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save settings')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account',
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF5F5F7),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _ProfileCard(user: _user, error: _error),
                  const SizedBox(height: 24),
                  _SectionCard(
                    title: 'Account',
                    items: [
                      _AccountItem(
                        icon: Icons.edit,
                        title: 'Edit Profile',
                        onTap: () async {
                          if (_user == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Profile not loaded yet — please wait')),
                            );
                            return;
                          }
                          final updated = await Navigator.push<User>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditProfileScreen(user: _user!),
                            ),
                          );
                          if (updated != null) {
                            setState(() => _user = updated);
                          }
                        },
                      ),
                      _AccountItem(icon: Icons.security, title: 'Security'),
                      _AccountItem(
                          icon: Icons.notifications_none,
                          title: 'Notifications'),
                      _AccountItem(icon: Icons.lock_outline, title: 'Privacy'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: 'Preferences',
                    items: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: CustomDropdown<String>(
                          label: 'Language',
                          items: const ['en', 'sw'],
                          value: _selectedLanguage,
                          displayMapper: (v) =>
                              v == 'sw' ? 'Swahili' : 'English',
                          prefixIcon: const Icon(Icons.language),
                          onChanged: (v) {
                            setState(() => _selectedLanguage = v ?? 'en');
                            _saveSettings();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: CustomDropdown<String>(
                          label: 'Theme',
                          items: const ['light', 'dark', 'system'],
                          value: _selectedTheme,
                          displayMapper: (v) => v,
                          prefixIcon: const Icon(Icons.dark_mode_outlined),
                          onChanged: (v) {
                            setState(() => _selectedTheme = v ?? 'system');
                            _saveSettings();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: 'Support & About',
                    items: [
                      _AccountItem(
                        icon: Icons.support_agent,
                        title: 'Help & Support',
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SupportScreen())),
                      ),
                      _AccountItem(
                          icon: Icons.description, title: 'Terms & Policies'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: 'Actions',
                    items: [
                      _AccountItem(
                          icon: Icons.flag_outlined, title: 'Report a problem'),
                      _AccountItem(
                          icon: Icons.person_add_alt_1, title: 'Add account'),
                      _AccountItem(
                          icon: Icons.language, title: 'Visit our website'),
                      _AccountItem(
                        icon: Icons.logout,
                        title: 'Log out',
                        onTap: _showLogoutDialog,
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // UserStore.to.onLogout();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ✅ Fixed: displays photo, full name, email AND phone number
class _ProfileCard extends StatelessWidget {
  final User? user;
  final String? error;

  const _ProfileCard({this.user, this.error});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (error != null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.orange[700]),
              const SizedBox(width: 12),
              Expanded(child: Text(error!, style: theme.textTheme.bodyMedium)),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // ✅ Photo: shows network image if available, else initials
            CircleAvatar(
              radius: 32,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              backgroundImage: user?.profilePicture != null
                  ? NetworkImage(user!.profilePicture!)
                  : null,
              child: user?.profilePicture == null
                  ? Text(
                      user?.initials ?? '?',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Full name
                  Text(
                    user?.fullName ?? 'Guest User',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // ✅ Email
                  Text(
                    user?.email ?? '',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 2),
                  // ✅ Phone number — always shown (non-nullable in User model)
                  Text(
                    user?.phoneNo ?? '',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const _SectionCard({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            ...items,
          ],
        ),
      ),
    );
  }
}

class _AccountItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const _AccountItem({
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, size: 20),
          ],
        ),
      ),
    );
  }
}
