class WorkerEntry {
  final String name;
  final String role;
  final int hours;
  const WorkerEntry(
      {required this.name, required this.role, required this.hours});
}

class DailyRecord {
  final int workerCount;
  final List<WorkerEntry> workers;
  const DailyRecord({required this.workerCount, required this.workers});
}

class TaskItem {
  final String name;
  final int percent; // 0-100
  const TaskItem({required this.name, required this.percent});
}

class ReportItem {
  final String name;
  final String date;
  final String type;
  const ReportItem(
      {required this.name, required this.date, required this.type});
}

class GalleryDay {
  final String dayLabel;
  final List<String> photoLabels;
  const GalleryDay({required this.dayLabel, required this.photoLabels});
}

class DashboardModel {
  final int id;
  final String name;
  final String location;
  final String status;
  final int progress;
  final String type;
  final String deadline;
  final String procuringEntity;
  final double totalAmount;
  final int totalWorkers;
  final String startDate;
  final List<String> dayLabels;
  final Map<String, DailyRecord> dailyRecords;
  final List<TaskItem> tasks;
  final List<ReportItem> reports;
  final List<GalleryDay> gallery;

  const DashboardModel({
    required this.id,
    required this.name,
    required this.location,
    required this.status,
    required this.progress,
    required this.type,
    required this.deadline,
    required this.procuringEntity,
    required this.totalAmount,
    required this.totalWorkers,
    required this.startDate,
    required this.dayLabels,
    required this.dailyRecords,
    required this.tasks,
    required this.reports,
    required this.gallery,
  });

  int get completedTasks => tasks.where((t) => t.percent == 100).length;
  int get taskCompletionRate =>
      tasks.isEmpty ? 0 : ((completedTasks / tasks.length) * 100).round();
}

