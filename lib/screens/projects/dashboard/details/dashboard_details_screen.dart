import 'package:flutter/material.dart';
import 'package:graville_operations/core/commons/widgets/workers_on_site_section.dart';
import 'package:graville_operations/core/remote/api/task_api.dart';
import 'package:graville_operations/core/remote/dto/response/create_task.dart';
import 'package:graville_operations/models/dashboard/dashboard_model.dart';
import 'package:graville_operations/models/site/site_model.dart';
import 'package:graville_operations/screens/task_screen/alltasks.dart';
import 'package:graville_operations/screens/task_screen/task_details.dart';
import 'package:graville_operations/services/attendance_service.dart';
import 'package:graville_operations/services/worker_service.dart';
import 'dart:math' as math;

class DashboardDetailsScreen extends StatefulWidget {
  final SiteModel site;
  const DashboardDetailsScreen({super.key, required this.site});

  @override
  State<DashboardDetailsScreen> createState() => _DashboardDetailScreenState();
}

class _DashboardDetailScreenState extends State<DashboardDetailsScreen> {
  late String _activeDay;
  int _totalWorkers  = 0;
  int _attendancePct = 0;
  bool _liveLoading  = true;

  List<TaskResponse> _tasks = [];
bool _tasksLoading = true;

  @override
void initState() {
  super.initState();
  _loadLiveStats();
  _loadTasks(); // ← add
}


  Future<void> _loadLiveStats() async {
    try {
      final results = await Future.wait([
        WorkerService.fetchWorkers(),
        AttendanceService.fetchWeekAttendance(),
      ]);
      if (!mounted) return;
      final total   = (results[0] as List).length;
      final week    = results[1] as WeekAttendance;
      final presented = week.days.fold<int>(0, (sum, d) => sum + d.presentCount);
      final pct = total == 0 ? 0 : ((presented / (total * 7)) * 100).round();
      setState(() {
        _totalWorkers  = total;
        _attendancePct = pct.clamp(0, 100);
        _liveLoading   = false;
      });
    } catch (_) {
      if (mounted) setState(() => _liveLoading = false);
    }
  }

  Future<void> _loadTasks() async {
  try {
    final tasks = await TaskApi.getAllTasks();
    if (!mounted) return;
    setState(() { _tasks = tasks; _tasksLoading = false; });
  } catch (_) {
    if (mounted) setState(() => _tasksLoading = false);
  }
}

double get _taskCompletionRate {
  if (_tasks.isEmpty) return 0;
  return _tasks.fold<int>(0, (sum, t) => sum + t.completion) / _tasks.length;
}

int get _completedTasksCount =>
    _tasks.where((t) => t.completion >= 100).length;

  SiteModel get s => widget.site;

  // GalleryDay? get _galleryDay => s.gallery.firstWhere(
  //     (g) => g.dayLabel == _activeDay,
  //     orElse: () => const GalleryDay(dayLabel: '', photoLabels: []));

  Color get _statusColor => switch (s.projectStatus) {
    'Completed' => const Color(0xFF1A9E5C),
    'Delayed'    => const Color(0xFFDC2626),
    _           => const Color(0xFFD97706),
  };

