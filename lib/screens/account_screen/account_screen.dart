import 'package:flutter/material.dart';
import 'package:graville_operations/screens/support/support_screen.dart';
import 'package:graville_operations/settings_screen/settings_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _ProfileCard(
              onTap: () {
                debugPrint('Profile card tapped');
              },
            ),
            const SizedBox(height: 16),
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
          ],
        ),
      ),
    );
  }
}

final List<_AccountItem> _accountItems = [
  _AccountItem(icon: Icons.person, title: 'Profile'),
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
  final VoidCallback onTap;

  const _ProfileCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'John Doe',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('johndoe@gmail.com', style: theme.textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountItem {
  final IconData icon;
  final String title;
  final Widget? destination;
  const _AccountItem({
    required this.icon,
    required this.title,
    this.destination,
  });
}

class _AccountItemTile extends StatelessWidget {
  final _AccountItem item;
  final bool showDivider;

  const _AccountItemTile({required this.item, required this.showDivider});

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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              ],
            ),
          ),
        ),
        if (showDivider) const Divider(height: 1, indent: 16, endIndent: 16),
      ],
    );
  }
}
