import 'package:flutter/material.dart';
import 'package:graville_operations/models/personal_settings.dart';
//import 'package:graville_operations/screens/auth/login/login_screen.dart';
import 'package:graville_operations/screens/auth/login/view.dart';
// import 'package:graville_operations/screens/settings/settings_screen.dart';
import 'package:graville_operations/screens/support/support_screen.dart';
import 'package:graville_operations/services/api_service.dart';
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
  String firstName = '';
  String lastName = '';
  String email = '';
  String role = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    final userId = await ApiService.getUserId();
    if (userId != null) {
      final result = await ApiService.getProfile(userId);
      if (result['success']) {
        setState(() {
          firstName = result['data']['first_name'] ?? '';
          lastName = result['data']['last_name'] ?? '';
          email = result['data']['email'] ?? '';
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } else {
      setState(() => _isLoading = false);
    }

    final savedRole = await ApiService.getRole();
    setState(() {
      role = savedRole ?? '';
    });
  }

  void _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ApiService.clearSession();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile Card
                  _ProfileCard(
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    role: role,
                    onTap: () async {
                      final userId = await ApiService.getUserId();
                      if (userId != null) {
                        // Navigate to edit profile when ready
                        debugPrint('Edit profile tapped for user $userId');
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Account Items
                  Card(
                    child: Column(
                      children: List.generate(
                        _accountItems.length,
                        (index) => _AccountItemTile(
                          item: _accountItems[index],
                          showDivider: index != _accountItems.length - 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Logout Button
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: _logout,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

final List<_AccountItem> _accountItems = [
  _AccountItem(
    icon: Icons.settings,
    title: 'Settings',
    destination: SettingsScreen(),
  ),
  _AccountItem(
    icon: Icons.support_agent,
    title: 'Contact Support',
    destination: SupportScreen(),
  ),
  _AccountItem(icon: Icons.description, title: 'Terms & Policies'),
  _AccountItem(icon: Icons.language, title: 'Visit Our Website'),
];

class _ProfileCard extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final VoidCallback onTap;

  const _ProfileCard({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.onTap,
  });

  Color get _roleColor {
    switch (role) {
      case 'field_engineer':
        return Colors.blue;
      case 'auditor':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String get _roleLabel {
    return role.replaceAll('_', ' ').toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.person,
                  size: 32,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$firstName $lastName',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(email, style: theme.textTheme.bodySmall),
                    const SizedBox(height: 6),
                    if (role.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _roleColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _roleLabel,
                          style: TextStyle(
                            color: _roleColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Icon(Icons.edit, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? destination;

  const _AccountItem({
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        InkWell(
          onTap: () {
            if (item.destination != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => item.destination!),
              );
            }
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(item.icon, size: 22),
                const SizedBox(width: 16),
                Text(
                  item.title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const Icon(Icons.chevron_right, size: 20),
          ],
        ),
        if (showDivider)
          const Divider(height: 1, indent: 16, endIndent: 16),
        ]
      ],
    );
  }
}