  @override
  Widget build(BuildContext context) {
    // final taskRate = s.taskCompletionRate;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F3EF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F3EF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF1A5CFF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Site Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF0F1117))),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: [

          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text(s.name,
                        style: const TextStyle(color: Color(0xFF0F1117), fontSize: 18,
                            fontWeight: FontWeight.w700, letterSpacing: -0.4))),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black.withOpacity(0.1)),
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(s.projectStatus,
                          style: TextStyle(color: _statusColor, fontSize: 11, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _HeroMeta(icon: Icons.location_on_outlined,   text: s.location),
                const SizedBox(height: 4),
                _HeroMeta(icon: Icons.business_outlined,      text: s.inquiringEntity??"None"),
                const SizedBox(height: 4),
                _HeroMeta(icon: Icons.calendar_today_outlined,
                    text: 'Started ${s.createdAt}  ·  Deadline ${s.completionDate}'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Total Contract Value',
                          style: TextStyle(color: Color(0xFF7A7E8E), fontSize: 10, letterSpacing: 0.5)),
                      const SizedBox(height: 4),
                      // Text('KES ${_fmt(s.totalAmount)}',
                      Text('KES N/A',
                          style: const TextStyle(color: Color(0xFF0F1117), fontSize: 20,
                              fontWeight: FontWeight.w700, letterSpacing: -0.5)),
                    ]),
                    if (s.tags.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black.withOpacity(0.1)),
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(s.tags[0],
                          style: const TextStyle(color: Color(0xFF7A7E8E), fontSize: 11)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _SectionHeader(title: 'Project Overview'),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2, shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 2.2,
            children: [
              _StatCard(
                  label: 'Total Workers',
                  value: _liveLoading ? '…' : '$_totalWorkers',
                  sub: 'Overall headcount',
                  valueColor: const Color(0xFF1A5CFF)),
              _StatCard(
                      label: 'Completion Rate',
                      value: _tasksLoading ? '…' : '${_taskCompletionRate.round()}%',
                      sub: 'Overall progress',
                      valueColor: const Color(0xFFDC2626),
                  ),
               _StatCard(
                      label: 'Tasks Completed',
                      value: _tasksLoading ? '…' : '$_completedTasksCount',
                      sub: _tasksLoading ? '…' : '$_completedTasksCount of ${_tasks.length} tasks',
                      valueColor: const Color(0xFF0F1117)),
              _StatCard(
                  // label: 'Contract Value', value: 'KES ${_fmtShort(s.totalAmount)}',
                  label: 'Contract Value', value: 'KES 26M',
                  sub: 'Total budget', valueColor: const Color(0xFF0F1117)),
            ],
          ),

          const SizedBox(height: 24),
          _SectionHeader(title: 'Completion Metrics'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _RingCard(
                label: 'Overall', sub: 'Completion',
                percent: _tasksLoading ? 0 : _taskCompletionRate.round(),
                color: const Color(0xFF1A5CFF))),
                  // percent: s.progress, color: const Color(0xFF1A5CFF))),
              const SizedBox(width: 12),
              Expanded(child: _RingCard(
                label: 'Tasks',
                sub: _tasksLoading ? '…' : '$_completedTasksCount/${_tasks.length} done',
                percent: _tasksLoading ? 0 : _taskCompletionRate.round(),
                color: const Color(0xFF1A9E5C))),
              const SizedBox(width: 12),
              Expanded(child: _RingCard(
                  label: 'Attendance',
                  sub: _liveLoading ? 'Loading…' : 'Weekly avg',
                  percent: _liveLoading ? 0 : _attendancePct,
                  color: const Color(0xFFD97706))),
            ],
          ),

          const SizedBox(height: 24),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _SectionHeader(title: 'Task Breakdown'),
                      if (!_tasksLoading && _tasks.length > 5)
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const AllTasksScreen()),
                          ).then((_) => _loadTasks()),
                          child: const Text("View All",
                              style: TextStyle(color: Color(0xFF1A5CFF),
                                  fontSize: 12, fontWeight: FontWeight.w600)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (_tasksLoading)
                    const Center(child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(color: Color(0xFF1A5CFF)),
                    ))
                  else if (_tasks.isEmpty)
                    const Center(child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('No tasks yet',
                          style: TextStyle(color: Color(0xFF7A7E8E))),
                    ))
                  else
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.black.withOpacity(0.07)),
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        children: _tasks.take(5).toList().asMap().entries.map((e) {
                          final i = e.key;
                          final t = e.value;
                          final barColor = t.completion >= 100
                              ? const Color(0xFF1A9E5C)
                              : t.completion >= 60
                                  ? const Color(0xFFD97706)
                                  : const Color(0xFF1A5CFF);
                          return Column(children: [
                            if (i != 0)
                              const Divider(height: 16, color: Color(0x0A000000)),
                            GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => TaskDetailScreen(task: t)),
                              ),
                              child: Row(children: [
                                Expanded(child: Text(t.title,
                                    style: const TextStyle(fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF0F1117)))),
                                const SizedBox(width: 8),
                                Text('${t.completion}%',
                                    style: TextStyle(fontSize: 12,
                                        fontWeight: FontWeight.w600, color: barColor)),
                                const Icon(Icons.chevron_right,
                                    size: 14, color: Color(0xFF7A7E8E)),
                              ]),
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: t.completion / 100,
                                minHeight: 5,
                                backgroundColor: Colors.black.withOpacity(0.06),
                                valueColor: AlwaysStoppedAnimation<Color>(barColor),
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),

          const SizedBox(height: 24),

          _SectionHeader(title: 'Workers on Site', sub: 'Tap a day to view attendance'),
          const SizedBox(height: 10),
          const WorkersOnSiteSection(),

          const SizedBox(height: 24),

          _SectionHeader(title: 'Reports'),
          // const SizedBox(height: 10),
          // ...s.reports.map((r) => Padding(
          //   padding: const EdgeInsets.only(bottom: 10),
          //   child: _ReportItem(report: r),
          // )),

          const SizedBox(height: 24),

          // _SectionHeader(title: 'Photo Gallery', sub: 'Site photos by day'),
          // const SizedBox(height: 10),
          // SizedBox(
          //   height: 56,
          //   child: ListView.separated(
          //     scrollDirection: Axis.horizontal,
          //     itemCount: s.dayLabels.length,
          //     separatorBuilder: (_, __) => const SizedBox(width: 8),
          //     itemBuilder: (context, i) {
          //       final day    = s.dayLabels[i];
          //       final active = day == _activeDay;
          //       final parts  = day.split(' ');
          //       return GestureDetector(
          //         onTap: () => setState(() => _activeDay = day),
          //         child: AnimatedContainer(
          //           duration: const Duration(milliseconds: 180),
          //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          //           decoration: BoxDecoration(
          //             color: active ? const Color(0xFF1A5CFF) : Colors.white,
          //             borderRadius: BorderRadius.circular(20),
          //             border: Border.all(color: active
          //                 ? const Color(0xFF1A5CFF) : Colors.black.withOpacity(0.1)),
          //           ),
          //           child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          //             Text(parts[0], style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
          //                 color: active ? Colors.white : const Color(0xFF0F1117))),
          //             Text(parts.length > 1 ? parts[1] : '', style: TextStyle(fontSize: 10,
          //                 color: active ? Colors.white60 : const Color(0xFF7A7E8E))),
          //           ]),
          //         ),
          //       );
          //     },
          //   ),
          // ),
          // const SizedBox(height: 12),
          // Builder(builder: (_) {
          //   final gallery = _galleryDay;
          //   if (gallery == null || gallery.photoLabels.isEmpty) {
          //     return const Center(child: Padding(padding: EdgeInsets.all(24),
          //         child: Text('No photos for this day.',
          //             style: TextStyle(color: Color(0xFF7A7E8E), fontSize: 13))));
          //   }
          //   return GridView.builder(
          //     shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          //     itemCount: gallery.photoLabels.length,
          //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //         crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.2),
          //     itemBuilder: (context, i) {
          //       const emojis = ['🏗️','🔩','🧱','⚙️','🪜','🏛️','🔧','📐'];
          //       return Container(
          //         decoration: BoxDecoration(color: Colors.white,
          //             borderRadius: BorderRadius.circular(10),
          //             border: Border.all(color: Colors.black.withOpacity(0.07))),
          //         child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          //           Text(emojis[i % emojis.length], style: const TextStyle(fontSize: 24)),
          //           const SizedBox(height: 4),
          //           Padding(padding: const EdgeInsets.symmetric(horizontal: 6),
          //             child: Text(gallery.photoLabels[i],
          //                 style: const TextStyle(fontSize: 10, color: Color(0xFF7A7E8E),
          //                     fontWeight: FontWeight.w500),
          //                 textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis)),
          //         ]),
          //       );
          //     },
          //   );
          // }),
        ],
      ),
    );
  }

  String _fmt(double v) => v.toStringAsFixed(0)
      .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  String _fmtShort(double v) {
    if (v >= 1e9) return '${(v / 1e9).toStringAsFixed(1)}B';
    if (v >= 1e6) return '${(v / 1e6).toStringAsFixed(0)}M';
    return _fmt(v);
  }
}


