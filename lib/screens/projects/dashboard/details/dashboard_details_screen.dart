import 'package:flutter/material.dart';
import 'package:graville_operations/models/dashboard/dashboard_model.dart';
import 'dart:math' as math;

class DashboardDetailsScreen extends StatefulWidget {
  final DashboardModel site;

  const DashboardDetailsScreen({super.key, required this.site});

  @override
  State<DashboardDetailsScreen> createState() => _DashboardDetailScreenState();
}

class _DashboardDetailScreenState extends State<DashboardDetailsScreen> {
  late String _activeDay;

  @override
  void initState() {
    super.initState();
    _activeDay = widget.site.dayLabels.first;
  }

  DashboardModel get s => widget.site;

  DailyRecord get _dayRecord =>
      s.dailyRecords[_activeDay] ??
      const DailyRecord(workerCount: 0, workers: []);

  GalleryDay? get _galleryDay =>
      s.gallery.firstWhere((g) => g.dayLabel == _activeDay,
          orElse: () => const GalleryDay(dayLabel: '', photoLabels: []));

  Color get _statusColor {
    switch (s.status) {
      case 'Completed':
        return const Color(0xFF1A9E5C);
      case 'Paused':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFFD97706);
    }
  }

  @override
  Widget build(BuildContext context) {
    final record = _dayRecord;
    final gallery = _galleryDay;
    final taskRate = s.taskCompletionRate;
    final attendanceRate = s.totalWorkers == 0
        ? 0
        : ((record.workerCount / s.totalWorkers) * 100).round();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F3EF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F3EF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 18, color: Color(0xFF1A5CFF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Site Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F1117),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        s.name,
                        style: const TextStyle(
                          color: const Color(0xFF0F1117),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.black.withOpacity(0.1)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        s.status,
                        style: TextStyle(
                          color: _statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _HeroMeta(icon: Icons.location_on_outlined, text: s.location),
                const SizedBox(height: 4),
                _HeroMeta(
                    icon: Icons.business_outlined, text: s.procuringEntity),
                const SizedBox(height: 4),
                _HeroMeta(
                    icon: Icons.calendar_today_outlined,
                    text: 'Started ${s.startDate}  ·  Deadline ${s.deadline}'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Contract Value',
                            style: TextStyle(
                                color: const Color(0xFF7A7E8E),
                                fontSize: 10,
                                letterSpacing: 0.5)),
                        const SizedBox(height: 4),
                        Text(
                          'KES ${_fmt(s.totalAmount)}',
                          style: const TextStyle(
                              color: const Color(0xFF0F1117),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.black.withOpacity(0.1)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(s.type,
                          style: const TextStyle(
                              color: const Color(0xFF7A7E8E), fontSize: 11)),
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
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
            children: [
              _StatCard(
                  label: 'Total Workers',
                  value: '${s.totalWorkers}',
                  sub: 'Overall headcount',
                  valueColor: const Color(0xFF1A5CFF)),
              _StatCard(
                  label: 'Completion Rate',
                  value: '${s.progress}%',
                  sub: 'Overall progress',
                  valueColor: s.progress >= 80
                      ? const Color(0xFF1A9E5C)
                      : s.progress >= 40
                          ? const Color(0xFFD97706)
                          : const Color(0xFFDC2626)),
              _StatCard(
                  label: 'Tasks Completed',
                  value: '$taskRate%',
                  sub: '${s.completedTasks} of ${s.tasks.length} tasks',
                  valueColor: const Color(0xFF0F1117)),
              _StatCard(
                  label: 'Contract Value',
                  value: 'KES ${_fmtShort(s.totalAmount)}',
                  sub: 'Total budget',
                  valueColor: const Color(0xFF0F1117)),
            ],
          ),

          const SizedBox(height: 24),
          _SectionHeader(title: 'Completion Metrics'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: _RingCard(
                      label: 'Overall',
                      sub: 'Completion',
                      percent: s.progress,
                      color: const Color(0xFF1A5CFF))),
              const SizedBox(width: 12),
              Expanded(
                  child: _RingCard(
                      label: 'Tasks',
                      sub: '${s.completedTasks}/${s.tasks.length} done',
                      percent: taskRate,
                      color: const Color(0xFF1A9E5C))),
              const SizedBox(width: 12),
              Expanded(
                  child: _RingCard(
                      label: 'Attendance',
                      sub: '${record.workerCount} today',
                      percent: attendanceRate,
                      color: const Color(0xFFD97706))),
            ],
          ),

          const SizedBox(height: 24),
          _SectionHeader(title: 'Task Breakdown'),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.black.withOpacity(0.07)),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              children: s.tasks.asMap().entries.map((e) {
                final i = e.key;
                final t = e.value;
                final barColor = t.percent == 100
                    ? const Color(0xFF1A9E5C)
                    : t.percent < 40
                        ? const Color(0xFFD97706)
                        : const Color(0xFF1A5CFF);
                return Column(
                  children: [
                    if (i != 0)
                      const Divider(height: 16, color: Color(0x0A000000)),
                    Row(
                      children: [
                        Expanded(
                          child: Text(t.name,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF0F1117))),
                        ),
                        const SizedBox(width: 8),
                        Text('${t.percent}%',
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF7A7E8E))),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: t.percent / 100,
                        minHeight: 5,
                        backgroundColor: Colors.black.withOpacity(0.06),
                        valueColor: AlwaysStoppedAnimation<Color>(barColor),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),
          _SectionHeader(
              title: 'Workers on Site', sub: 'Tap a day to view attendance'),
          const SizedBox(height: 10),

          // Day strip
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: s.dayLabels.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final day = s.dayLabels[i];
                final active = day == _activeDay;
                final parts = day.split(' ');
                return GestureDetector(
                  onTap: () => setState(() => _activeDay = day),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? const Color(0xFF1A5CFF) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: active
                            ? const Color(0xFF1A5CFF)
                            : Colors.black.withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(parts[0],
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: active
                                    ? Colors.white
                                    : const Color(0xFF0F1117))),
                        Text(parts.length > 1 ? parts[1] : '',
                            style: TextStyle(
                                fontSize: 10,
                                color: active
                                    ? Colors.white60
                                    : const Color(0xFF7A7E8E))),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Worker counts
          Row(
            children: [
              Expanded(
                  child: _StatCard(
                      label: 'Total (All Time)',
                      value: '${s.totalWorkers}',
                      sub: 'Registered workers',
                      valueColor: const Color(0xFF1A5CFF))),
              const SizedBox(width: 12),
              Expanded(
                  child: _StatCard(
                      label: 'Present — $_activeDay',
                      value: '${record.workerCount}',
                      sub: 'On site today',
                      valueColor: const Color(0xFFD97706))),
            ],
          ),
          const SizedBox(height: 12),

          // Workers table
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.black.withOpacity(0.07)),
            ),
            child: record.workers.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                        child: Text('No worker records for this day.',
                            style: TextStyle(
                                color: Color(0xFF7A7E8E), fontSize: 13))),
                  )
                : Column(
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF9F8F5),
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(14)),
                        ),
                        child: const Row(
                          children: [
                            SizedBox(
                                width: 28,
                                child: Text('#',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF7A7E8E),
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5))),
                            Expanded(
                                child: Text('NAME',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF7A7E8E),
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5))),
                            SizedBox(
                                width: 90,
                                child: Text('ROLE',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF7A7E8E),
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5))),
                            SizedBox(
                                width: 40,
                                child: Text('HRS',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF7A7E8E),
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5))),
                          ],
                        ),
                      ),
                      ...record.workers.asMap().entries.map((e) {
                        final i = e.key;
                        final w = e.value;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: Colors.black.withOpacity(0.04))),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 28,
                                child: Text('${i + 1}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF7A7E8E))),
                              ),
                              Expanded(
                                child: Text(w.name,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF0F1117))),
                              ),
                              SizedBox(
                                width: 90,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8EEFF),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    w.role,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1A5CFF)),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 40,
                                child: Text('${w.hours}h',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'monospace',
                                        color: Color(0xFF3A3D4A))),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
          ),

          const SizedBox(height: 24),

          // ── Reports ───────────────────────────────────────────
          _SectionHeader(title: 'Reports'),
          const SizedBox(height: 10),
          ...s.reports.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ReportItem(report: r),
              )),

          const SizedBox(height: 24),

          // ── Gallery ───────────────────────────────────────────
          _SectionHeader(title: 'Photo Gallery', sub: 'Site photos by day'),
          const SizedBox(height: 10),

          // Gallery day strip
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: s.dayLabels.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final day = s.dayLabels[i];
                final active = day == _activeDay;
                final parts = day.split(' ');
                return GestureDetector(
                  onTap: () => setState(() => _activeDay = day),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? const Color(0xFF1A5CFF) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: active
                            ? const Color(0xFF1A5CFF)
                            : Colors.black.withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(parts[0],
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: active
                                    ? Colors.white
                                    : const Color(0xFF0F1117))),
                        Text(parts.length > 1 ? parts[1] : '',
                            style: TextStyle(
                                fontSize: 10,
                                color: active
                                    ? Colors.white60
                                    : const Color(0xFF7A7E8E))),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          if (gallery != null && gallery.photoLabels.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: gallery.photoLabels.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, i) {
                final emojis = [
                  '🏗️',
                  '🔩',
                  '🧱',
                  '⚙️',
                  '🪜',
                  '🏛️',
                  '🔧',
                  '📐'
                ];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black.withOpacity(0.07)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(emojis[i % emojis.length],
                          style: const TextStyle(fontSize: 24)),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          gallery.photoLabels[i],
                          style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF7A7E8E),
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          else
            const Center(
                child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('No photos for this day.',
                  style: TextStyle(color: Color(0xFF7A7E8E), fontSize: 13)),
            )),
        ],
      ),
    );
  }

  String _fmt(double v) => v.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');

  String _fmtShort(double v) {
    if (v >= 1e9) return '${(v / 1e9).toStringAsFixed(1)}B';
    if (v >= 1e6) return '${(v / 1e6).toStringAsFixed(0)}M';
    return _fmt(v);
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? sub;

  const _SectionHeader({required this.title, this.sub});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F1117),
                letterSpacing: -0.2)),
        if (sub != null) ...[
          const SizedBox(width: 8),
          Text(sub!,
              style: const TextStyle(fontSize: 12, color: Color(0xFF7A7E8E))),
        ]
      ],
    );
  }
}

