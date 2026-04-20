import 'package:flutter/material.dart';
import 'package:graville_operations/application/custom_navigator.dart';
import 'package:graville_operations/core/commons/widgets/day_chip.dart';
import 'package:graville_operations/core/commons/widgets/stat_card.dart';
import 'package:graville_operations/core/commons/widgets/worker_preview_card.dart';
import 'package:graville_operations/screens/workers/all_workers_screen.dart'; 
import 'package:graville_operations/screens/workers/present_workers_screen.dart';
import 'package:graville_operations/services/attendance_service.dart';
import 'package:intl/intl.dart';

class WorkersOnSiteSection extends StatefulWidget {
  final int totalWorkers;

  const WorkersOnSiteSection({super.key, required this.totalWorkers});

  @override
  State<WorkersOnSiteSection> createState() => _WorkersOnSiteSectionState();
}

class _WorkersOnSiteSectionState extends State<WorkersOnSiteSection> {
  WeekAttendance? _week;
  bool _loading = true;
  String? _error;
  late int _activeDayIndex;

  @override
  void initState() {
    super.initState();
    _activeDayIndex = DateTime.now().weekday % 7; 
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final week = await AttendanceService.fetchWeekAttendance();
      if (mounted) setState(() { _week = week; _loading = false; });
    } on AttendanceServiceException catch (e) {
      if (mounted) setState(() { _error = e.message; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (_error != null) {
      return Center(
        child: Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
      );
    }
    if (_week == null) return const SizedBox.shrink();

    final day   = _week!.days[_activeDayIndex];
    final label = DateFormat('EEE d').format(day.date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SizedBox(
          height: 56,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _week!.days.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) => DayChip(
              date: _week!.days[i].date,
              isActive: i == _activeDayIndex,
              onTap: () => setState(() => _activeDayIndex = i),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => context.push(const AllWorkersScreen()),
                child: StatCard(
                  icon: Icons.people_rounded,
                  title: 'Total (All Time)',
                  value: '${widget.totalWorkers}',
                  color: const Color(0xFF1A5CFF),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => context.push(const PresentWorkersScreen()),
                child: StatCard(
                  icon: Icons.how_to_reg_rounded,
                  title: 'Present — $label',
                  value: '${day.presentCount}',
                  color: const Color(0xFFD97706),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black.withOpacity(0.07)),
          ),
          child: day.workers.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'No worker records for this day.',
                      style: TextStyle(color: Color(0xFF7A7E8E), fontSize: 13),
                    ),
                  ),
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF9F8F5),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                      ),
                      child: const Row(
                        children: [
                          SizedBox(width: 28, child: Text('#', style: _hStyle)),
                          Expanded(child: Text('NAME', style: _hStyle)),
                          SizedBox(width: 90, child: Text('ROLE', style: _hStyle)),
                        ],
                      ),
                    ),
                    ...day.workers.asMap().entries.map((e) => Column(
                      children: [
                        if (e.key > 0)
                          Divider(height: 1, color: Colors.black.withOpacity(0.04)),
                        WorkerPreviewCard(index: e.key, worker: e.value),
                      ],
                    )),
                    if (day.presentCount > 5)
                      InkWell(
                        onTap: () => context.push(const PresentWorkersScreen()),
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Colors.black.withOpacity(0.06)),
                            ),
                          ),
                          child: const Text(
                            'See all →',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF1A5CFF),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

const _hStyle = TextStyle(
  fontSize: 11,
  color: Color(0xFF7A7E8E),
  fontWeight: FontWeight.w600,
  letterSpacing: 0.5,
);