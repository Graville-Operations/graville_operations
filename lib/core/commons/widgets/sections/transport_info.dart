import 'package:flutter/material.dart';
import 'package:graville_operations/core/commons/widgets/custom_dropdown.dart';
import 'package:graville_operations/core/commons/widgets/sections/form_section.dart';
import 'package:graville_operations/models/material/transport_mode.dart';
import 'package:graville_operations/services/transfer_material_service.dart';

class TransportInfo extends StatefulWidget {
  final TransportMode? selectedMode;
  final ValueChanged<TransportMode?> onChanged;

  const TransportInfo({
    super.key,
    required this.selectedMode,
    required this.onChanged,
  });

  @override
  State<TransportInfo> createState() => _TransportInfoState();
}

class _TransportInfoState extends State<TransportInfo> {
  List<TransportMode> _modes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadModes();
  }

  Future<void> _loadModes() async {
    final result = await TransferMaterialService.fetchTransportModes();
    if (mounted) {
      setState(() {
        _modes = result;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormSection(
      title: 'Mode of Transport',
      icon: Icons.local_shipping,
      required: true,
      child: _loading
          ? _LoadingField()
          : CustomDropdown<TransportMode>(
              hint: 'Select mode of transport',
              value: widget.selectedMode,
              items: _modes,
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