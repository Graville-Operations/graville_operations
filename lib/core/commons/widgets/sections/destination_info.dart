import 'package:flutter/material.dart';
import 'package:graville_operations/core/commons/widgets/custom_dropdown.dart';
import 'package:graville_operations/core/commons/widgets/sections/form_section.dart';
import 'package:graville_operations/models/material/destination_site.dart';

class DestinationInfo extends StatelessWidget {
  final DestinationSite? selectedDestination;
  final ValueChanged<DestinationSite?> onChanged;
  final List<DestinationSite> items;   

  const DestinationInfo({
    super.key,
    required this.selectedDestination,
    required this.onChanged,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return FormSection(
      title: 'Destination Site',
      icon: Icons.construction,
      required: true,
      child: CustomDropdown<DestinationSite>(
        hint: 'Select destination site',
        value: selectedDestination,
        items: items,
        displayMapper: (item) => item.name,
        onChanged: onChanged,
      ),
    );
  }
}