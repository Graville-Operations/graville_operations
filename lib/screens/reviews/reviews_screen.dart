import 'package:flutter/material.dart';
import 'package:graville_operations/core/commons/widgets/custom_button.dart';
import 'package:graville_operations/core/commons/widgets/custom_dropdown.dart';
import 'package:graville_operations/core/commons/widgets/custom_text_input.dart';
import 'package:intl/intl.dart';

enum ReviewType { general, audit, inspection, compliance, safety }

enum ReviewStatus { open, inProgress, closed }

extension ReviewTypeX on ReviewType {
  String get label => switch (this) {
        ReviewType.general => 'General',
        ReviewType.audit => 'Audit',
        ReviewType.inspection => 'Inspection',
        ReviewType.compliance => 'Compliance',
        ReviewType.safety => 'Safety',
      };
}

extension ReviewStatusX on ReviewStatus {
  String get label => switch (this) {
        ReviewStatus.open => 'Open',
        ReviewStatus.inProgress => 'In Progress',
        ReviewStatus.closed => 'Closed',
      };

  Color statusColor(ColorScheme cs) => switch (this) {
        ReviewStatus.open => cs.tertiary,
        ReviewStatus.inProgress => cs.secondary,
        ReviewStatus.closed => cs.primary,
      };
}

class CreateReviewScreen extends StatefulWidget {
  const CreateReviewScreen({super.key});

  @override
  State<CreateReviewScreen> createState() => _CreateReviewScreenState();
}

