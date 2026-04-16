import 'package:flutter/material.dart';
import 'package:graville_operations/models/dashboard/assign_user_model.dart';
import 'package:graville_operations/services/api_service.dart';

class AssignUserToGroupScreen extends StatefulWidget {
  const AssignUserToGroupScreen({super.key});

  @override
  State<AssignUserToGroupScreen> createState() =>
      _AssignUserToGroupScreenState();
}

class _AssignUserToGroupScreenState extends State<AssignUserToGroupScreen> {
  static const Color kGreen = Color(0xFF1D9E75);

  UserModel? _selectedUser;
  GroupModel? _selectedGroup;
  List<UserModel> _users = [];
  List<GroupModel> _groups = [];
  bool _loadingUsers = false;
  bool _loadingGroups = false;
  String? _usersError;
  String? _groupsError;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _fetchGroups();
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _loadingUsers = true;
      _usersError = null;
    });
    final result = await ApiService.getAllUsers();
    if (!mounted) return;
    if (result['success'] == true) {
      final raw = result['data'];
      final list = raw is List ? raw : (raw['users'] ?? raw['data'] ?? []);
      setState(() {
        _users = (list as List)
            .map((u) => UserModel.fromJson(u as Map<String, dynamic>))
            .toList();
        _loadingUsers = false;
      });
    } else {
      setState(() {
        _usersError = result['message']?.toString() ?? 'Failed to load users';
        _loadingUsers = false;
      });
    }
  }

  Future<void> _fetchGroups() async {
    setState(() {
      _loadingGroups = true;
      _groupsError = null;
    });
    final result = await ApiService.authenticatedGet('/group');
    if (!mounted) return;
    if (result['success'] == true) {
      final raw = result['data'];
      final list = raw is List ? raw : (raw['groups'] ?? raw['data'] ?? []);
      setState(() {
        _groups = (list as List)
            .map((g) => GroupModel.fromJson(g as Map<String, dynamic>))
            .toList();
        _loadingGroups = false;
      });
    } else {
      setState(() {
        _groupsError = result['message']?.toString() ?? 'Failed to load groups';
        _loadingGroups = false;
      });
    }
  }

  void _openUserSheet() {
    if (_loadingUsers) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _UserPickerSheet(
        users: _users,
        selected: _selectedUser,
        onPicked: (u) {
          setState(() => _selectedUser = u);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _openGroupSheet() {
    if (_loadingGroups) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _GroupPickerSheet(
        groups: _groups,
        selected: _selectedGroup,
        onPicked: (g) {
          setState(() => _selectedGroup = g);
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _assign() async {
    if (_selectedUser == null || _selectedGroup == null) return;

    final result = await ApiService.authenticatedPost(
      '/group/${_selectedGroup!.id}/users/${_selectedUser!.id}',
      {},
    );

    if (!mounted) return;

    final success = result['success'] == true;
    final message = success
        ? '${_selectedUser!.fullName} assigned to ${_selectedGroup!.name}'
        : result['message']?.toString() ?? 'Assignment failed';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? kGreen : Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canAssign = _selectedUser != null && _selectedGroup != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F6),
      appBar: AppBar(
        backgroundColor: kGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Assign user to group',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _FieldLabel(label: 'Select user'),
            const SizedBox(height: 6),
            _loadingUsers
                ? _LoadingField(icon: Icons.person_outline_rounded)
                : _usersError != null
                    ? _ErrorField(
                        message: _usersError!,
                        onRetry: _fetchUsers,
                      )
                    : _SelectorField(
                        onTap: _openUserSheet,
                        isSelected: _selectedUser != null,
                        child: _selectedUser == null
                            ? const _FieldPlaceholder(
                                icon: Icons.person_outline_rounded,
                                text: 'Choose a user',
                              )
                            : _UserTile(user: _selectedUser!),
                      ),
            const SizedBox(height: 18),
            const _FieldLabel(label: 'Group to assign'),
            const SizedBox(height: 6),
            _loadingGroups
                ? _LoadingField(icon: Icons.grid_view_rounded)
                : _groupsError != null
                    ? _ErrorField(
                        message: _groupsError!,
                        onRetry: _fetchGroups,
                      )
                    : _SelectorField(
                        onTap: _openGroupSheet,
                        isSelected: _selectedGroup != null,
                        child: _selectedGroup == null
                            ? const _FieldPlaceholder(
                                icon: Icons.grid_view_rounded,
                                text: 'Choose a group',
                              )
                            : _GroupNameTile(group: _selectedGroup!),
                      ),
            const SizedBox(height: 18),
            const _FieldLabel(label: 'Group details'),
            const SizedBox(height: 6),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: _selectedGroup == null
                  ? _EmptyDetailCard(key: const ValueKey('empty'))
                  : _GroupDetailCard(
                      key: ValueKey(_selectedGroup!.id),
                      group: _selectedGroup!,
                    ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: canAssign ? _assign : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 5, 117, 215),
                  disabledBackgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.grey.shade500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Assign',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _LoadingField extends StatelessWidget {
  final IconData icon;
  const _LoadingField({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 0.8),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: Colors.grey.shade300),
          ),
          const SizedBox(width: 10),
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 8),
          Text('Loading…',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade400)),
        ],
      ),
    );
  }
}

