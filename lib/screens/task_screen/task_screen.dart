import 'package:flutter/material.dart';
import 'package:graville_operations/core/commons/widgets/custom_button.dart';
import 'package:graville_operations/screens/task_screen/filter_sheet.dart';
import 'package:graville_operations/screens/task_screen/task_widget.dart';
import 'package:graville_operations/screens/task_screen/worker.dart';
import 'package:graville_operations/screens/task_screen/worker_table.dart';
import 'package:graville_operations/services/worker_service.dart';
import 'package:graville_operations/models/worker_model.dart';
import 'package:graville_operations/core/remote/api/task_api.dart';
import 'package:graville_operations/core/remote/dto/requests/create_tasks.dart';


class CreateTaskScreen extends StatefulWidget {
  final int? fieldoperatorid;
  const CreateTaskScreen({super.key, this.fieldoperatorid});

  @override
  State<CreateTaskScreen> createState() => CreateTaskScreenState();
}

class CreateTaskScreenState extends State<CreateTaskScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final searchController = TextEditingController();

  int selectedSiteId = 0;
  List<int> selectedWorkerIds = [];

  List<Map<String, dynamic>> workersDatabase = [];
  List<Map<String, dynamic>> filteredWorkers = [];
  String searchQuery = '';
  bool _isLoading = false;

  bool _hasMore = true;
  bool _isFetchingMore = false;
  final int _pageSize = 20;

  WorkerFilterParams _filterParams = const WorkerFilterParams();

  int? get fieldOperatorId => widget.fieldoperatorid;

  @override
  void initState() {
    super.initState();
    fetchWorkers(reset: true);
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchWorkers({bool reset = false}) async {
    if (_isLoading || _isFetchingMore) return;

    if (reset) {
      setState(() {
        _isLoading = true;
        workersDatabase = [];
        filteredWorkers = [];
        _hasMore = true;
        _filterParams = _filterParams.copyWith(offset: 0);
      });
    } else {
      setState(() => _isFetchingMore = true);
    }

    try {
      final List<Worker> workers = await WorkerService.fetchWorkersFiltered(
        skill: _filterParams.skill,
        sortBy: _filterParams.sortBy,
        order: _filterParams.order,
        limit: _filterParams.limit,
        offset: _filterParams.offset,
      );

      final mapped = workers.map((w) => {
      'id': w.id,
      'national_id': w.nationalId,        
      'name': w.fullName,
      'skill_type': w.skillType,
       }).toList();

      setState(() {
        if (reset) {
          workersDatabase = mapped;
        } else {
          workersDatabase.addAll(mapped);
        }
        _hasMore = workers.length == _pageSize;
        _filterParams = _filterParams.copyWith(
          offset: _filterParams.offset + workers.length,
        );
        _applySearch();
        _isLoading = false;
        _isFetchingMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isFetchingMore = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error fetching workers: ${e.toString()}"),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = searchController.text.toLowerCase();
      _applySearch();
    });
  }

  void _applySearch() {
    final query = searchQuery.trim().toLowerCase();
    filteredWorkers = query.isEmpty
        ? workersDatabase
        : workersDatabase.where((w) {
            return (w['name'] as String).toLowerCase().contains(query);
          }).toList();
  }

  void _applySort(String field, String order) {
    _filterParams = _filterParams.copyWith(sortBy: field, order: order);
    fetchWorkers(reset: true);
  }

  void _applySkillFilter(String? skill) {
    _filterParams = (skill == null || skill.isEmpty)
        ? _filterParams.copyWith(clearSkill: true)
        : _filterParams.copyWith(skill: skill);
    fetchWorkers(reset: true);
  }

  bool get _hasActiveFilters =>
      _filterParams.skill != null ||
      _filterParams.sortBy != 'id' ||
      _filterParams.order != 'asc';

  void addWorker(Map<String, dynamic> worker) {
    setState(() {
      if (!selectedWorkerIds.contains(worker['id'])) {
        selectedWorkerIds.add(worker['id']);
      }
    });
  }

  void removeWorker(int workerId) {
    setState(() => selectedWorkerIds.removeWhere((id) => id == workerId));
  }

  String getWorkerName(int workerId) {
    final worker = workersDatabase.firstWhere(
      (w) => w['id'] == workerId,
      orElse: () => {'name': 'Unknown'},
    );
    return worker['name'];
  }

  void submitTask() async {
    if (!formKey.currentState!.validate()) return;
    if (selectedWorkerIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one worker")),
      );
      return;
    }

    try {
      final request = CreateTaskRequest(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        assignedTo: selectedWorkerIds,
        siteId: selectedSiteId,
        fieldOperatorId: fieldOperatorId ?? 1,
        completion: 0,
        createdAt: DateTime.now(),
      );
      await TaskApi.createTask(request);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Task created successfully'),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${e.toString()}'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Widget _buildActiveFilters() {
    final chips = <Widget>[];

    if (_filterParams.skill?.isNotEmpty == true) {
      chips.add(FilterPill(
        label: 'Skill: ${_filterParams.skill}',
        onRemove: () => _applySkillFilter(null),
      ));
    }

    if (_filterParams.sortBy != 'id' || _filterParams.order != 'asc') {
      final orderIcon = _filterParams.order == 'asc' ? '↑' : '↓';
      chips.add(FilterPill(
        label:
            'Sort: ${kSortFieldLabels[_filterParams.sortBy] ?? _filterParams.sortBy} $orderIcon',
        onRemove: () => _applySort('id', 'asc'),
      ));
    }

    if (chips.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Wrap(spacing: 8, runSpacing: 6, children: chips),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Task Title',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Enter task title',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Please enter a title' : null,
              ),

              const SizedBox(height: 16),

              const Text('Task Description',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter task description',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),

              const SizedBox(height: 24),

              _SelectedWorkersPanel(
                selectedWorkerIds: selectedWorkerIds,
                getWorkerName: getWorkerName,
                onRemove: removeWorker,
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  const Text('Search Workers',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  const Spacer(),
                  InkWell(
                    onTap: () => showSortFilterSheet(
                      context: context,
                      currentParams: _filterParams,
                      onApply: (updated) {
                        setState(() => _filterParams = updated);
                        fetchWorkers(reset: true);
                      },
                      onReset: () {
                        setState(
                            () => _filterParams = const WorkerFilterParams());
                        fetchWorkers(reset: true);
                      },
                    ),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _hasActiveFilters
                            ? Colors.blue[50]
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _hasActiveFilters
                              ? Colors.blue
                              : Colors.grey[300]!,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.tune,
                              size: 16,
                              color: _hasActiveFilters
                                  ? Colors.blue
                                  : Colors.grey[700]),
                          const SizedBox(width: 4),
                          Text(
                            'Sort & Filter',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _hasActiveFilters
                                  ? Colors.blue
                                  : Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search by name…',
                  prefixIcon:
                      const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[50],
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            searchController.clear();
                            setState(() {
                              searchQuery = '';
                              _applySearch();
                            });
                          },
                        )
                      : null,
                ),
              ),

              const SizedBox(height: 8),
              _buildActiveFilters(),

              WorkersTable(
                filteredWorkers: filteredWorkers,
                selectedWorkerIds: selectedWorkerIds,
                filterParams: _filterParams,
                isLoading: _isLoading,
                isFetchingMore: _isFetchingMore,
                hasMore: _hasMore,
                searchQuery: searchQuery,
                searchText: searchController.text,
                onAdd: addWorker,
                onSort: _applySort,
                onLoadMore: fetchWorkers,
              ),

              const SizedBox(height: 24),

              CustomButton(
                label: 'Create Task',
                backgroundColor: Colors.orange,
                textColor: Colors.white,
                onPressed: submitTask,
              ),

              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedWorkersPanel extends StatelessWidget {
  final List<int> selectedWorkerIds;
  final String Function(int) getWorkerName;
  final void Function(int) onRemove;

  const _SelectedWorkersPanel({
    required this.selectedWorkerIds,
    required this.getWorkerName,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.people, size: 20, color: Colors.blue),
              SizedBox(width: 8),
              Text('Selected Workers',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          if (selectedWorkerIds.isEmpty)
            Text(
              'No workers assigned yet',
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: selectedWorkerIds.map((id) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(getWorkerName(id),
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w500)),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => onRemove(id),
                          child: const Icon(Icons.close,
                              size: 16, color: Colors.red),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}