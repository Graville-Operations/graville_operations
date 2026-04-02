import 'package:flutter/material.dart';
import 'package:graville_operations/navigation/custom_navigator.dart';
import 'package:graville_operations/screens/commons/widgets/section_card.dart';

enum ProjectStatus { onGoing, completed, delayed }

extension ProjectStatusExt on ProjectStatus {
  String get apiValue => const {
        ProjectStatus.onGoing: 'On-going',
        ProjectStatus.completed: 'Completed',
        ProjectStatus.delayed: 'Delayed',
      }[this]!;

  String get label => const {
        ProjectStatus.onGoing: 'On-going',
        ProjectStatus.completed: 'Completed',
        ProjectStatus.delayed: 'Delayed',
      }[this]!;

  Color get color => const {
        ProjectStatus.onGoing: Color(0xff1db954),
        ProjectStatus.completed: Color(0xff5b7cfa),
        ProjectStatus.delayed: Color(0xffe53935),
      }[this]!;

  IconData get icon => const {
        ProjectStatus.onGoing: Icons.play_circle_outline,
        ProjectStatus.completed: Icons.check_circle_outline,
        ProjectStatus.delayed: Icons.pause_circle_outline,
      }[this]!;
}

class CreateSitesScreen extends StatefulWidget {
  const CreateSitesScreen({super.key});

  @override
  State<CreateSitesScreen> createState() => _CreateSitesScreenState();
}

class _CreateSitesScreenState extends State<CreateSitesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _latCtrl = TextEditingController();
  final _lngCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _tagCtrl = TextEditingController();

  ProjectStatus _status = ProjectStatus.onGoing;
  DateTime? _completionDate;
  final List<String> _tags = [];
  bool _isSubmitting = false;

  @override
  void dispose() {
    for (final c in [_nameCtrl, _locationCtrl, _latCtrl, _lngCtrl, _descCtrl, _tagCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  void _addTag() {
    final tag = _tagCtrl.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() { _tags.add(tag); _tagCtrl.clear(); });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: Colors.black, onPrimary: Colors.white),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _completionDate = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    // TODO: wire to your API client
    // final payload = {
    //   'name': _nameCtrl.text.trim(),
    //   'project_status': _status.apiValue,
    //   'location': _locationCtrl.text.trim(),
    //   'completion_date': _completionDate?.toIso8601String(),
    //   'latitude': double.tryParse(_latCtrl.text),
    //   'longitude': double.tryParse(_lngCtrl.text),
    //   'description': _descCtrl.text.trim(),
    //   'tags': _tags,
    // };

    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isSubmitting = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text('Project "${_nameCtrl.text.trim()}" created!',
            style: const TextStyle(color: Colors.white)),
      ));
      Navigator.of(context).pop();
    }
  }

  InputDecoration _inputDec(String hint, {Widget? prefixIcon}) => InputDecoration(
        hintText: hint,
        prefixIcon: prefixIcon,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black, width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xffe53935))),
      );

  Widget _label(IconData icon, String text) => Row(children: [
        Icon(icon, size: 16, color: Colors.black87),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f7),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: FloatingActionButton.extended(
            heroTag: 'submit_project',
            onPressed: _isSubmitting ? null : _submit,
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            label: _isSubmitting
                ? const SizedBox(width: 20, height: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                    SizedBox(width: 10),
                    Text('Create Project',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                            fontSize: 15, letterSpacing: 0.3)),
                  ]),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: CustomScrollView(slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            floating: true,
            snap: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text('New Project',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17)),
            centerTitle: true,
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // Project Name
                SectionCard(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _label(Icons.folder_open, 'Project Name'),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: _inputDec('e.g. Sunrise Apartments Phase 2'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                    ),
                  ]),
                ),

                const SizedBox(height: 14),

                // Status
                SectionCard(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _label(Icons.flag_outlined, 'Project Status'),
                    const SizedBox(height: 14),
                    Row(
                      children: ProjectStatus.values.map((s) {
                        final selected = s == _status;
                        final isLast = s == ProjectStatus.values.last;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: isLast ? 0 : 8),
                            child: GestureDetector(
                              onTap: () => setState(() => _status = s),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: selected ? s.color.withOpacity(0.12) : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: selected ? s.color : Colors.transparent, width: 1.5),
                                ),
                                child: Column(children: [
                                  Icon(s.icon, size: 20, color: selected ? s.color : Colors.grey),
                                  const SizedBox(height: 4),
                                  Text(s.label, style: TextStyle(fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: selected ? s.color : Colors.grey)),
                                ]),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ]),
                ),

                const SizedBox(height: 14),

                // Location
                SectionCard(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _label(Icons.location_on_outlined, 'Location'),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _locationCtrl,
                      decoration: _inputDec('e.g. Nairobi, Kenya'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Location is required' : null,
                    ),
                    const SizedBox(height: 10),
                    Row(children: [
                      Expanded(child: TextFormField(
                        controller: _latCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        decoration: _inputDec('Latitude',
                            prefixIcon: Icon(Icons.swap_vert, size: 14, color: Colors.grey.shade500)),
                      )),
                      const SizedBox(width: 10),
                      Expanded(child: TextFormField(
                        controller: _lngCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        decoration: _inputDec('Longitude',
                            prefixIcon: Icon(Icons.swap_horiz, size: 14, color: Colors.grey.shade500)),
                      )),
                    ]),
                  ]),
                ),

                const SizedBox(height: 14),

                // Completion Date
                SectionCard(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _label(Icons.calendar_today_outlined, 'Completion Date'),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _completionDate != null ? Colors.black : Colors.grey.shade200,
                            width: _completionDate != null ? 1.5 : 1,
                          ),
                        ),
                        child: Row(children: [
                          Icon(Icons.event, size: 16,
                              color: _completionDate != null ? Colors.black : Colors.grey.shade400),
                          const SizedBox(width: 10),
                          Text(
                            _completionDate != null
                                ? '${_completionDate!.day} / ${_completionDate!.month} / ${_completionDate!.year}'
                                : 'Select completion date',
                            style: TextStyle(fontSize: 14,
                                color: _completionDate != null ? Colors.black87 : Colors.grey.shade400),
                          ),
                        ]),
                      ),
                    ),
                  ]),
                ),

                const SizedBox(height: 14),

                // Description
                SectionCard(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _label(Icons.notes_outlined, 'Description'),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descCtrl,
                      maxLines: 4,
                      decoration: _inputDec('Brief project overview...'),
                    ),
                  ]),
                ),

                const SizedBox(height: 14),

                // Tags
                SectionCard(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _label(Icons.label_outline, 'Tags'),
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(child: TextFormField(
                        controller: _tagCtrl,
                        decoration: _inputDec('Add a tag...'),
                        onFieldSubmitted: (_) => _addTag(),
                      )),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _addTag,
                        child: Container(
                          width: 42, height: 42,
                          decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                          child: const Icon(Icons.add, color: Colors.white, size: 20),
                        ),
                      ),
                    ]),
                    if (_tags.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8, runSpacing: 6,
                        children: _tags.map((t) => Chip(
                          label: Text(t, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                          deleteIcon: const Icon(Icons.close, size: 14, color: Colors.black54),
                          onDeleted: () => setState(() => _tags.remove(t)),
                          backgroundColor: Colors.grey.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                        )).toList(),
                      ),
                    ],
                  ]),
                ),

              ]),
            ),
          ),
        ]),
      ),
    );
  }
}