class _ErrorField extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorField({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200, width: 0.8),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded,
              size: 18, color: Colors.red.shade400),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message,
                style: TextStyle(fontSize: 12, color: Colors.red.shade400)),
          ),
          GestureDetector(
            onTap: onRetry,
            child: Text('Retry',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.red.shade600,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _GroupNameTile extends StatelessWidget {
  final GroupModel group;
  const _GroupNameTile({required this.group});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: group.color,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(Icons.group_rounded, size: 18, color: group.iconColor),
        ),
        const SizedBox(width: 10),
        Text(
          group.name,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }
}

class _EmptyDetailCard extends StatelessWidget {
  const _EmptyDetailCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 0.8),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              Icons.info_outline_rounded,
              size: 18,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Group info will appear here once selected',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupDetailCard extends StatelessWidget {
  final GroupModel group;
  const _GroupDetailCard({super.key, required this.group});

  static const Color kGreen = Color(0xFF1D9E75);
  static const Color kGreenLight = Color(0xFFE1F5EE);
  static const Color kGreenDark = Color(0xFF0F6E56);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD4EFE6), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: group.color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.group_rounded,
                    size: 20,
                    color: group.iconColor,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        group.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${group.roles.length} roles assigned',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 6, 10, 8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
            child: Text(
              group.description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 4, 12, 6),
            child: Text(
              'ROLES',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color.fromARGB(255, 6, 10, 8),
                letterSpacing: 0.6,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: group.roles.map((role) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: kGreenLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    role,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: kGreenDark,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Colors.grey,
        letterSpacing: 0.6,
      ),
    );
  }
}

class _SelectorField extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final bool isSelected;

  const _SelectorField({
    required this.onTap,
    required this.child,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF1D9E75) : Colors.grey.shade300,
            width: 0.8,
          ),
        ),
        child: Row(
          children: [
            Expanded(child: child),
            const SizedBox(width: 8),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.grey.shade400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldPlaceholder extends StatelessWidget {
  final IconData icon;
  final String text;
  const _FieldPlaceholder({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: Icon(icon, size: 18, color: Colors.grey.shade400),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
        ),
      ],
    );
  }
}

