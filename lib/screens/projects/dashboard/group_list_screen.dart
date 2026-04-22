import 'package:flutter/material.dart';
import 'package:graville_operations/models/auth/groups.dart';
import 'package:graville_operations/services/api_service.dart';
import 'group_detail_screen.dart';

class GroupsListScreen extends StatefulWidget {
  const GroupsListScreen({super.key});

  @override
  State<GroupsListScreen> createState() => _GroupsListScreenState();
}

class _GroupsListScreenState extends State<GroupsListScreen> {
  List<Group> _allGroups = [];
  List<Group> _filteredGroups = [];
  bool _isLoading = true;
  String? _error;
  final TextEditingController _searchController = TextEditingController();

  static const Color _primaryBlue = Color(0xFF0057D9);

  @override
  void initState() {
    super.initState();
    _loadGroups();
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadGroups() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final groups = await ApiService.getAllGroups();
      setState(() {
        _allGroups = groups;
        _filteredGroups = groups;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onSearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredGroups = _allGroups.where((g) {
        final titleMatch = g.readableTitle.toLowerCase().contains(query);
        final roleMatch =
            g.roles.any((r) => r.readableTitle.toLowerCase().contains(query));
        return titleMatch || roleMatch;
      }).toList();
    });
  }

  // ─── Create Group Bottom Sheet ────────────────────────────────────────────
  void _showCreateGroupSheet() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                  const SizedBox(height: 20),
                  const Text('Create New Group',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A3E))),
                  const SizedBox(height: 18),
                  _buildInputField(
                    controller: titleController,
                    label: 'Group Title',
                    hint: 'e.g. Manager Group',
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Title is required' : null,
                  ),
                  const SizedBox(height: 12),
                  _buildInputField(
                    controller: descController,
                    label: 'Description',
                    hint: 'Brief description of this group',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (!formKey.currentState!.validate()) return;
                              setSheetState(() => isLoading = true);
                              try {
                                await ApiService.createGroup(
                                  title: titleController.text.trim(),
                                  description: descController.text.trim(),
                                );
                                if (ctx.mounted) Navigator.pop(ctx);
                                if (mounted) {
                                  _showSnack('Group created successfully!',
                                      isSuccess: true);
                                  _loadGroups();
                                }
                              } catch (e) {
                                setSheetState(() => isLoading = false);
                                if (mounted) _showSnack('Failed: $e');
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Text('Create Group',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Get by ID Bottom Sheet ───────────────────────────────────────────────
  void _showGetByIdSheet() {
    final idController = TextEditingController();
    bool isLoading = false;
    Group? fetchedGroup;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: const Color(0xFFE8F0FE),
                          borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.manage_search_rounded,
                          color: _primaryBlue, size: 18),
                    ),
                    const SizedBox(width: 10),
                    const Text('Get Group by ID',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A3E))),
                  ],
                ),
                const SizedBox(height: 18),
                _buildInputField(
                  controller: idController,
                  label: 'Group ID',
                  hint: 'Enter numeric group ID',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                // Result preview
                if (fetchedGroup != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F0FE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.group_rounded,
                            color: _primaryBlue, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(fetchedGroup!.readableTitle,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1A1A3E),
                                      fontSize: 13)),
                              Text(
                                  '${fetchedGroup!.roles.length} role(s) · ID ${fetchedGroup!.id}',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 11)),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      GroupDetailScreen(group: fetchedGroup!)),
                            );
                          },
                          child: const Text('View',
                              style: TextStyle(color: _primaryBlue)),
                        )
                      ],
                    ),
                  ),

                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            final id = int.tryParse(idController.text.trim());
                            if (id == null) {
                              _showSnack('Please enter a valid numeric ID');
                              return;
                            }
                            setSheetState(() {
                              isLoading = true;
                              fetchedGroup = null;
                            });
                            try {
                              final result = await ApiService.getGroupById(id);
                              setSheetState(() {
                                fetchedGroup = result;
                                isLoading = false;
                              });
                            } catch (e) {
                              setSheetState(() => isLoading = false);
                              if (mounted) _showSnack('Not found: $e');
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Text('Search',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ),
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
          _buildSearchBar(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: _primaryBlue,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 16),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Groups',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600)),
              ),
              // Get by ID button
              GestureDetector(
                onTap: _showGetByIdSheet,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.manage_search_rounded,
                      color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(width: 8),
              // Create group button
              GestureDetector(
                onTap: _showCreateGroupSheet,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add_rounded,
                      color: Colors.white, size: 22),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: _primaryBlue,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(24),
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: const InputDecoration(
            hintText: 'Search groups or roles...',
            hintStyle: TextStyle(color: Colors.white60, fontSize: 14),
            prefixIcon:
                Icon(Icons.search_rounded, color: Colors.white70, size: 20),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: Color(0xFF0057D9)));
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text('Something went wrong',
                style: TextStyle(
                    color: Colors.grey[700], fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(_error!,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadGroups,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0057D9),
                  foregroundColor: Colors.white),
            ),
          ],
        ),
      );
    }
    if (_filteredGroups.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.group_off_rounded, color: Colors.grey[400], size: 48),
            const SizedBox(height: 12),
            Text('No groups found',
                style: TextStyle(
                    color: Colors.grey[600], fontWeight: FontWeight.w500)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadGroups,
      color: _primaryBlue,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.0, // square cards
        ),
        itemCount: _filteredGroups.length,
        itemBuilder: (context, index) => _GroupCard(
          group: _filteredGroups[index],
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    GroupDetailScreen(group: _filteredGroups[index]),
              ),
            );
            _loadGroups();
          },
          onMenusUpdated: (menus) {
            setState(() {
              _filteredGroups[index].assignedMenus = menus;
              // also update in _allGroups
              final allIdx = _allGroups
                  .indexWhere((g) => g.id == _filteredGroups[index].id);
              if (allIdx != -1) _allGroups[allIdx].assignedMenus = menus;
            });
          },
        ),
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final Group group;
  final VoidCallback onTap;
  final void Function(List<Menu> menus) onMenusUpdated;

  const _GroupCard({
    required this.group,
    required this.onTap,
    required this.onMenusUpdated,
  });

  static const _blue = Color(0xFF0057D9);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE0E4F0), width: 0.8),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.group_rounded, color: _blue, size: 22),
            ),
            const SizedBox(height: 10),

            // Group title
            Text(
              group.readableTitle,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A3E),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),

            // Roles
            if (group.roles.isNotEmpty)
              Wrap(
                spacing: 4,
                runSpacing: 3,
                children: group.roles
                    .take(2) // show max 2 role chips to keep card tidy
                    .map((r) =>
                        _chip(r.readableTitle, const Color(0xFFE8F0FE), _blue))
                    .toList(),
              )
            else
              Text('No roles',
                  style: TextStyle(color: Colors.grey[400], fontSize: 11)),

            // Assigned menus
            if (group.assignedMenus.isNotEmpty) ...[
              const SizedBox(height: 6),
              const Divider(
                  height: 0, thickness: 0.5, color: Color(0xFFE0E4F0)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 4,
                runSpacing: 3,
                children: group.assignedMenus
                    .take(2)
                    .map((m) => _chip(m.title, const Color(0xFFE8F5E9),
                        const Color(0xFF2E7D32)))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, Color bg, Color fg) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
        child: Text(label,
            style:
                TextStyle(fontSize: 9, color: fg, fontWeight: FontWeight.w600)),
      );
}
