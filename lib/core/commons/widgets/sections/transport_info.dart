import 'package:flutter/material.dart';
import 'package:graville_operations/core/commons/widgets/custom_dropdown.dart';
import 'package:graville_operations/core/commons/widgets/sections/form_section.dart';
import 'package:graville_operations/models/material/transport_mode.dart';

class TransportInfo extends StatelessWidget {
  final TransportMode? selectedMode;
  final ValueChanged<TransportMode?> onChanged;
  const TransportInfo({
    super.key,
    required this.onChanged,
    required this.selectedMode,
  });

  @override
  Widget build(BuildContext context) {
    final List<TransportMode> mode = const [
      TransportMode(id: "1", name: "Truck"),
      TransportMode(id: "2", name: "Tipper"),
      TransportMode(id: "3", name: "Pickup"),
      TransportMode(id: "4", name: "Lorry"),
    ];

    return Column(
      children: [
        FormSection(
          title: "Mode of Transport",
          icon: Icons.local_shipping,
          required: true,
          child: CustomDropdown<TransportMode>(
            hint: "Select mode of transport",
            value: selectedMode,
            items: mode,
            displayMapper: (item) => item.name,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
