import 'package:flutter/material.dart';
import 'package:graville_operations/core/commons/widgets/custom_dropdown.dart';
import 'package:graville_operations/core/commons/widgets/custom_text_input.dart';
import 'package:graville_operations/core/commons/widgets/sections/form_section.dart';
import 'package:graville_operations/models/material/app_material.dart';
import 'package:graville_operations/services/transfer_material_service.dart';

class MaterialInfoSection extends StatefulWidget {
  final AppMaterial? selectedMaterial;
  final ValueChanged<AppMaterial?> onChanged;
  final List<AppMaterial>? items;

  const MaterialInfoSection({
    super.key,
    required this.selectedMaterial,
    required this.onChanged,
    this.items, 
  });

  @override
  State<MaterialInfoSection> createState() => _MaterialInfoSectionState();
}

class _MaterialInfoSectionState extends State<MaterialInfoSection> {
  List<AppMaterial> _materials = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.items == null) {
      _fetchMaterials();
    }
  }

  Future<void> _fetchMaterials() async {
    setState(() => _loading = true);
    final result = await TransferMaterialService.fetchMaterials();
    if (mounted) {
      setState(() {
        _materials = result;
        _loading   = false;
      });
    }
  }

  List<AppMaterial> get _effectiveItems =>
      widget.items ?? _materials;

  @override
  Widget build(BuildContext context) {
    final categoryController = TextEditingController(
      text: widget.selectedMaterial?.category ?? '',
    );

    return Column(
      children: [
        FormSection(
          title: 'Material Name',
          icon: Icons.inventory,
          required: true,
          child: _loading
              ? _LoadingField()
              : CustomDropdown<AppMaterial>(
                  hint: 'Select material',
                  value: widget.selectedMaterial,
                  items: _effectiveItems,
                  displayMapper: (item) => item.name,
                  onChanged: widget.onChanged,
                ),
        ),
        FormSection(
          title: 'Material Category',
          icon: Icons.category,
          child: CustomTextInput(
            controller: categoryController,
            hintText: '',
            readOnly: true,
          ),
        ),
      ],
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