class _CreateReviewScreenState extends State<CreateReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _commentController = TextEditingController();
  final _findingsController = TextEditingController();
  final _recommendationsController = TextEditingController();

  int _rating = 0;
  ReviewType _reviewType = ReviewType.general;
  ReviewStatus _status = ReviewStatus.open;
  DateTime? _followUpDate;
  bool _isSubmitting = false;
  String? _selectedSite;

  final List<String> _sites = ['iremele', 'kibra', 'mishimboko', 'kimnojun'];

  @override
  void dispose() {
    _titleController.dispose();
    _commentController.dispose();
    _findingsController.dispose();
    _recommendationsController.dispose();
    super.dispose();
  }

  String get _ratingLabel => switch (_rating) {
        1 => 'Poor',
        2 => 'Fair',
        3 => 'Good',
        4 => 'Very Good',
        5 => 'Excellent',
        _ => 'Tap a star to rate',
      };

  Color _ratingColor(ColorScheme cs) => switch (_rating) {
        1 => cs.error,
        2 => cs.errorContainer,
        3 => cs.secondary,
        4 => cs.tertiary,
        5 => cs.primary,
        _ => cs.outline,
      };

  Future<void> _pickFollowUpDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
    if (picked != null) setState(() => _followUpDate = picked);
  }

  void _handleCreate() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedSite == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a site'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a rating'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Review "${_titleController.text.trim().isEmpty ? 'Untitled' : _titleController.text.trim()}" created!',
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      _handleCancel();
    });
  }

  void _handleCancel() {
    _titleController.clear();
    _commentController.clear();
    _findingsController.clear();
    _recommendationsController.clear();
    setState(() {
      _rating = 0;
      _reviewType = ReviewType.general;
      _status = ReviewStatus.open;
      _followUpDate = null;
      _selectedSite = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create Review',
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
                _buildLabel('Site', required: true),
                const SizedBox(height: 6),
                CustomDropdown<String>(
                  value: _selectedSite,
                  items: _sites,
                  displayMapper: (s) => s,
                  hint: 'Select site',
                  prefixIcon: const Icon(Icons.location_on_outlined, size: 18),
                  onChanged: (v) => setState(() => _selectedSite = v),
                ),
                const SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Review Type'),
                          const SizedBox(height: 6),
                          CustomDropdown<ReviewType>(
                            value: _reviewType,
                            items: ReviewType.values,
                            displayMapper: (t) => t.label,
                            hint: 'Type',
                            prefixIcon:
                                const Icon(Icons.category_outlined, size: 18),
                            onChanged: (v) =>
                                setState(() => _reviewType = v ?? _reviewType),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Status'),
                          const SizedBox(height: 6),
                          CustomDropdown<ReviewStatus>(
                            value: _status,
                            items: ReviewStatus.values,
                            displayMapper: (s) => s.label,
                            hint: 'Status',
                            prefixIcon:
                                const Icon(Icons.flag_outlined, size: 18),
                            onChanged: (v) =>
                                setState(() => _status = v ?? _status),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _buildLabel('Overall Rating', required: true),
                const SizedBox(height: 6),
                _buildRatingCard(context),
                const SizedBox(height: 18),
                _buildLabel('Title'),
                const SizedBox(height: 6),
                CustomTextInput(
                  controller: _titleController,
                  hintText: 'Brief summary of this review',
                  prefixIcon: Icons.title_outlined,
                ),
                const SizedBox(height: 18),
                _buildLabel('Comment', required: true),
                const SizedBox(height: 6),
                CustomTextInput(
                  controller: _commentController,
                  hintText: 'General observations and notes...',
                  prefixIcon: Icons.notes_outlined,
                  maxLines: 4,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Comment is required'
                      : null,
                ),
                const SizedBox(height: 18),
                _buildLabel('Findings'),
                const SizedBox(height: 2),
                Text(
                  'Detailed audit findings',
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
                const SizedBox(height: 6),
                CustomTextInput(
                  controller: _findingsController,
                  hintText: 'Document key findings from this review...',
                  prefixIcon: Icons.manage_search_outlined,
                  maxLines: 4,
                ),
                const SizedBox(height: 18),
                _buildLabel('Recommendations'),
                const SizedBox(height: 6),
                CustomTextInput(
                  controller: _recommendationsController,
                  hintText: 'Suggested actions and improvements...',
                  prefixIcon: Icons.lightbulb_outline,
                  maxLines: 4,
                ),
                const SizedBox(height: 18),
                _buildLabel('Follow-up Date'),
                const SizedBox(height: 6),
                _buildFollowUpDateCard(context),
                const SizedBox(height: 32),
                CustomButton(
                  label: 'Create Review',
                  onPressed: _handleCreate,
                  isLoading: _isSubmitting,
                  backgroundColor: Theme.of(context).colorScheme.onSurface,
                  textColor: Theme.of(context).colorScheme.surface,
                  width: double.infinity,
                  height: 50,
                  borderRadius: 12,
                ),
                const SizedBox(height: 10),
                CustomButton(
                  label: 'Cancel',
                  onPressed: _handleCancel,
                  buttonStyle: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    minimumSize: const Size(double.infinity, 46),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ]
            : [],
      ),
    );
  }

  Widget _buildRatingCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        border: Border.all(color: Colors.grey[300]!, width: 1.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) {
            final v = i + 1;
            final active = v <= _rating;
            return GestureDetector(
              onTap: () => setState(() => _rating = v),
              child: AnimatedScale(
                scale: active ? 1.12 : 1.0,
                duration: const Duration(milliseconds: 160),
                curve: Curves.elasticOut,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Icon(
                    active ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 38,
                    color: active ? Colors.amber : Colors.grey[300],
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          _ratingLabel,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _rating > 0 ? _ratingColor(cs) : Colors.grey[400],
          ),
        ),
      ]),
    );
  }

  Widget _buildFollowUpDateCard(BuildContext context) {
    final bool hasDate = _followUpDate != null;
    return GestureDetector(
      onTap: _pickFollowUpDate,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
          border: Border.all(color: Colors.grey[300]!, width: 1.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 18,
            color: hasDate ? Colors.black87 : Colors.grey[400],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: hasDate
                ? Text(
                    DateFormat('MMM dd, yyyy').format(_followUpDate!),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : Text(
                    'Set a follow-up date (optional)',
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  ),
          ),
          if (hasDate)
            GestureDetector(
              onTap: () => setState(() => _followUpDate = null),
              child: Icon(Icons.close, size: 16, color: Colors.grey[400]),
            )
          else
            Icon(Icons.chevron_right, size: 18, color: Colors.grey[400]),
        ]),
      ),
    );
  }
}
