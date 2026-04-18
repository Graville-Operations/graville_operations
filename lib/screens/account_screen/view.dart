import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graville_operations/core/commons/widgets/backgound_card.dart';
import 'package:graville_operations/core/commons/widgets/custom_alert_dialog.dart';
import 'package:graville_operations/screens/account_screen/controller.dart';
import 'package:graville_operations/screens/account_screen/widgets/ProfileCard.dart';
import 'package:graville_operations/screens/account_screen/widgets/nav_card.dart';
import 'package:graville_operations/screens/account_screen/widgets/section_card.dart';
import 'package:graville_operations/screens/settings/edit_profile_screen.dart';
import 'package:graville_operations/screens/support/support_screen.dart';

class AccountScreen extends GetView<AccountScreenController> {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
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
          ProfileCard(user: controller.state.user.value,),
          SectionLabel(sectionName:  'Account'),
          BackGroundCard(children: [
            NavigationCard(
              icon: Icons.edit,
              label: 'Edit Profile',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              ),
            ),
            NavigationCard(icon: Icons.lock, label: 'Security', onTap: () {}),
            NavigationCard(
                icon: Icons.notifications,
                label: 'Notifications',
                onTap: () {}),
            NavigationCard(
                icon: Icons.security,
                label: 'Privacy',
                onTap: () {},
                isLast: true,),
          ]),
          SectionLabel(sectionName: 'Preferences'),
          BackGroundCard(children: [
            _buildDropdownItem(
              icon: Icons.language,
              label: 'Language',
              value: controller.state.language.value,
              options: const ['English', 'Swahili'],
              onChanged: (val) => val!=null?controller.languageChange(val):{},
            ),
            _buildDropdownItem(
              icon: Icons.brightness_6,
              label: 'Theme',
              value: controller.state.theme.value,
              options: const ['Light', 'Dark', 'System'],
              onChanged: (val) => val!=null?controller.themeChange(val):{},
              isLast: true,
            ),
          ]),
          SectionLabel(sectionName: 'Support & About'),
          BackGroundCard(children: [
            NavigationCard(
              icon: Icons.help,
              label: 'Help & Support',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SupportScreen()),
              ),
            ),
            NavigationCard(
              icon: Icons.description,
              label: 'Terms & Policies',
              onTap: () {},
              isLast: true,
            ),
          ]),
          SectionLabel(sectionName: 'Actions'),
          BackGroundCard(children: [
            NavigationCard(
                icon: Icons.flag, label: 'Report a Problem', onTap: () {}),
            NavigationCard(
                icon: Icons.person_add, label: 'Add Account', onTap: () {}),
            NavigationCard(
                icon: Icons.open_in_browser,
                label: 'Visit Our Website',
                onTap: () {}),
            NavigationCard(
              icon: Icons.logout,
              label: 'Log Out',
              onTap: (){
                CustomAlertDialog.show(
                  context: context,
                  title: 'Delete Account',
                  message: 'This action cannot be undone. Are you sure?',
                  confirmText: 'Delete',
                  confirmColor: Colors.red[200],
                  onConfirm: () {

                  },
                );
              },
              isDanger: true,
              showChevron: false,
              isLast: true,
            ),
          ]),
        ],
      ),
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
}