class _HeroMeta extends StatelessWidget {
  final IconData icon;
  final String text;

  const _HeroMeta({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: const Color(0xFF7A7E8E)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(text,
              style: const TextStyle(
                  fontSize: 12,
                  color: const Color(0xFF3A3D4A),
                  overflow: TextOverflow.ellipsis)),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final Color valueColor;

  const _StatCard(
      {required this.label,
      required this.value,
      required this.sub,
      required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF7A7E8E),
                  letterSpacing: 0.4,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: valueColor,
                  letterSpacing: -0.4),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(sub,
              style: const TextStyle(fontSize: 11, color: Color(0xFF7A7E8E))),
        ],
      ),
    );
  }
}

class _RingCard extends StatelessWidget {
  final String label;
  final String sub;
  final int percent;
  final Color color;

  const _RingCard(
      {required this.label,
      required this.sub,
      required this.percent,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withOpacity(0.07)),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: CustomPaint(
              painter: _RingPainter(percent: percent / 100, color: color),
              child: Center(
                child: Text(
                  '$percent%',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700, color: color),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F1117)),
              textAlign: TextAlign.center),
          const SizedBox(height: 2),
          Text(sub,
              style: const TextStyle(fontSize: 10, color: Color(0xFF7A7E8E)),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double percent;
  final Color color;

  const _RingPainter({required this.percent, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 6;
    final strokeWidth = 8.0;

    // Track
    canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = Colors.black.withOpacity(0.07)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth);

    // Fill
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * percent,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.percent != percent || old.color != color;
}

class _ReportItem extends StatelessWidget {
  final ReportItem report;

  const _ReportItem({required this.report});

  Color get _typeColor {
    switch (report.type) {
      case 'weekly':
        return const Color(0xFF1A9E5C);
      case 'incident':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF1A5CFF);
    }
  }

  Color get _typeBg {
    switch (report.type) {
      case 'weekly':
        return const Color(0xFFE3F7ED);
      case 'incident':
        return const Color(0xFFFEE2E2);
      default:
        return const Color(0xFFE8EEFF);
    }
  }

  String get _typeLabel {
    switch (report.type) {
      case 'weekly':
        return 'Weekly';
      case 'incident':
        return 'Incident';
      default:
        return 'Daily';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.07)),
      ),
      child: Row(
        children: [
          const Icon(Icons.description_outlined,
              size: 18, color: Color(0xFF7A7E8E)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(report.name,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0F1117))),
                const SizedBox(height: 2),
                Text(report.date,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF7A7E8E))),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
                color: _typeBg, borderRadius: BorderRadius.circular(20)),
            child: Text(_typeLabel,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _typeColor)),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.download_outlined,
                size: 18, color: Color(0xFF7A7E8E)),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
