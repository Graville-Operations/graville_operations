import 'package:flutter/material.dart';
import 'package:graville_operations/core/commons/widgets/custom_dropdown.dart';
import 'package:graville_operations/core/commons/widgets/sections/form_section.dart';
import 'package:graville_operations/models/material/destination_site.dart';

class DestinationInfo extends StatelessWidget {
  final DestinationSite? selectedDestination;
  final ValueChanged<DestinationSite?> onChanged;
  const DestinationInfo({
    super.key,
    required this.selectedDestination,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<DestinationSite> destination = const [
      DestinationSite(id: "1", name: "Mishi Mboko"),
      DestinationSite(id: "2", name: "Iruka Police Station"),
      DestinationSite(id: "3", name: "Mabatini Primary"),
      DestinationSite(id: "4", name: "Kwa Njenga"),
      DestinationSite(id: "5", name: "Wanga TTI"),
    ];

    return Column(
      children: [
        FormSection(
          title: "Destination Site",
          icon: Icons.construction,
          required: true,
          child: CustomDropdown<DestinationSite>(
            hint: "Select destination site",
            value: selectedDestination,
            items: destination,
            displayMapper: (item) => item.name,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
