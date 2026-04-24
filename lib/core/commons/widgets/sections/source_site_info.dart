import 'package:flutter/material.dart';
import 'package:graville_operations/core/commons/widgets/custom_dropdown.dart';
import 'package:graville_operations/core/commons/widgets/sections/form_section.dart';
import 'package:graville_operations/models/material/destination_site.dart';
import 'package:graville_operations/services/transfer_material_service.dart';

class SourceSiteInfo extends StatefulWidget {
  final DestinationSite? selectedSite;
  final ValueChanged<DestinationSite?> onChanged;
  final List<DestinationSite> items;

  const SourceSiteInfo({
    super.key,
    required this.selectedSite,
    required this.onChanged,
    required this.items,
  });

  @override
  State<SourceSiteInfo> createState() => _SourceSiteInfoState();
}

class _SourceSiteInfoState extends State<SourceSiteInfo> {
  List<DestinationSite> _sites = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await TransferMaterialService.fetchSites();
    if (mounted) {
      setState(() {
        _sites   = result;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormSection(
      title: 'Source Site',
      icon: Icons.location_on_outlined,
      required: true,
      child: _loading
          ? _LoadingField()
          : CustomDropdown<DestinationSite>(
              hint: 'Select source site',
              value: widget.selectedSite,
              items: _sites,
              displayMapper: (item) => item.name,
              onChanged: widget.onChanged,
            ),
    );
  }
}

class _LoadingField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: SizedBox(
          width: 20, height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}