class _UserTile extends StatelessWidget {
  final UserModel user;
  const _UserTile({required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: const Color(0xFFB5D4F4),
          child: Text(
            user.initials,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0C447C),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.fullName,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 1),
              Text(
                user.phone,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UserPickerSheet extends StatefulWidget {
  final List<UserModel> users;
  final UserModel? selected;
  final ValueChanged<UserModel> onPicked;

  const _UserPickerSheet({
    required this.users,
    required this.selected,
    required this.onPicked,
  });

  @override
  State<_UserPickerSheet> createState() => _UserPickerSheetState();
}

class _UserPickerSheetState extends State<_UserPickerSheet> {
  late List<UserModel> _filtered;
  final TextEditingController _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filtered = widget.users;
  }

  void _filter(String q) {
    final lq = q.toLowerCase();
    setState(() {
      _filtered = widget.users
          .where((u) =>
              u.fullName.toLowerCase().contains(lq) || u.phone.contains(lq))
          .toList();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _BottomSheetWrapper(
      title: 'Select user',
      searchController: _ctrl,
      onSearch: _filter,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 16),
        children: [
          const _SheetSectionLabel(label: 'Users'),
          ..._filtered.map((u) {
            final isSel = widget.selected?.id == u.id;
            return ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              tileColor: isSel ? const Color(0xFFE1F5EE) : Colors.transparent,
              leading: CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFFB5D4F4),
                child: Text(
                  u.initials,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0C447C),
                  ),
                ),
              ),
              title: Text(u.fullName,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700)),
              subtitle: Text(u.phone, style: const TextStyle(fontSize: 11)),
              trailing: isSel
                  ? const CircleAvatar(
                      radius: 9,
                      backgroundColor: Color(0xFF1D9E75),
                      child: Icon(Icons.check, size: 11, color: Colors.white),
                    )
                  : null,
              onTap: () => widget.onPicked(u),
            );
          }),
        ],
      ),
    );
  }
}

class _GroupPickerSheet extends StatefulWidget {
  final List<GroupModel> groups;
  final GroupModel? selected;
  final ValueChanged<GroupModel> onPicked;

  const _GroupPickerSheet({
    required this.groups,
    required this.selected,
    required this.onPicked,
  });

  @override
  State<_GroupPickerSheet> createState() => _GroupPickerSheetState();
}

class _GroupPickerSheetState extends State<_GroupPickerSheet> {
  late List<GroupModel> _filtered;
  final TextEditingController _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filtered = widget.groups;
  }

  void _filter(String q) {
    final lq = q.toLowerCase();
    setState(() {
      _filtered = widget.groups
          .where((g) =>
              g.name.toLowerCase().contains(lq) ||
              g.description.toLowerCase().contains(lq))
          .toList();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _BottomSheetWrapper(
      title: 'Select group',
      searchController: _ctrl,
      onSearch: _filter,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 16),
        children: [
          const _SheetSectionLabel(label: 'Groups'),
          ..._filtered.map((g) {
            final isSel = widget.selected?.id == g.id;
            return ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              tileColor: isSel ? const Color(0xFFE1F5EE) : Colors.transparent,
              leading: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: g.color,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(Icons.group_rounded, size: 18, color: g.iconColor),
              ),
              title: Text(g.name,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700)),
              subtitle: Text(g.description,
                  style: const TextStyle(fontSize: 11),
                  overflow: TextOverflow.ellipsis),
              trailing: isSel
                  ? const CircleAvatar(
                      radius: 9,
                      backgroundColor: Color(0xFF1D9E75),
                      child: Icon(Icons.check, size: 11, color: Colors.white),
                    )
                  : null,
              onTap: () => widget.onPicked(g),
            );
          }),
        ],
      ),
    );
  }
}

class _BottomSheetWrapper extends StatelessWidget {
  final String title;
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;
  final Widget child;

  const _BottomSheetWrapper({
    required this.title,
    required this.searchController,
    required this.onSearch,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.grey.shade300, width: 0.8),
                        ),
                        child: const Icon(Icons.close,
                            size: 15, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200, width: 0.8),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      Icon(Icons.search_rounded,
                          size: 18, color: Colors.grey.shade400),
                      const SizedBox(width: 6),
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          onChanged: onSearch,
                          style: const TextStyle(fontSize: 13),
                          decoration: const InputDecoration(
                            hintText: 'Search...',
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 13),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              Expanded(child: child),
            ],
          ),
        );
      },
    );
  }
}

class _SheetSectionLabel extends StatelessWidget {
  final String label;
  const _SheetSectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.grey,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
