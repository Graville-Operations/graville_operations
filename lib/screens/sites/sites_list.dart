import 'package:flutter/material.dart';
import 'package:graville_operations/models/site/site_model.dart';
import 'package:graville_operations/screens/sites/edit_site.dart';
import 'package:graville_operations/services/site_service.dart';
import 'package:graville_operations/screens/sites/create_sites.dart';
import 'package:graville_operations/screens/commons/widgets/section_card.dart';
//import 'package:graville_operations/screens/sites/create_sites.dart';
import 'package:graville_operations/screens/commons/widgets/status_chip.dart';

const _projectStatuses = ['On-going', 'Completed', 'Delayed'];

class SitesListScreen extends StatefulWidget {
  const SitesListScreen({super.key});

  @override
  State<SitesListScreen> createState() => _SitesListScreenState();
}

class _SitesListScreenState extends State<SitesListScreen> {
  late Future<List<SiteModel>> _sitesFuture;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => _sitesFuture = SiteService.getAllSites();

  void _refresh() => setState(() => _load());

  Future<void> _deleteSite(SiteModel site) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Site', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to delete "${site.name}"? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await SiteService.deleteSite(site.id!);
      _refresh();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Text('"${site.name}" deleted', style: const TextStyle(color: Colors.white)),
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to delete site'), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> _changeStatus(SiteModel site) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // drag handle
            Center(child: Container(width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4)))),
            const SizedBox(height: 16),
            const Text('Change Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            ..._projectStatuses.map((s) {
              final isCurrent = s == site.projectStatus;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(radius: 5,
                    backgroundColor: isCurrent ? Colors.black : Colors.grey.shade300),
                title: Text(s, style: TextStyle(
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal)),
                trailing: isCurrent ? const Icon(Icons.check, size: 18) : null,
                onTap: () => Navigator.pop(ctx, s),
              );
            }),
          ],
        ),
      ),
    );
    if (picked == null || picked == site.projectStatus) return;
    try {
      await SiteService.updateSite(site.id!, SiteModel(
        name: site.name, location: site.location, projectStatus: picked));
      _refresh();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to update status'), backgroundColor: Colors.red));
      }
    }
  }

  void _viewDetails(SiteModel site) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, controller) => SingleChildScrollView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4)))),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(child: Text(site.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
              _StatusBadge(status: site.projectStatus),
            ]),
            const SizedBox(height: 16),
            _DetailRow(icon: Icons.location_on_outlined, label: 'Location', value: site.location),
            if (site.tenderName != null)
              _DetailRow(icon: Icons.business_center_outlined, label: 'Tenderer', value: site.tenderName!),
            if (site.inquiringEntity != null)
              _DetailRow(icon: Icons.account_balance_outlined, label: 'Inquiring Entity', value: site.inquiringEntity!),
            if (site.completionDate != null)
              _DetailRow(icon: Icons.calendar_today_outlined, label: 'Completion Date', value: site.completionDate!),
            if (site.description != null && site.description!.isNotEmpty)
              _DetailRow(icon: Icons.notes_outlined, label: 'Description', value: site.description!),
            if (site.tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text('Tags', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 6,
                children: site.tags.map((t) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300)),
                  child: Text(t, style: const TextStyle(fontSize: 12)),
                )).toList(),
              ),
            ],
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f7),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          floating: true,
          snap: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Sites', style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.black),
              onPressed: _refresh,
            ),
          ],
        ),

        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: FutureBuilder<List<SiteModel>>(
            future: _sitesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(color: Colors.black)));
              }
              if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(child: Text('Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red))));
              }
              final sites = snapshot.data ?? [];
              if (sites.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text('No sites yet.',
                      style: TextStyle(color: Colors.grey))));
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _SiteCard(
                      site: sites[i],
                      onView: () => _viewDetails(sites[i]),
                      onEdit: () async {
                        final result = await Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => EditSiteScreen(site: sites[i])));
                        if (result == true) _refresh();
                      },
                      onDelete: () => _deleteSite(sites[i]),
                      onChangeStatus: () => _changeStatus(sites[i]),
                    ),
                  ),
                  childCount: sites.length,
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}

class _SiteCard extends StatelessWidget {
  final SiteModel site;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onChangeStatus;

  const _SiteCard({
    required this.site,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    required this.onChangeStatus,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header row
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: Text(site.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(width: 8),
          _StatusBadge(status: site.projectStatus),
        ]),

        if (site.location.isNotEmpty) ...[
          const SizedBox(height: 6),
          Row(children: [
            Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade500),
            const SizedBox(width: 4),
            Expanded(child: Text(site.location,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                maxLines: 1, overflow: TextOverflow.ellipsis)),
          ]),
        ],
        if (site.tenderName != null) ...[
          const SizedBox(height: 4),
          Row(children: [
            Icon(Icons.business_center_outlined, size: 14, color: Colors.grey.shade500),
            const SizedBox(width: 4),
            Expanded(child: Text(site.tenderName!,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                maxLines: 1, overflow: TextOverflow.ellipsis)),
          ]),
        ],
        if (site.tags.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(spacing: 6, runSpacing: 4,
            children: site.tags.take(3).map((t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200)),
              child: Text(t, style: const TextStyle(fontSize: 11)),
            )).toList(),
          ),
        ],

        const SizedBox(height: 12),
        const Divider(height: 1),
        const SizedBox(height: 8),

        // Action row
        Row(children: [
          _ActionBtn(icon: Icons.visibility_outlined, label: 'View', onTap: onView),
          _ActionBtn(icon: Icons.edit_outlined, label: 'Edit', onTap: onEdit),
          _ActionBtn(icon: Icons.swap_horiz, label: 'Status', onTap: onChangeStatus),
          _ActionBtn(icon: Icons.delete_outline, label: 'Delete', onTap: onDelete, color: Colors.red),
        ]),
      ]),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _ActionBtn({required this.icon, required this.label, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? Colors.black87;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(children: [
          Icon(icon, size: 18, color: c),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 10, color: c, fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  Color get _color => switch (status) {
        'Completed' => const Color(0xff5b7cfa),
        'Delayed'   => const Color(0xffe53935),
        _           => const Color(0xff1db954),
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: _color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _color.withOpacity(0.4))),
      child: Text(status, style: TextStyle(fontSize: 11, color: _color, fontWeight: FontWeight.w600)),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 16, color: Colors.grey.shade500),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 14)),
        ]),
      ]),
    );
  }
}