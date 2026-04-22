import 'package:flutter/material.dart';
import 'package:graville_operations/models/auth/groups.dart';
import 'package:graville_operations/services/api_service.dart';

class GroupDetailScreen extends StatefulWidget {
  final Group group;

  const GroupDetailScreen({super.key, required this.group});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  late Group _group;

  static const Color _primaryBlue = Color(0xFF0057D9);

  @override
  void initState() {
    super.initState();
    _group = widget.group;
  }

  // ─── Assign Menu Bottom Sheet ─────────────────────────────────────────────
  void _showAssignMenuSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AssignMenuSheet(
        group: _group,
        onAssigned: (assignedMenus) {
          setState(() => _group.assignedMenus = assignedMenus);
        },
      ),
    );
  }

  void _showSnack(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green[700] : Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A3E))),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
            filled: true,
            fillColor: const Color(0xFFF5F6FA),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Color(0xFFE0E4F0), width: 0.8)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: _primaryBlue, width: 1.5)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: _primaryBlue,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 16),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('Group Details',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_group.readableTitle,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(
                    'ref: ${_group.refId}',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                        fontFamily: 'monospace'),
                  ),
                  if (_group.description.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(_group.description,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13,
                            height: 1.4)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Single Assign Menu action button
          GestureDetector(
            onTap: _showAssignMenuSheet,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: _primaryBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant_menu_rounded,
                      color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('Assign Menus to Group',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Assigned Menus card
          if (_group.assignedMenus.isNotEmpty) ...[
            _SectionCard(
              title: 'Assigned Menus (${_group.assignedMenus.length})',
              icon: Icons.restaurant_menu_rounded,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _group.assignedMenus
                    .map((m) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(m.title,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF2E7D32),
                                  fontWeight: FontWeight.w500)),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 14),
          ],

          // Group Info card
          _SectionCard(
            title: 'Group Info',
            icon: Icons.info_outline_rounded,
            child: Column(
              children: [
                _InfoRow(label: 'ID', value: _group.id.toString()),
                _InfoRow(label: 'Modified by', value: _group.modifiedBy),
                _InfoRow(
                    label: 'Created at',
                    value: _group.createdAt.split('T').first),
                _InfoRow(
                    label: 'Updated at',
                    value: _group.updatedAt.split('T').first,
                    isLast: true),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Roles card
          _SectionCard(
            title: 'Roles (${_group.roles.length})',
            icon: Icons.shield_rounded,
            child: _group.roles.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('No roles assigned to this group',
                        style: TextStyle(color: Colors.grey, fontSize: 13)),
                  )
                : Column(
                    children: List.generate(_group.roles.length, (i) {
                      final role = _group.roles[i];
                      return _RoleDetailRow(
                          role: role, isLast: i == _group.roles.length - 1);
                    }),
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Assign Menu Sheet (stateful, fetches menus) ───────────────────────────

class _AssignMenuSheet extends StatefulWidget {
  final Group group;
  final void Function(List<Menu> assignedMenus) onAssigned;

  const _AssignMenuSheet({required this.group, required this.onAssigned});

  @override
  State<_AssignMenuSheet> createState() => _AssignMenuSheetState();
}

class _AssignMenuSheetState extends State<_AssignMenuSheet> {
  List<Menu> _allMenus = [];
  final Set<int> _selectedIds = {};
  bool _isLoadingMenus = true;
  bool _isSubmitting = false;
  String? _loadError;

  static const Color _blue = Color(0xFF0057D9);

  @override
  void initState() {
    super.initState();
    _loadMenus();
    // Pre-select already assigned menus
    for (final m in widget.group.assignedMenus) {
      _selectedIds.add(m.id);
    }
  }

  Future<void> _loadMenus() async {
    try {
      final menus = await ApiService.getAllMenus();
      setState(() {
        _allMenus = menus;
        _isLoadingMenus = false;
      });
    } catch (e) {
      setState(() {
        _loadError = e.toString();
        _isLoadingMenus = false;
      });
    }
  }

  Future<void> _submit() async {
    if (_selectedIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select at least one menu'),
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      await ApiService.assignMenuToGroup(
        groupId: widget.group.id,
        menuIds: _selectedIds.map((id) => id.toString()).toList(),
      );
      final assignedMenus =
          _allMenus.where((m) => _selectedIds.contains(m.id)).toList();
      widget.onAssigned(assignedMenus);
      if (mounted) Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Menus assigned successfully!'),
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ));
    } catch (e) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed: $e'),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (ctx, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle + header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: const Color(0xFFE8F0FE),
                            borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.restaurant_menu_rounded,
                            color: _blue, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Assign Menus',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1A1A3E))),
                            Text('to ${widget.group.readableTitle}',
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      if (_selectedIds.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                              color: const Color(0xFFE8F0FE),
                              borderRadius: BorderRadius.circular(20)),
                          child: Text('${_selectedIds.length} selected',
                              style: const TextStyle(
                                  color: _blue,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 0, thickness: 0.5),
                ],
              ),
            ),

            // Menu list
            Expanded(
              child: _isLoadingMenus
                  ? const Center(child: CircularProgressIndicator(color: _blue))
                  : _loadError != null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.error_outline,
                                  color: Colors.red, size: 36),
                              const SizedBox(height: 8),
                              Text('Failed to load menus',
                                  style: TextStyle(color: Colors.grey[600])),
                              TextButton(
                                  onPressed: _loadMenus,
                                  child: const Text('Retry')),
                            ],
                          ),
                        )
                      : _allMenus.isEmpty
                          ? const Center(
                              child: Text('No menus available',
                                  style: TextStyle(color: Colors.grey)))
                          : ListView.builder(
                              controller: scrollController,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              itemCount: _allMenus.length,
                              itemBuilder: (_, i) {
                                final menu = _allMenus[i];
                                final selected = _selectedIds.contains(menu.id);
                                return GestureDetector(
                                  onTap: () => setState(() {
                                    if (selected) {
                                      _selectedIds.remove(menu.id);
                                    } else {
                                      _selectedIds.add(menu.id);
                                    }
                                  }),
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? const Color(0xFFE8F0FE)
                                          : const Color(0xFFF5F6FA),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: selected
                                            ? _blue
                                            : const Color(0xFFE0E4F0),
                                        width: selected ? 1.5 : 0.8,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color:
                                                selected ? _blue : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color: selected
                                                    ? _blue
                                                    : const Color(0xFFE0E4F0),
                                                width: 0.8),
                                          ),
                                          child: Icon(
                                            selected
                                                ? Icons.check_rounded
                                                : Icons.menu_rounded,
                                            color: selected
                                                ? Colors.white
                                                : Colors.grey,
                                            size: 18,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(menu.title,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: selected
                                                          ? _blue
                                                          : const Color(
                                                              0xFF1A1A3E))),
                                              if (menu.subMenus.isNotEmpty)
                                                Text(
                                                    '${menu.subMenus.length} sub-menu(s)',
                                                    style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 11)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
            ),

            // Submit button
            Padding(
              padding: EdgeInsets.fromLTRB(
                  16, 8, 16, MediaQuery.of(context).padding.bottom + 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : Text(
                          _selectedIds.isEmpty
                              ? 'Select menus to assign'
                              : 'Assign ${_selectedIds.length} Menu(s)',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Reusable Widgets ──────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard(
      {required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E4F0), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF0057D9), size: 18),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A3E))),
              ],
            ),
          ),
          const Divider(height: 0, thickness: 0.8, color: Color(0xFFE0E4F0)),
          Padding(padding: const EdgeInsets.all(14), child: child),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _InfoRow(
      {required this.label, required this.value, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 90,
              child: Text(label,
                  style: const TextStyle(color: Colors.grey, fontSize: 13))),
          Expanded(
              child: Text(value,
                  style: const TextStyle(
                      color: Color(0xFF1A1A3E),
                      fontSize: 13,
                      fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}

class _RoleDetailRow extends StatelessWidget {
  final Role role;
  final bool isLast;

  const _RoleDetailRow({required this.role, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6FA),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE0E4F0), width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FE),
                  borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.verified_user_rounded,
                  color: Color(0xFF0057D9), size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(role.readableTitle,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A3E))),
                  if (role.description.isNotEmpty)
                    Text(role.description,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 11),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
