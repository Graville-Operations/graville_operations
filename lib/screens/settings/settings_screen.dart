// import 'package:flutter/material.dart';
// import 'package:graville_operations/models/profile_model.dart';
// import 'package:provider/provider.dart';
// import 'package:graville_operations/providers/language_provider.dart';
// import 'package:graville_operations/providers/theme_provider.dart';
// import 'package:graville_operations/providers/user_provider.dart';
// import 'package:graville_operations/screens/commons/widgets/custom_dropdown.dart';
// import 'package:graville_operations/screens/settings/edit_profile_screen.dart';
// import 'package:graville_operations/services/api_service.dart';

// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({super.key});

//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   String? selectedLanguage = 'en';
//   String? selectedTheme = 'system';

//   final List<String> languages = ['en', 'sw'];
//   final List<String> themes = ['light', 'dark', 'system'];

//   @override
//   void initState() {
//     super.initState();
//     // Load user profile when screen opens
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final userProvider = Provider.of<UserProvider>(context, listen: false);
//       if (userProvider.currentUser == null) {
//         userProvider.loadUserProfile();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F7),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFF5F5F7),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Settings',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           await Provider.of<UserProvider>(
//             context,
//             listen: false,
//           ).loadUserProfile();
//         },
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
//           child: Consumer<UserProvider>(
//             builder: (context, userProvider, child) {
//               final user = userProvider.currentUser;

