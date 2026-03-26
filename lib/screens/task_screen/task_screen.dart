import 'package:flutter/material.dart';
import 'package:graville_operations/screens/commons/widgets/custom_button.dart';
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
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  int selectedSiteId = 0;
  List<int> selectedWorkerIds = [];

  // Dummy data
  final List<Map<String, dynamic>> workersDatabase = [
    {'id': 1, 'name': 'Ndanu Eunice'},
    {'id': 2, 'name': 'Limoh Joshua'},
    {'id': 3, 'name': 'Mwanthi Julia'},
    {'id': 4, 'name': 'Agwata Brian'},
    {'id': 5, 'name': 'Onduko Ian'},
    {'id': 6, 'name': 'Chweya Kelvine'},
    {'id': 7, 'name': 'Mbinya Magdalene'},
    {'id': 8, 'name': 'Stacy Shania'},
  ];

  List<Map<String, dynamic>> filteredWorkers = [];
  String searchQuery = '';

  int? get fieldOperatorId => widget.fieldoperatorid;

  @override
  void initState() {
    super.initState();
    filteredWorkers = workersDatabase;
    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void onSearchChanged() {
    setState(() {
      searchQuery = searchController.text.toLowerCase();
      filterWorkers();
    });
  }

  void filterWorkers() {
    if (searchQuery.isEmpty) {
      filteredWorkers = workersDatabase;
    } else {
      filteredWorkers = workersDatabase.where((worker) {
        return worker['name'].toLowerCase().contains(searchQuery);
      }).toList();
    }
  }

  void addWorker(Map<String, dynamic> worker) {
    setState(() {
      if (!selectedWorkerIds.contains(worker['id'])) {
        selectedWorkerIds.add(worker['id']);
      }
    });
  }

  void removeWorker(int workerId) {
    setState(() {
      selectedWorkerIds.removeWhere((id) => id == workerId);
    });
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

    // if (fieldOperatorId == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text("Field operator not found")),
    //   );
    //   return;
    // }

    try {
      final request = CreateTaskRequest(
        title: titleController.text.trim(),
        assignedTo: selectedWorkerIds.first,
        fieldOperatorId: fieldOperatorId ?? 1,
        completion: false,
        description: descriptionController.text.trim(),
        createdAt: DateTime.now().toIso8601String(),
      );
      await TaskApi.createTask(request, description: descriptionController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task created successfully')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
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
              const Text(
                'Task Title',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Enter task title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Task Description',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: 'Enter task description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              
              Container(
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
                        Text(
                          'Selected Workers',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (selectedWorkerIds.isEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'No workers assigned yet',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )
                    else
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: selectedWorkerIds.map((workerId) {
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    getWorkerName(workerId),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () => removeWorker(workerId),
                                    child: const Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                'Search Workers',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search workers...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),

              const SizedBox(height: 16),
Container(
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
          Icon(Icons.table_chart, size: 20, color: Colors.green),
          SizedBox(width: 8),
          Text(
            'Workers',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),

      const SizedBox(height: 12),
      filteredWorkers.isEmpty
          ? Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              alignment: Alignment.center,
              child: Text(
                'No workers match "${searchController.text}"',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = MediaQuery.of(context).size.width;
                final containerWidth = constraints.maxWidth;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: screenWidth < 600 ? screenWidth * 1.2 : containerWidth,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dataTableTheme: DataTableThemeData(
                          headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                        ),
                      ),
                      child: DataTable(
                        columnSpacing: screenWidth < 600 ? 12 : 20,
                        horizontalMargin: screenWidth < 600 ? 8 : 12,
                        headingRowHeight: screenWidth < 600 ? 44 : 48,
                        dataRowHeight: screenWidth < 600 ? 52 : 56,
                        columns: [
                          DataColumn(
                            label: SizedBox(
                              child: Text(
                                'ID',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth < 600 ? 12 : 14,
                                ),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              child: Text(
                                'Worker Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth < 600 ? 12 : 14,
                                ),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              child: Text(
                                'Action',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth < 600 ? 12 : 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                        rows: filteredWorkers.map((worker) {
                          final isSelected = selectedWorkerIds.contains(worker['id']);
                          return DataRow(
                            color: isSelected 
                                ? MaterialStateProperty.all(Colors.blue[50])
                                : null,
                            cells: [
                              DataCell(
                                Text(
                                  worker['id'].toString(),
                                  style: TextStyle(
                                    fontSize: screenWidth < 600 ? 12 : 14,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  worker['name'],
                                  style: TextStyle(
                                    fontSize: screenWidth < 600 ? 12 : 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  child: ElevatedButton(
                                    onPressed: isSelected ? null : () => addWorker(worker),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isSelected
                                          ? Colors.grey[300]
                                          : Colors.blue,
                                      foregroundColor: isSelected
                                          ? Colors.grey[600]
                                          : Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth < 600 ? 8 : 16,
                                        vertical: screenWidth < 600 ? 6 : 8,
                                      ),
                                    ),
                                    child: Text(
                                      isSelected 
                                          ? (screenWidth < 600 ? '✓' : '✓ Added')
                                          : (screenWidth < 600 ? '+' : '+ Add'),
                                      style: TextStyle(
                                        fontSize: screenWidth < 600 ? 12 : 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                );
              },
            ),
    ],
  ),
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
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
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