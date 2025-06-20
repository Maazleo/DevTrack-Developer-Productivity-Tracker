import 'package:flutter/material.dart';
import '../models/task.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  // Sample task data for different columns
  final List<Task> _todoTasks = [
    Task(id: '1', title: 'Research new API documentation'),
    Task(id: '2', title: 'Design login flow'),
    Task(id: '3', title: 'Create wireframes for dashboard'),
  ];

  final List<Task> _inProgressTasks = [
    Task(id: '4', title: 'Implement authentication'),
    Task(id: '5', title: 'Setup database schema'),
  ];

  final List<Task> _doneTasks = [
    Task(id: '6', title: 'Project setup', isCompleted: true),
    Task(id: '7', title: 'Requirements gathering', isCompleted: true),
    Task(id: '8', title: 'Create GitHub repository', isCompleted: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTaskColumn('To Do', Colors.red, _todoTasks),
            _buildTaskColumn('In Progress', Colors.amber, _inProgressTasks),
            _buildTaskColumn('Done', Colors.green, _doneTasks),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskColumn(String title, Color color, List<Task> tasks) {
    return Container(
      width: 280,
      margin: const EdgeInsets.all(8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            // Column header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 8,
                        backgroundColor: color,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tasks.length.toString(),
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Tasks list
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height - 180,
              ),
              child: tasks.isEmpty
                  ? _buildEmptyColumnState()
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return _buildTaskCard(tasks[index], color);
                      },
                    ),
            ),
            
            // Add task to this column button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => _showAddTaskDialog(columnTitle: title),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Add Task',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyColumnState() {
    return Container(
      height: 100,
      alignment: Alignment.center,
      child: Text(
        'No tasks yet',
        style: TextStyle(
          color: Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task, Color columnColor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                color: task.isCompleted ? Colors.grey : null,
              ),
            ),
            if (task.dueDate != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 12, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showAddTaskDialog({String? columnTitle}) {
    final titleController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Task to ${columnTitle ?? 'Board'}'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Task Title',
            hintText: 'Enter task title',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();
              if (title.isNotEmpty) {
                setState(() {
                  final newTask = Task(
                    id: DateTime.now().toString(),
                    title: title,
                  );
                  
                  switch (columnTitle) {
                    case 'In Progress':
                      _inProgressTasks.add(newTask);
                      break;
                    case 'Done':
                      newTask.isCompleted = true;
                      _doneTasks.add(newTask);
                      break;
                    default:
                      _todoTasks.add(newTask);
                      break;
                  }
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
} 