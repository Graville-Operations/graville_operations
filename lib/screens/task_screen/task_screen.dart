import 'package:flutter/material.dart';
import 'package:graville_operations/screens/commons/widgets/custom_button.dart';
import 'package:graville_operations/screens/workers/workers_screen.dart';
import 'package:graville_operations/services/tasks_service.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => CreateTaskScreenState();
}

class CreateTaskScreenState extends State<CreateTaskScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

int selectedSiteId = 0;
List<int> selectedWorkerIds = [];

  int? get fieldOperatorId => null;

// Pick workers
void pickWorkers() async {
  final workers = await Navigator.push<List<int>>(
    context,
    MaterialPageRoute(builder: (_) => WorkersScreen()),
  );

  if (workers != null) {
    setState(() {
      selectedWorkerIds = workers;
    });
  }
}

void submitTask() async {
  if (formKey.currentState!.validate()) {
    try {
      await TaskService.createTask(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        siteId: selectedSiteId,
        fieldOperatorId: fieldOperatorId ?? 0, //  logged-in user
        assignedTo: selectedWorkerIds,
        createdAt: DateTime.now().toIso8601String(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task created successfully')),
      );

      titleController.clear();
      setState(() {
        selectedSiteId = 0;
        selectedWorkerIds = [];
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
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
        title: const Text('Create Task',
         style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Task Title',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Enter task title',
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: 'Enter task description',
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                ),
                maxLines: 2,
                
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
                    child: const Text('Cancel',
                     style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
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

