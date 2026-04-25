import 'package:flutter/material.dart';
import 'package:graville_operations/core/local/entities/menu_data.dart'
    as menu_data;
import 'package:graville_operations/core/remote/api/menus.dart';
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
                  Text('ref: ${_group.refId}',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                          fontFamily: 'monospace')),
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

// ─── Assign Menu Sheet ─────────────────────────────────────────────────────

class _AssignMenuSheet extends StatefulWidget {
  final Group group;
  final void Function(List<Menu> assignedMenus) onAssigned;

  const _AssignMenuSheet({required this.group, required this.onAssigned});

  @override
  State<_AssignMenuSheet> createState() => _AssignMenuSheetState();
}

class _AssignMenuSheetState extends State<_AssignMenuSheet> {
  // Use the aliased type to avoid SubMenu name clash
  List<menu_data.MenuItem> _allMenus = [];
  final Set<String> _selectedRefIds = {};
  final Set<int> _expandedMenuIds = {};
  bool _isLoadingMenus = true;
  bool _isSubmitting = false;
  String? _loadError;

  static const Color _blue = Color(0xFF0057D9);

  @override
  void initState() {
    super.initState();
    _loadMenus();
  }

  Future<void> _loadMenus() async {
    setState(() {
      _isLoadingMenus = true;
      _loadError = null;
    });
    try {
      final menus = await MenuApi.getAllMenus();
      setState(() {
        _allMenus = menus;
        _isLoadingMenus = false;
        // Pre-select menus already assigned to this group
        for (final assigned in widget.group.assignedMenus) {
          final matches = menus.where((m) => m.id == assigned.id);
          if (matches.isNotEmpty) {
            final refId = matches.first.refId;
            if (refId != null && refId.isNotEmpty) {
              _selectedRefIds.add(refId);
            }
          }
        }
      });
    } catch (e) {
      setState(() {
        _loadError = e.toString();
        _isLoadingMenus = false;
      });
    }
  }

  Future<void> _submit() async {
    if (_selectedRefIds.isEmpty) {
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
        menuIds: _selectedRefIds.toList(),
      );

      // Convert selected menu_data.MenuItem → groups.Menu for parent callback
      final assignedMenus = _allMenus
          .where((m) => m.refId != null && _selectedRefIds.contains(m.refId))
          .map((m) => Menu(
                id: m.id ?? 0,
                name: m.name ?? '',
                title: m.title ?? '',
                link: m.link,
                icon: m.icon,
                priority: m.priority ?? 0,
                subMenus: m.subMenus
                    .map((s) => SubMenu(
                          id: s.id ?? 0,
                          name: s.name ?? '',
                          title: s.title ?? '',
                          link: s.link,
                          icon: s.icon,
                          priority: s.priority ?? 0,
                        ))
                    .toList(),
              ))
          .toList();

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
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (ctx, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // ── Header ──
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
                      if (_selectedRefIds.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                              color: const Color(0xFFE8F0FE),
                              borderRadius: BorderRadius.circular(20)),
                          child: Text('${_selectedRefIds.length} selected',
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

            // ── Menu list ──
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
                              const SizedBox(height: 4),
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
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                              itemCount: _allMenus.length,
                              itemBuilder: (_, i) {
                                final menu = _allMenus[i];
                                final refId = menu.refId ?? '';
                                final selected =
                                    _selectedRefIds.contains(refId);
                                final menuId = menu.id ?? i;
                                final expanded =
                                    _expandedMenuIds.contains(menuId);
                                final hasSubMenus = menu.subMenus.isNotEmpty;

                                return Column(
                                  children: [
                                    // Menu row
                                    GestureDetector(
                                      onTap: () => setState(() {
                                        if (refId.isEmpty) return;
                                        if (selected) {
                                          _selectedRefIds.remove(refId);
                                        } else {
                                          _selectedRefIds.add(refId);
                                        }
                                      }),
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 4),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: selected
                                              ? const Color(0xFFE8F0FE)
                                              : const Color(0xFFF5F6FA),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: selected
                                                ? _blue
                                                : const Color(0xFFE0E4F0),
                                            width: selected ? 1.5 : 0.8,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            // Checkbox indicator
                                            Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                color: selected
                                                    ? _blue
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    color: selected
                                                        ? _blue
                                                        : const Color(
                                                            0xFFE0E4F0),
                                                    width: 0.8),
                                              ),
                                              child: Icon(
                                                selected
                                                    ? Icons.check_rounded
                                                    : Icons.menu_rounded,
                                                color: selected
                                                    ? Colors.white
                                                    : Colors.grey,
                                                size: 16,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    menu.title ??
                                                        menu.name ??
                                                        '',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: selected
                                                            ? _blue
                                                            : const Color(
                                                                0xFF1A1A3E)),
                                                  ),
                                                  if (hasSubMenus)
                                                    Text(
                                                        '${menu.subMenus.length} sub-menu${menu.subMenus.length == 1 ? '' : 's'}',
                                                        style: const TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 11)),
                                                ],
                                              ),
                                            ),
                                            // Expand/collapse toggle
                                            if (hasSubMenus)
                                              GestureDetector(
                                                onTap: () => setState(() {
                                                  if (expanded) {
                                                    _expandedMenuIds
                                                        .remove(menuId);
                                                  } else {
                                                    _expandedMenuIds
                                                        .add(menuId);
                                                  }
                                                }),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  child: Icon(
                                                    expanded
                                                        ? Icons
                                                            .keyboard_arrow_up_rounded
                                                        : Icons
                                                            .keyboard_arrow_down_rounded,
                                                    color: Colors.grey,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Sub-menus (expandable)
                                    if (hasSubMenus && expanded)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, bottom: 4),
                                        child: Column(
                                          children: menu.subMenus.map((sub) {
                                            return Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 4),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color:
                                                        const Color(0xFFE0E4F0),
                                                    width: 0.5),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 6,
                                                    height: 6,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color(0xFFB0BEC5),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          sub.title ??
                                                              sub.name ??
                                                              '',
                                                          style: const TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Color(
                                                                  0xFF1A1A3E)),
                                                        ),
                                                        if (sub.link != null &&
                                                            sub.link!
                                                                .isNotEmpty)
                                                          Text(sub.link!,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                      10)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),

                                    const SizedBox(height: 4),
                                  ],
                                );
                              },
                            ),
            ),

            // ── Submit button ──
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
                          _selectedRefIds.isEmpty
                              ? 'Select menus to assign'
                              : 'Assign ${_selectedRefIds.length} Menu(s)',
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
