import 'package:flutter/material.dart';
import 'package:graville_operations/core/commons/widgets/custom_dropdown.dart';
import 'package:graville_operations/core/commons/widgets/sections/form_section.dart';
import 'package:graville_operations/models/material/destination_site.dart';
import 'package:graville_operations/services/transfer_material_service.dart';

class DestinationInfo extends StatefulWidget {
  final DestinationSite? selectedDestination;
  final ValueChanged<DestinationSite?> onChanged;

  const DestinationInfo({
    super.key,
    required this.selectedDestination,
    required this.onChanged,
  });

  @override
  State<DestinationInfo> createState() => _DestinationInfoState();
}

class _DestinationInfoState extends State<DestinationInfo> {
  List<DestinationSite> _sites = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSites();
  }

  Future<void> _loadSites() async {
    final result = await TransferMaterialService.fetchSites();
    if (mounted) {
      setState(() {
        _sites = result;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormSection(
      title: 'Destination Site',
      icon: Icons.construction,
      required: true,
      child: _loading
          ? _LoadingField()
          : CustomDropdown<DestinationSite>(
              hint: 'Select destination site',
              value: widget.selectedDestination,
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
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}