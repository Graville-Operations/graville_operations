import 'package:flutter/material.dart';
import 'package:graville_operations/screens/settings/edit_profile_screen.dart';
import 'package:graville_operations/screens/support/support_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _selectedLanguage = 'English';
  String _selectedTheme = 'System';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF50),
        elevation: 2,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Account',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 40),
        children: [
          // ── Profile Card ───────────────────────────────────────────────────
          _buildProfileCard(),

          // ── Account Section ────────────────────────────────────────────────
          _buildSectionLabel('Account'),
          _buildCard([
            _buildNavItem(
              icon: Icons.edit,
              label: 'Edit Profile',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              ),
            ),
            _buildNavItem(icon: Icons.lock, label: 'Security', onTap: () {}),
            _buildNavItem(
                icon: Icons.notifications,
                label: 'Notifications',
                onTap: () {}),
            _buildNavItem(
                icon: Icons.security,
                label: 'Privacy',
                onTap: () {},
                isLast: true),
          ]),

          // ── Preferences Section ────────────────────────────────────────────
          _buildSectionLabel('Preferences'),
          _buildCard([
            _buildDropdownItem(
              icon: Icons.language,
              label: 'Language',
              value: _selectedLanguage,
              options: const ['English', 'Swahili'],
              onChanged: (val) => setState(() => _selectedLanguage = val!),
            ),
            _buildDropdownItem(
              icon: Icons.brightness_6,
              label: 'Theme',
              value: _selectedTheme,
              options: const ['Light', 'Dark', 'System'],
              onChanged: (val) => setState(() => _selectedTheme = val!),
              isLast: true,
            ),
          ]),

          // ── Support & About Section ────────────────────────────────────────
          _buildSectionLabel('Support & About'),
          _buildCard([
            _buildNavItem(
              icon: Icons.help,
              label: 'Help & Support',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SupportScreen()),
              ),
            ),
            _buildNavItem(
              icon: Icons.description,
              label: 'Terms & Policies',
              onTap: () {},
              isLast: true,
            ),
          ]),

          // ── Actions Section ────────────────────────────────────────────────
          _buildSectionLabel('Actions'),
          _buildCard([
            _buildNavItem(
                icon: Icons.flag, label: 'Report a Problem', onTap: () {}),
            _buildNavItem(
                icon: Icons.person_add, label: 'Add Account', onTap: () {}),
            _buildNavItem(
                icon: Icons.open_in_browser,
                label: 'Visit Our Website',
                onTap: () {}),
            _buildNavItem(
              icon: Icons.logout,
              label: 'Log Out',
              onTap: _showLogoutDialog,
              isDanger: true,
              showChevron: false,
              isLast: true,
            ),
          ]),
        ],
      ),
    );
  }

  // ── Profile Card ─────────────────────────────────────────────────────────────
  Widget _buildProfileCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF2196F3),
                ),
                child: const Icon(Icons.person, size: 40, color: Colors.white),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: const Icon(Icons.camera_alt,
                      size: 13, color: Colors.black87),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'johndoe@gmail.com',
                  style: TextStyle(fontSize: 13, color: Color(0xFF757575)),
                ),
                SizedBox(height: 2),
                Text(
                  '+254 712 345 678',
                  style: TextStyle(fontSize: 13, color: Color(0xFF757575)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Section Label ─────────────────────────────────────────────────────────────
  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1A1A1A),
        ),
      ),
    );
  }

  // ── Card Wrapper ──────────────────────────────────────────────────────────────
  Widget _buildCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  // ── Navigation Item ───────────────────────────────────────────────────────────
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDanger = false,
    bool showChevron = true,
    bool isLast = false,
  }) {
    final color = isDanger ? const Color(0xFFE53E3E) : const Color(0xFF1A1A1A);

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: isLast
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                )
              : BorderRadius.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: Row(
              children: [
                Icon(icon, size: 22, color: color),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                ),
                if (showChevron)
                  const Icon(Icons.chevron_right,
                      size: 22, color: Color(0xFFBDBDBD)),
              ],
            ),
          ),
        ),
        if (!isLast)
          const Divider(
              height: 1, indent: 54, endIndent: 0, color: Color(0xFFE0E0E0)),
      ],
    );
  }

  // ── Dropdown Item ─────────────────────────────────────────────────────────────
  Widget _buildDropdownItem({
    required IconData icon,
    required String label,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Icon(icon, size: 22, color: const Color(0xFF1A1A1A)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value,
                  icon: const Icon(Icons.keyboard_arrow_down,
                      color: Color(0xFF1A1A1A), size: 22),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1A1A),
                  ),
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  onChanged: onChanged,
                  items: options
                      .map((opt) =>
                          DropdownMenuItem(value: opt, child: Text(opt)))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
              height: 1, indent: 54, endIndent: 0, color: Color(0xFFE0E0E0)),
      ],
    );
  }

  // ── Logout Dialog ─────────────────────────────────────────────────────────────
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Out',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content:
            const Text('Are you sure you want to log out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF757575))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Log Out',
              style: TextStyle(
                color: Color(0xFFE53E3E),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
