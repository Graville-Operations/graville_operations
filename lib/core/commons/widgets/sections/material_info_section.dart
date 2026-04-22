import 'package:flutter/material.dart';
import 'package:graville_operations/core/commons/widgets/custom_dropdown.dart';
import 'package:graville_operations/core/commons/widgets/custom_text_input.dart';
import 'package:graville_operations/core/commons/widgets/sections/form_section.dart';
import 'package:graville_operations/models/material/app_material.dart';
import 'package:graville_operations/services/transfer_material_service.dart';

class MaterialInfoSection extends StatefulWidget {
  final AppMaterial? selectedMaterial;
  final ValueChanged<AppMaterial?> onChanged;

  const MaterialInfoSection({
    super.key,
    required this.selectedMaterial,
    required this.onChanged,
  });

  @override
  State<MaterialInfoSection> createState() => _MaterialInfoSectionState();
}

class _MaterialInfoSectionState extends State<MaterialInfoSection> {
  List<AppMaterial> _materials = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadMaterials();
  }

  Future<void> _loadMaterials() async {
    final result = await TransferMaterialService.fetchMaterials();
    if (mounted) {
      setState(() {
        _materials = result;
        _loading = false;
      });
    }
  }

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
              ? const _LoadingField()
              : CustomDropdown<AppMaterial>(
                  hint: 'Select material',
                  value: widget.selectedMaterial,
                  items: _materials,
                  displayMapper: (item) => item.name,
                  onChanged: widget.onChanged,
                ),
        ),
        FormSection(
          title: 'Material Category',
          icon: Icons.category,
          required: false,
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
  const _LoadingField();

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