import 'package:flutter/material.dart';
import 'package:graville_operations/core/style/color.dart';
import 'package:graville_operations/services/api_service.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  List<dynamic> _users = [];
  List<dynamic> _filteredUsers = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearch);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredUsers = _users;
      } else {
        _filteredUsers = _users.where((u) {
          final name =
              '${u['first_name']} ${u['last_name']}'.toLowerCase();
          final email = (u['email'] ?? '').toLowerCase();
          final role = (u['role'] ?? '').toLowerCase().replaceAll('_', ' ');
          return name.contains(query) ||
              email.contains(query) ||
              role.contains(query);
        }).toList();
      }
    });
  }

  void _loadUsers() async {
    setState(() => _isLoading = true);
    final result = await ApiService.getAllUsers();
    if (result['success']) {
      setState(() {
        _users = result['data'];
        _filteredUsers = result['data'];
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _deleteUser(int userId, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete $name?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final result = await ApiService.deleteUser(userId, '');
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User deleted successfully'),
            backgroundColor: AppColor.primaryBackground,
          ),
        );
        _loadUsers();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Failed to delete user'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Color _roleColor(String role) {
    switch (role.toUpperCase()) {
      case 'ADMIN':
        return Colors.red.shade700;
      case 'FIELD_ENGINEER':
        return AppColor.primaryBackground;
      case 'AUDITOR':
        return Colors.orange;
      case 'FOREMAN':
        return Colors.purple;
      case 'FINANCE':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _roleIcon(String role) {
    switch (role.toUpperCase()) {
      case 'ADMIN':
        return Icons.admin_panel_settings;
      case 'FIELD_ENGINEER':
        return Icons.engineering;
      case 'AUDITOR':
        return Icons.fact_check;
      case 'FOREMAN':
        return Icons.construction;
      case 'FINANCE':
        return Icons.account_balance;
      default:
        return Icons.person;
    }
  }

  String _roleLabel(String role) {
    return role
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isEmpty
            ? ''
            : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            backgroundColor: AppColor.primaryBackground,
            foregroundColor: Colors.white,
            expandedHeight: 130,
            pinned: true,
            floating: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColor.primaryBackground,
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'All Users',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_filteredUsers.length} user${_filteredUsers.length != 1 ? 's' : ''} found',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: _loadUsers,
                tooltip: 'Refresh',
              ),
            ],
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Container(
              color: AppColor.primaryBackground,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by name, email or role...',
                    hintStyle: const TextStyle(
                      color: AppColor.secondaryText,
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColor.primaryBackground,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear,
                                color: AppColor.secondaryText),
                            onPressed: () {
                              _searchController.clear();
                              _onSearch();
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),
          ),

          // Users List
          _isLoading
              ? const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColor.primaryBackground,
                    ),
                  ),
                )
              : _filteredUsers.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 72,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchController.text.isEmpty
                                  ? 'No users found'
                                  : 'No results for "${_searchController.text}"',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final user = _filteredUsers[index];
                            final role = user['role'] ?? '';
                            final name =
                                '${user['first_name']} ${user['last_name']}';
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                leading: CircleAvatar(
                                  backgroundColor:
                                      _roleColor(role).withOpacity(0.1),
                                  child: Icon(
                                    _roleIcon(role),
                                    color: _roleColor(role),
                                    size: 22,
                                  ),
                                ),
                                title: Text(
                                  name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: AppColor.primaryText,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 2),
                                    Text(
                                      user['email'] ?? '',
                                      style: const TextStyle(
                                        color: AppColor.secondaryText,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: _roleColor(role)
                                            .withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        _roleLabel(role),
                                        style: TextStyle(
                                          color: _roleColor(role),
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: Colors.red.shade400,
                                  ),
                                  onPressed: () =>
                                      _deleteUser(user['id'], name),
                                ),
                              ),
                            );
                          },
                          childCount: _filteredUsers.length,
                        ),
                      ),
                    ),
        ],
      ),
    );
  }
}