class _SectionHeader extends StatelessWidget {
  final String title; final String? sub;
  const _SectionHeader({required this.title, this.sub});
  @override
  Widget build(BuildContext context) => Row(children: [
    Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
        color: Color(0xFF0F1117), letterSpacing: -0.2)),
    if (sub != null) ...[const SizedBox(width: 8),
      Text(sub!, style: const TextStyle(fontSize: 12, color: Color(0xFF7A7E8E)))],
  ]);
}

class _HeroMeta extends StatelessWidget {
  final IconData icon; final String text;
  const _HeroMeta({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(icon, size: 13, color: const Color(0xFF7A7E8E)), const SizedBox(width: 6),
    Expanded(child: Text(text, style: const TextStyle(fontSize: 12,
        color: Color(0xFF3A3D4A), overflow: TextOverflow.ellipsis))),
  ]);
}

class _StatCard extends StatelessWidget {
  final String label, value, sub; final Color valueColor;
  const _StatCard({required this.label, required this.value, required this.sub, required this.valueColor});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.07))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF7A7E8E),
          letterSpacing: 0.4, fontWeight: FontWeight.w500)),
      const SizedBox(height: 4),
      Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,
          color: valueColor, letterSpacing: -0.4), maxLines: 1, overflow: TextOverflow.ellipsis),
      const SizedBox(height: 2),
      Text(sub, style: const TextStyle(fontSize: 11, color: Color(0xFF7A7E8E))),
    ]),
  );
}