//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (userProvider.isLoading && user == null)
//                     const Center(
//                       child: Padding(
//                         padding: EdgeInsets.all(32),
//                         child: CircularProgressIndicator(),
//                       ),
//                     ),
//                   if (userProvider.error != null && user == null)
//                     _errorCard(userProvider.error!),
//                   if (user != null) _userProfileCard(user),
//                   if (user != null ||
//                       (!userProvider.isLoading &&
//                           userProvider.error == null)) ...[
//                     const SizedBox(height: 20),
//                     _sectionTitle('Account'),
//                     _settingsCard(
//                       context,
//                       items: [
//                         _item(
//                           Icons.person_outline,
//                           'Edit profile',
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => const EditProfileScreen(),
//                               ),
//                             ).then((_) {
//                               userProvider.loadUserProfile();
//                             });
//                           },
//                         ),
//                         _item(
//                           Icons.security,
//                           'Security',
//                           onTap: () {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(content: Text('Coming soon!')),
//                             );
//                           },
//                         ),
//                         _item(
//                           Icons.notifications_none,
//                           'Notifications',
//                           onTap: () {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(content: Text('Coming soon!')),
//                             );
//                           },
//                         ),
//                         _item(
//                           Icons.lock_outline,
//                           'Privacy',
//                           onTap: () {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(content: Text('Coming soon!')),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     _sectionTitle('Preferences'),
//                     _settingsCard(
//                       context,
//                       items: [
//                         CustomDropdown<String>(
//                           label: 'Language',
//                           value: Provider.of<LanguageProvider>(
//                             context,
//                           ).locale.languageCode,
//                           items: const ["en", "sw"],
//                           displayMapper: (value) {
//                             switch (value) {
//                               case "sw":
//                                 return "Swahili";
//                               default:
//                                 return "English";
//                             }
//                           },
//                           prefixIcon: const Icon(Icons.language),
//                           onChanged: (value) {
//                             if (value != null) {
//                               Provider.of<LanguageProvider>(
//                                 context,
//                                 listen: false,
//                               ).setLanguage(value);
//                             }
//                           },
//                         ),
//                         CustomDropdown<String>(
//                           label: 'Theme',
//                           value: Provider.of<ThemeProvider>(context)
//                                       .themeMode ==
//                                   ThemeMode.dark
//                               ? "dark"
//                               : Provider.of<ThemeProvider>(context).themeMode ==
//                                       ThemeMode.light
//                                   ? "light"
//                                   : "system",
//                           items: themes,
//                           displayMapper: themeLabel,
//                           prefixIcon: const Icon(Icons.dark_mode_outlined),
//                           onChanged: (value) {
//                             if (value != null) {
//                               Provider.of<ThemeProvider>(
//                                 context,
//                                 listen: false,
//                               ).setTheme(value);
//                               setState(() {
//                                 selectedTheme = value;
//                               });
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     _sectionTitle('Support & About'),
//                     _settingsCard(
//                       context,
//                       items: [
//                         _item(
//                           Icons.help_outline,
//                           'Help & Support',
//                           onTap: () {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(content: Text('Coming soon!')),
//                             );
//                           },
//                         ),
//                         _item(
//                           Icons.info_outline,
//                           'Terms and Policies',
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     _sectionTitle('Actions'),
//                     _settingsCard(
//                       context,
//                       items: [
//                         _item(
//                           Icons.flag_outlined,
//                           'Report a problem',
//                           onTap: () {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(content: Text('Coming soon!')),
//                             );
//                           },
//                         ),
//                         _item(
//                           Icons.person_add_alt,
//                           'Add account',
//                           onTap: () {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(content: Text('Coming soon!')),
//                             );
//                           },
//                         ),
//                         _item(
//                           Icons.logout,
//                           'Log out',
//                           onTap: () => _showLogoutDialog(context),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _userProfileCard(UserProfile user) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 35,
//             backgroundColor: Colors.blue.shade100,
//             backgroundImage: user.profilePicture != null
//                 ? NetworkImage(user.profilePicture!)
//                 : null,
//             child: user.profilePicture == null
//                 ? Text(
//                     user.initials,
//                     style: const TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue,
//                     ),
//                   )
//                 : null,
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   user.fullName,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   user.email,
//                   style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                 ),
//                 if (user.phoneNumber != null) ...[
//                   const SizedBox(height: 2),
//                   Text(
//                     user.phoneNumber!,
//                     style: TextStyle(fontSize: 12, color: Colors.grey[500]),
//                   ),
//                 ],
//                 const SizedBox(height: 8),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 2,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.shade50,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     user.role.toUpperCase(),
//                     style: TextStyle(
//                       fontSize: 10,
//                       color: Colors.blue.shade700,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.edit, color: Colors.blue),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const EditProfileScreen(),
//                 ),
//               ).then((_) {
//                 Provider.of<UserProvider>(
//                   context,
//                   listen: false,
//                 ).loadUserProfile();
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _errorCard(String error) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.red.shade50,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.red.shade200),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.error_outline, color: Colors.red.shade700),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(error, style: TextStyle(color: Colors.red.shade700)),
//           ),
//           TextButton(
//             onPressed: () {
//               Provider.of<UserProvider>(
//                 context,
//                 listen: false,
//               ).loadUserProfile();
//             },
//             child: const Text('Retry'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Logout'),
//         content: const Text('Are you sure you want to logout?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               await ApiService.clearSession();
//               final userProvider = Provider.of<UserProvider>(
//                 context,
//                 listen: false,
//               );
//               userProvider.clearUser();
//               if (mounted) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Logged out successfully')),
//                 );
//               }
//             },
//             child: const Text('Logout', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _sectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//           color: Colors.black,
//         ),
//       ),
//     );
//   }

//   Widget _settingsCard(BuildContext context, {required List<Widget> items}) {
//     return Material(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(16),
//       child: Column(
//         children: items.map((item) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             child: item,
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _item(IconData icon, String title, {VoidCallback? onTap}) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(16),
//       onTap: onTap,
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.black54),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Text(
//               title,
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//             ),
//           ),
//           const Icon(Icons.chevron_right),
//         ],
//       ),
//     );
//   }

//   String themeLabel(String theme) {
//     switch (theme) {
//       case 'light':
//         return 'Light';
//       case 'dark':
//         return 'Dark';
//       case 'system':
//         return 'System';
//       default:
//         return theme;
//     }
//   }
// }
