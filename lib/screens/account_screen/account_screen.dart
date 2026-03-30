import 'package:flutter/material.dart';
import 'package:graville_operations/models/profile_model.dart';
import 'package:graville_operations/screens/settings/edit_profile_screen.dart';
import 'package:graville_operations/screens/commons/widgets/custom_dropdown.dart';
import 'package:graville_operations/screens/support/support_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  UserProfile? _user;
  String? _error;

  @override
  void initState() {
    super.initState();

    // ✅ Initialize user directly (no loading function)
    _user = UserProfile(
      id: 1,
      email: "john@example.com",
      firstName: "John",
      lastName: "Doe",
      role: "user",
      isActive: true,
      phoneNumber: "0712345678",
      profilePicture: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF5F5F7),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _ProfileCard(user: _user, error: _error),
            const SizedBox(height: 24),

            /// ACCOUNT
            _SectionCard(
              title: 'Account',
              items: [
                _AccountItem(
                  icon: Icons.edit,
                  title: 'Edit Profile',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  ),
                ),
                _AccountItem(icon: Icons.security, title: 'Security'),
                _AccountItem(
                    icon: Icons.notifications_none, title: 'Notifications'),
                _AccountItem(icon: Icons.lock_outline, title: 'Privacy'),
              ],
            ),

            const SizedBox(height: 16),

            /// PREFERENCES
            _SectionCard(
              title: 'Preferences',
              items: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: CustomDropdown<String>(
                    label: 'Language',
                    items: const ['en', 'sw'],
                    displayMapper: (value) =>
                        value == 'sw' ? 'Swahili' : 'English',
                    prefixIcon: const Icon(Icons.language),
                    onChanged: (value) {},
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: CustomDropdown<String>(
                    label: 'Theme',
                    items: const ['light', 'dark', 'system'],
                    displayMapper: (value) => value,
                    prefixIcon: const Icon(Icons.dark_mode_outlined),
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// SUPPORT
            _SectionCard(
              title: 'Support & About',
              items: [
                _AccountItem(
                  icon: Icons.support_agent,
                  title: 'Help & Support',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SupportScreen()),
                  ),
                ),
                _AccountItem(
                    icon: Icons.description, title: 'Terms & Policies'),
              ],
            ),

            const SizedBox(height: 16),

            /// ACTIONS
            _SectionCard(
              title: 'Actions',
              items: [
                _AccountItem(
                    icon: Icons.flag_outlined, title: 'Report a problem'),
                _AccountItem(
                    icon: Icons.person_add_alt_1, title: 'Add account'),
                _AccountItem(icon: Icons.language, title: 'Visit our website'),
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
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out')),
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final UserProfile? user;
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
                        fontSize: 28,
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
                  Text(
                    user?.fullName ?? 'Guest User',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? 'guest@graville.com',
                    style: theme.textTheme.bodyMedium,
                  ),
                  if (user?.phoneNumber != null)
                    Text(
                      user!.phoneNumber!,
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
