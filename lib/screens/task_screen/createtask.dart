import 'package:flutter/material.dart';
import 'package:graville_operations/core/commons/widgets/custom_text_input.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _taskNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _startDate;
  DateTime? _dueDate;
  String? _dateError;

  @override
  void dispose() {
    _taskNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: (_startDate != null && _dueDate != null)
          ? DateTimeRange(start: _startDate!, end: _dueDate!)
          : null,
      initialEntryMode: DatePickerEntryMode.calendar,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            appBarTheme: AppBarTheme(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _dueDate = picked.end;
        _dateError = null;
      });
    }
  }

  void _validateDates() {
    if (_startDate != null && _dueDate != null) {
      if (_dueDate!.isBefore(_startDate!)) {
        _dateError = 'Due date must be on or after the start date.';
      } else {
        _dateError = null;
      }
    } else {
      _dateError = null;
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String? _getDurationText() {
    if (_startDate == null || _dueDate == null) return null;
    final diff = _dueDate!.difference(_startDate!).inDays;
    if (diff == 0) return 'Same day';
    if (diff == 1) return '1 day';
    return '$diff days';
  }

  void _handleCreate() {
    if (!_formKey.currentState!.validate()) return;
    if (_dateError != null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task "${_taskNameController.text.trim()}" created!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    _taskNameController.clear();
    _descriptionController.clear();
    setState(() {
      _startDate = null;
      _dueDate = null;
      _dateError = null;
    });
  }

  void _handleCancel() {
    _taskNameController.clear();
    _descriptionController.clear();
    setState(() {
      _startDate = null;
      _dueDate = null;
      _dateError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final duration = _getDurationText();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create Task',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Task Name
                _buildLabel('Task name', required: true),
                const SizedBox(height: 6),
                CustomTextInput(
                  controller: _taskNameController,
                  hintText: 'e.g. perimeter wall fencing',
                  prefixIcon: Icons.task_alt_outlined,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Task name is required' : null,
                ),
                const SizedBox(height: 18),

                _buildLabel('Description'),
                const SizedBox(height: 6),
                CustomTextInput(
                  controller: _descriptionController,
                  hintText: 'Enter description',
                  maxLines: 4,
                  prefixIcon: Icons.notes_outlined,
                ),
                const SizedBox(height: 18),

                // Date Range Card
                _buildLabel('Date range'),
                const SizedBox(height: 6),
                _buildDateRangeCard(context),

                if (_dateError != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    child: Text(
                      _dateError!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],

                // Duration hint
                if (duration != null && _dateError == null) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.schedule,
                          size: 14,
                          color: Theme.of(context).colorScheme.secondary),
                      const SizedBox(width: 5),
                      Text(
                        'Duration: $duration',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 32),

                // Create Task button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    onPressed: _handleCreate,
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.onSurface,
                      foregroundColor: Theme.of(context).colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Create task',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Cancel button
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: OutlinedButton(
                    onPressed: _handleCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.secondary,
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, {bool required = false}) {
    return RichText(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.secondary,
        ),
        children: required
            ? [
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ]
            : [],
      ),
    );
  }

  Widget _buildDateRangeCard(BuildContext context) {
    final bool hasRange = _startDate != null && _dueDate != null;
    final bool hasStart = _startDate != null;

    return GestureDetector(
      onTap: () => _pickDateRange(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
          border: Border.all(color: Colors.grey[300]!, width: 1.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.date_range_outlined,
              size: 18,
              color: hasStart ? Colors.black87 : Colors.grey[400],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: hasRange
                  ? Row(
                      children: [
                        // Start date
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _formatDate(_startDate!),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.arrow_forward,
                            size: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                        // End date
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'End',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _formatDate(_dueDate!),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Text(
                      'Select start & end date',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
            ),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}