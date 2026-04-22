import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graville_operations/core/commons/widgets/custom_button.dart';
import 'package:graville_operations/core/commons/widgets/custom_dropdown.dart';
import 'package:graville_operations/core/commons/widgets/custom_text_input.dart';
import 'package:graville_operations/core/commons/widgets/section_card.dart';
import 'package:graville_operations/core/utils/enums/ProjectStatus.dart';
import 'package:graville_operations/screens/sites/create/controller.dart';

class CreateSitesScreen extends StatefulWidget {
  const CreateSitesScreen({super.key});

  @override
  State<CreateSitesScreen> createState() => _CreateSitesScreenState();
}

class _CreateSitesScreenState extends State<CreateSitesScreen> {
  final controller = CreateSiteController();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.black,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) controller.setCompletionDate(picked);
  }

  Widget _label(IconData icon, String text) => Row(
    children: [
      Icon(icon, size: 16, color: Colors.black87),
      const SizedBox(width: 8),
      Text(text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
    ],
  );

  @override
  void dispose() {
    controller.state.nameController.dispose();
    controller.state.locationController.dispose();
    controller.state.tenderNameController.dispose();
    controller.state.inquiringEntityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f7),
      body: Obx(() => CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            floating: true,
            snap: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Row(
              children: const [
                Icon(Icons.create_sharp, color: Colors.black, size: 20),
                SizedBox(width: 8),
                Text(
                  'New Project',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            centerTitle: false,
            titleSpacing: 0,
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label(Icons.folder_open, 'Project Name'),
                      const SizedBox(height: 12),
                      CustomTextInput(
                        controller: controller.state.nameController,
                        hintText: 'e.g. Sunrise Apartments Phase 2',
                        prefixIcon: Icons.folder_open,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label(Icons.business_center_outlined, 'Tender Details'),
                      const SizedBox(height: 12),
                      CustomDropdown<String>(
                        value: controller.state.selectedCompany.value.isEmpty
                            ? null
                            : controller.state.selectedCompany.value,
                        items: _tenderCompanies,
                        displayMapper: (company) => company,
                        hint: 'Select Tenderer Name',
                        onChanged: (company) => controller.companyChange(company),
                      ),
                      const SizedBox(height: 10),
                      CustomTextInput(
                        controller: controller.state.inquiringEntityController,
                        hintText: 'Inquiring entity (org. that issued the tender)',
                        prefixIcon: Icons.account_balance_outlined,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label(Icons.flag_outlined, 'Project Status'),
                      const SizedBox(height: 14),
                      Row(
                        children: ProjectStatus.values.map((s) {
                          final selected =
                              s == controller.state.projectStatus.value;
                          final isLast = s == ProjectStatus.values.last;
                          return Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsets.only(right: isLast ? 0 : 8),
                              child: GestureDetector(
                                onTap: () =>
                                    controller.changeProjectStatus(s),
                                child: AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? s.color.withOpacity(0.12)
                                        : Colors.grey.shade100,
                                    borderRadius:
                                        BorderRadius.circular(10),
                                    border: Border.all(
                                      color: selected
                                          ? s.color
                                          : Colors.transparent,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Column(children: [
                                    Icon(s.icon,
                                        size: 20,
                                        color: selected
                                            ? s.color
                                            : Colors.grey),
                                    const SizedBox(height: 4),
                                    Text(
                                      s.label,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: selected
                                            ? s.color
                                            : Colors.grey,
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label(Icons.location_on_outlined, 'Location'),
                      const SizedBox(height: 12),
                      CustomTextInput(
                        controller: controller.state.locationController,
                        hintText: 'e.g. Nairobi, Kenya',
                        prefixIcon: Icons.location_on_outlined,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Location is required'
                                : null,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label(
                          Icons.calendar_today_outlined, 'Completion Date'),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: _pickDate,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 13),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: controller.state.completionDate.value !=
                                      null
                                  ? Colors.black
                                  : Colors.grey.shade200,
                              width: controller.state.completionDate.value !=
                                      null
                                  ? 1.5
                                  : 1,
                            ),
                          ),
                          child: Row(children: [
                            Icon(
                              Icons.event,
                              size: 16,
                              color:
                                  controller.state.completionDate.value != null
                                      ? Colors.black
                                      : Colors.grey.shade400,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              controller.state.completionDate.value != null
                                  ? '${controller.state.completionDate.value!.day} / '
                                    '${controller.state.completionDate.value!.month} / '
                                    '${controller.state.completionDate.value!.year}'
                                  : 'Select completion date',
                              style: TextStyle(
                                fontSize: 14,
                                color: controller.state.completionDate.value !=
                                        null
                                    ? Colors.black87
                                    : Colors.grey.shade400,
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label(Icons.notes_outlined, 'Description'),
                      const SizedBox(height: 12),
                      CustomTextInput(
                        controller: controller.state.tenderNameController,
                        hintText: 'Brief project overview...',
                        prefixIcon: Icons.notes_outlined,
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label(Icons.label_outline, 'Tags'),
                      const SizedBox(height: 4),
                      Text('Select all that apply',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _availableTags.map((tag) {
                          final selected =
                              controller.state.selectedTags.contains(tag);
                          return GestureDetector(
                            onTap: () => selected
                                ? controller.removeTag(tag)
                                : controller.addTag(tag),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 7),
                              decoration: BoxDecoration(
                                color: selected
                                    ? Colors.black
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: selected
                                      ? Colors.black
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: selected
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                CustomButton(
                  label: 'Create Project',
                  onPressed: () => controller.createProject(),
                  isLoading: controller.state.isSubmitting.value,
                  backgroundColor: Colors.green,
                  width: double.infinity,
                  height: 52,
                  borderRadius: 16,
                  icon: const Icon(Icons.check_circle_outline,
                      color: Colors.white, size: 20),
                ),

                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      )),
    );
  }
}

extension ProjectStatusExt on ProjectStatus {
  String get apiValue => const {
    ProjectStatus.onGoing:   'On-going',
    ProjectStatus.completed: 'Completed',
    ProjectStatus.delayed:   'Delayed',
  }[this]!;

  String get label => const {
    ProjectStatus.onGoing:   'On-going',
    ProjectStatus.completed: 'Completed',
    ProjectStatus.delayed:   'Delayed',
  }[this]!;

  Color get color => const {
    ProjectStatus.onGoing:   Color(0xff1db954),
    ProjectStatus.completed: Color(0xff5b7cfa),
    ProjectStatus.delayed:   Color(0xffe53935),
  }[this]!;

  IconData get icon => const {
    ProjectStatus.onGoing:   Icons.play_circle_outline,
    ProjectStatus.completed: Icons.check_circle_outline,
    ProjectStatus.delayed:   Icons.pause_circle_outline,
  }[this]!;
}

const _availableTags = [
  'Civil Works', 'Electrical', 'Plumbing', 'Structural',
  'Roofing', 'Interior Fit-Out', 'Roads', 'Water & Sanitation',
  'Government', 'Private Sector', 'Residential', 'Commercial',
];

const _tenderCompanies = [
  'Graville Enterprises Limited',
  'Flex(K) Limited',
  'Mejams Investment Limited',
  'Stanmore Enterprise Limited',
  'Alicewood Investment Limited',
  'RealDiamond(K) Limited',
  'Primeville Enterprises',
];