final List<DashboardModel> sampleDashboards = [
  DashboardModel(
    id: 1,
    name: 'DCC Kibra',
    location: 'Nairobi, Kenya',
    status: 'Ongoing',
    progress: 65,
    type: 'Commercial',
    deadline: 'Dec 2025',
    procuringEntity: 'NDCDF - Kibra Constituency',
    totalAmount: 26000000,
    totalWorkers: 67,
    startDate: 'Jan 2024',
    dayLabels: ['Mon 30', 'Tue 01', 'Wed 02', 'Thu 03', 'Fri 04'],
    dailyRecords: {
      'Mon 30': const DailyRecord(workerCount: 42, workers: [
        WorkerEntry(name: 'James Otieno', role: 'Foreman', hours: 9),
        WorkerEntry(name: 'Grace Wanjiku', role: 'Engineer', hours: 8),
        WorkerEntry(name: 'Peter Kamau', role: 'Mason', hours: 8),
        WorkerEntry(name: 'Faith Achieng', role: 'Electrician', hours: 7),
        WorkerEntry(name: 'Brian Mwangi', role: 'Plumber', hours: 8),
      ]),
      'Tue 01': const DailyRecord(workerCount: 38, workers: [
        WorkerEntry(name: 'James Otieno', role: 'Foreman', hours: 8),
        WorkerEntry(name: 'Grace Wanjiku', role: 'Engineer', hours: 9),
        WorkerEntry(name: 'Samuel Kipchoge', role: 'Mason', hours: 7),
        WorkerEntry(name: 'Lucy Njeri', role: 'Painter', hours: 8),
      ]),
      'Wed 02': const DailyRecord(workerCount: 51, workers: [
        WorkerEntry(name: 'James Otieno', role: 'Foreman', hours: 10),
        WorkerEntry(name: 'Grace Wanjiku', role: 'Engineer', hours: 8),
        WorkerEntry(name: 'Peter Kamau', role: 'Mason', hours: 9),
        WorkerEntry(name: 'Tony Odhiambo', role: 'Welder', hours: 8),
        WorkerEntry(name: 'Rose Auma', role: 'Painter', hours: 7),
      ]),
      'Thu 03': const DailyRecord(workerCount: 35, workers: [
        WorkerEntry(name: 'Grace Wanjiku', role: 'Engineer', hours: 9),
        WorkerEntry(name: 'Samuel Kipchoge', role: 'Mason', hours: 8),
        WorkerEntry(name: 'Brian Mwangi', role: 'Plumber', hours: 9),
      ]),
      'Fri 04': const DailyRecord(workerCount: 44, workers: [
        WorkerEntry(name: 'James Otieno', role: 'Foreman', hours: 9),
        WorkerEntry(name: 'Peter Kamau', role: 'Mason', hours: 8),
        WorkerEntry(name: 'Faith Achieng', role: 'Electrician', hours: 8),
        WorkerEntry(name: 'Tony Odhiambo', role: 'Welder', hours: 7),
      ]),
    },
    tasks: const [
      TaskItem(name: 'Foundation & Substructure', percent: 100),
      TaskItem(name: 'Structural Steelwork', percent: 88),
      TaskItem(name: 'Concrete Floors', percent: 72),
      TaskItem(name: 'MEP Rough-in', percent: 55),
      TaskItem(name: 'Exterior Cladding', percent: 30),
      TaskItem(name: 'Interior Finishes', percent: 10),
    ],
    reports: const [
      ReportItem(
          name: 'Daily Progress Report — Week 12',
          date: '04 Apr 2025',
          type: 'daily'),
      ReportItem(
          name: 'Weekly Summary Report', date: '28 Mar 2025', type: 'weekly'),
      ReportItem(
          name: 'Daily Progress Report — Week 11',
          date: '21 Mar 2025',
          type: 'daily'),
    ],
    gallery: const [
      GalleryDay(dayLabel: 'Mon 30', photoLabels: [
        'Foundation pour',
        'Steel cage install',
        'Site overview',
        'Equipment arrival'
      ]),
      GalleryDay(
          dayLabel: 'Tue 01',
          photoLabels: ['Column formwork', 'Rebar inspection', 'Crane ops']),
      GalleryDay(dayLabel: 'Wed 02', photoLabels: [
        'Concrete deck',
        'Exterior frame',
        'Welding detail',
        'Progress aerial'
      ]),
      GalleryDay(
          dayLabel: 'Thu 03', photoLabels: ['Interior walls', 'MEP rough-in']),
      GalleryDay(
          dayLabel: 'Fri 04',
          photoLabels: ['Cladding panels', 'Site cleanup', 'Week close']),
    ],
  ),
  DashboardModel(
    id: 2,
    name: 'Mabatini',
    location: 'NairobiCounty, Kenya',
    status: 'Completed',
    progress: 100,
    type: 'Infrastructure',
    deadline: 'Mar 2024',
    procuringEntity: 'NGCDF - Mathare Constituency',
    totalAmount: 5000000,
    totalWorkers: 110,
    startDate: 'Jun 2022',
    dayLabels: ['Mon 30', 'Tue 01'],
    dailyRecords: {
      'Mon 30': const DailyRecord(workerCount: 12, workers: [
        WorkerEntry(name: 'Zhang Wei', role: 'Project Manager', hours: 9),
        WorkerEntry(name: 'Joseph Mutua', role: 'Site Supervisor', hours: 9),
        WorkerEntry(name: 'Alice Wambua', role: 'Engineer', hours: 8),
      ]),
      'Tue 01': const DailyRecord(workerCount: 8, workers: [
        WorkerEntry(name: 'Joseph Mutua', role: 'Site Supervisor', hours: 8),
      ]),
    },
    tasks: const [
      TaskItem(name: 'Survey & Design', percent: 100),
      TaskItem(name: 'Earthworks', percent: 100),
      TaskItem(name: 'Foundation Piles', percent: 100),
      TaskItem(name: 'Bridge Deck', percent: 100),
      TaskItem(name: 'Finishing & Handover', percent: 100),
    ],
    reports: const [
      ReportItem(
          name: 'Project Completion Report',
          date: '15 Mar 2024',
          type: 'weekly'),
      ReportItem(
          name: 'Final Safety Audit', date: '10 Mar 2024', type: 'daily'),
    ],
    gallery: const [
      GalleryDay(dayLabel: 'Mon 30', photoLabels: [
        'Completion ceremony',
        'Aerial view',
        'Ribbon cutting'
      ]),
      GalleryDay(
          dayLabel: 'Tue 01',
          photoLabels: ['Final inspection', 'Maintenance check']),
    ],
  ),
  DashboardModel(
    id: 3,
    name: 'Daniel Comboni',
    location: 'Mathare County, Kenya',
    status: 'Ongoing',
    progress: 42,
    type: 'Road Construction',
    deadline: 'Jun 2026',
    procuringEntity: 'KERRA',
    totalAmount: 6800000,
    totalWorkers: 95,
    startDate: 'Sep 2024',
    dayLabels: ['Mon 30', 'Tue 01', 'Wed 02'],
    dailyRecords: {
      'Mon 30': const DailyRecord(workerCount: 28, workers: [
        WorkerEntry(name: 'Emma Kariuki', role: 'Site Manager', hours: 9),
        WorkerEntry(name: 'David Maina', role: 'Mason', hours: 8),
        WorkerEntry(name: 'Cynthia Otieno', role: 'Electrician', hours: 8),
      ]),
      'Tue 01': const DailyRecord(workerCount: 22, workers: [
        WorkerEntry(name: 'Emma Kariuki', role: 'Site Manager', hours: 8),
        WorkerEntry(name: 'John Kamau', role: 'Plumber', hours: 9),
      ]),
      'Wed 02': const DailyRecord(workerCount: 31, workers: [
        WorkerEntry(name: 'Emma Kariuki', role: 'Site Manager', hours: 10),
        WorkerEntry(name: 'David Maina', role: 'Mason', hours: 8),
        WorkerEntry(name: 'Paul Ochieng', role: 'Carpenter', hours: 7),
      ]),
    },
    tasks: const [
      TaskItem(name: 'Site Clearing & Pegging', percent: 100),
      TaskItem(name: 'Foundation Works', percent: 100),
      TaskItem(name: 'Walling — Block A', percent: 75),
      TaskItem(name: 'Walling — Block B', percent: 40),
      TaskItem(name: 'Roofing', percent: 15),
      TaskItem(name: 'Interior Finishes', percent: 0),
    ],
    reports: const [
      ReportItem(
          name: 'Daily Progress Report — Week 8',
          date: '04 Apr 2025',
          type: 'daily'),
      ReportItem(
          name: 'Monthly Progress Report', date: '31 Mar 2025', type: 'weekly'),
    ],
    gallery: const [
      GalleryDay(dayLabel: 'Mon 30', photoLabels: [
        'Foundation slab',
        'Block A walls',
        'Material delivery'
      ]),
      GalleryDay(
          dayLabel: 'Tue 01',
          photoLabels: ['Rebar fixing', 'Block B excavation']),
      GalleryDay(
          dayLabel: 'Wed 02',
          photoLabels: ['Scaffolding', 'Block A lintel', 'Site overview']),
    ],
  ),
  DashboardModel(
    id: 4,
    name: 'Githunguri Primary School',
    location: 'Kiambu County, Kenya',
    status: 'Paused',
    progress: 28,
    type: 'Infrastructure',
    deadline: 'TBD',
    procuringEntity: 'NGCDF - Githunguri Constituency',
    totalAmount: 3400000000,
    totalWorkers: 210,
    startDate: 'Mar 2023',
    dayLabels: ['Mon 30'],
    dailyRecords: {
      'Mon 30': const DailyRecord(workerCount: 15, workers: [
        WorkerEntry(name: 'Ahmed Omar', role: 'Project Director', hours: 6),
        WorkerEntry(name: 'Patricia Njoroge', role: 'Engineer', hours: 6),
      ]),
    },
    tasks: const [
      TaskItem(name: 'Environmental Impact Study', percent: 100),
      TaskItem(name: 'Dredging — Phase 1', percent: 80),
      TaskItem(name: 'Quay Wall Construction', percent: 35),
      TaskItem(name: 'Berth Equipment', percent: 5),
      TaskItem(name: 'Terminal Buildings', percent: 0),
    ],
    reports: const [
      ReportItem(
          name: 'Suspension Notice', date: '01 Feb 2025', type: 'incident'),
      ReportItem(
          name: 'Progress Report — Q4 2024',
          date: '31 Dec 2024',
          type: 'weekly'),
    ],
    gallery: const [
      GalleryDay(
          dayLabel: 'Mon 30',
          photoLabels: ['Quay wall', 'Dredging vessel', 'Site access']),
    ],
  ),
  DashboardModel(
    id: 5,
    name: 'Mishi Mboko',
    location: 'Mombasa County, Kenya',
    status: 'Ongoing',
    progress: 55,
    type: 'Industrial',
    deadline: 'Sep 2025',
    procuringEntity: 'NGCDF - Likoni Constituency',
    totalAmount: 14500000,
    totalWorkers: 175,
    startDate: 'Apr 2023',
    dayLabels: ['Mon 30', 'Tue 01', 'Wed 02'],
    dailyRecords: {
      'Mon 30': const DailyRecord(workerCount: 46, workers: [
        WorkerEntry(name: 'Victor Rutto', role: 'Site Manager', hours: 9),
        WorkerEntry(name: 'Lilian Chepkoech', role: 'Engineer', hours: 8),
        WorkerEntry(name: 'Samuel Koech', role: 'Fitter', hours: 8),
        WorkerEntry(name: 'Michael Bett', role: 'Welder', hours: 9),
      ]),
      'Tue 01': const DailyRecord(workerCount: 38, workers: [
        WorkerEntry(name: 'Victor Rutto', role: 'Site Manager', hours: 8),
        WorkerEntry(name: 'Samuel Koech', role: 'Fitter', hours: 9),
      ]),
      'Wed 02': const DailyRecord(workerCount: 52, workers: [
        WorkerEntry(name: 'Victor Rutto', role: 'Site Manager', hours: 9),
        WorkerEntry(name: 'Lilian Chepkoech', role: 'Engineer', hours: 8),
        WorkerEntry(name: 'Michael Bett', role: 'Welder', hours: 9),
      ]),
    },
    tasks: const [
      TaskItem(name: 'Land Preparation', percent: 100),
      TaskItem(name: 'Access Roads', percent: 90),
      TaskItem(name: 'Factory Shell — Unit A', percent: 70),
      TaskItem(name: 'Factory Shell — Unit B', percent: 50),
      TaskItem(name: 'Utilities & Services', percent: 35),
      TaskItem(name: 'Landscaping', percent: 5),
    ],
    reports: const [
      ReportItem(
          name: 'Daily Progress Report — Week 12',
          date: '04 Apr 2025',
          type: 'daily'),
      ReportItem(
          name: 'Monthly Report — March', date: '31 Mar 2025', type: 'weekly'),
    ],
    gallery: const [
      GalleryDay(
          dayLabel: 'Mon 30',
          photoLabels: ['Steel erection', 'Access road', 'Unit A frame']),
      GalleryDay(
          dayLabel: 'Tue 01', photoLabels: ['Utilities trench', 'Unit B slab']),
      GalleryDay(dayLabel: 'Wed 02', photoLabels: [
        'Roof sheeting',
        'Factory overview',
        'Equipment delivery',
        'Aerial view'
      ]),
    ],
  ),
];