class _RingCard extends StatelessWidget {
  final String label, sub; final int percent; final Color color;
  const _RingCard({required this.label, required this.sub, required this.percent, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withOpacity(0.07))),
    child: Column(children: [
      SizedBox(width: 72, height: 72,
        child: CustomPaint(painter: _RingPainter(percent: percent / 100, color: color),
          child: Center(child: Text('$percent%', style: TextStyle(fontSize: 14,
              fontWeight: FontWeight.w700, color: color))))),
      const SizedBox(height: 8),
      Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
          color: Color(0xFF0F1117)), textAlign: TextAlign.center),
      const SizedBox(height: 2),
      Text(sub, style: const TextStyle(fontSize: 10, color: Color(0xFF7A7E8E)),
          textAlign: TextAlign.center),
    ]),
  );
}

class _RingPainter extends CustomPainter {
  final double percent; final Color color;
  const _RingPainter({required this.percent, required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 6;
    canvas.drawCircle(center, radius, Paint()
      ..color = Colors.black.withOpacity(0.07)
      ..style = PaintingStyle.stroke ..strokeWidth = 8);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, 2 * math.pi * percent, false,
      Paint()..color = color ..style = PaintingStyle.stroke
        ..strokeWidth = 8 ..strokeCap = StrokeCap.round);
  }
  @override
  bool shouldRepaint(_RingPainter old) => old.percent != percent || old.color != color;
}

class _ReportItem extends StatelessWidget {
  final ReportItem report;
  const _ReportItem({required this.report});
  Color get _typeColor => switch (report.type) {
    'weekly' => const Color(0xFF1A9E5C), 'incident' => const Color(0xFFDC2626), _ => const Color(0xFF1A5CFF) };
  Color get _typeBg => switch (report.type) {
    'weekly' => const Color(0xFFE3F7ED), 'incident' => const Color(0xFFFEE2E2), _ => const Color(0xFFE8EEFF) };
  String get _typeLabel => switch (report.type) {
    'weekly' => 'Weekly', 'incident' => 'Incident', _ => 'Daily' };
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.07))),
    child: Row(children: [
      const Icon(Icons.description_outlined, size: 18, color: Color(0xFF7A7E8E)),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(report.name, style: const TextStyle(fontSize: 13,
            fontWeight: FontWeight.w500, color: Color(0xFF0F1117))),
        const SizedBox(height: 2),
        Text(report.date, style: const TextStyle(fontSize: 11, color: Color(0xFF7A7E8E))),
      ])),
      const SizedBox(width: 8),
      Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(color: _typeBg, borderRadius: BorderRadius.circular(20)),
          child: Text(_typeLabel, style: TextStyle(fontSize: 10,
              fontWeight: FontWeight.w700, color: _typeColor))),
      const SizedBox(width: 8),
      IconButton(icon: const Icon(Icons.download_outlined, size: 18, color: Color(0xFF7A7E8E)),
          onPressed: () {}, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
    ]),
  );
}