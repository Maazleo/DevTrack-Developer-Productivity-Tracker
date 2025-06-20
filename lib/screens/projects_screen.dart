import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  // Sample projects data
  final List<Map<String, dynamic>> _projects = [
    {
      'id': '1',
      'name': 'Website Redesign',
      'client': 'Acme Corp',
      'deadline': DateTime.now().add(const Duration(days: 7)),
      'status': 'In Progress',
      'color': Colors.blue,
      'progress': 0.4,
    },
    {
      'id': '2',
      'name': 'Mobile App Development',
      'client': 'TechStart',
      'deadline': DateTime.now().add(const Duration(days: 14)),
      'status': 'In Progress',
      'color': Colors.green,
      'progress': 0.2,
    },
    {
      'id': '3',
      'name': 'UI Kit Creation',
      'client': 'DesignHub',
      'deadline': DateTime.now().add(const Duration(days: -2)),
      'status': 'Completed',
      'color': Colors.purple,
      'progress': 1.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
      ),
      body: _projects.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _projects.length,
              itemBuilder: (context, index) {
                final project = _projects[index];
                return _buildProjectCard(project);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProjectDialog,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No projects yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the + button to add a new project',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project) {
    final deadlineDate = project['deadline'] as DateTime;
    final bool isOverdue = deadlineDate.isBefore(DateTime.now()) && 
                         project['status'] != 'Completed';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundColor: project['color'],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    project['name'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(project['status']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    project['status'],
                    style: TextStyle(
                      color: _getStatusColor(project['status']),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.business,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  'Client: ${project['client']}',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: isOverdue ? Colors.red : Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  'Deadline: ${_formatDate(deadlineDate)}',
                  style: TextStyle(
                    color: isOverdue ? Colors.red : Colors.grey[600],
                    fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: project['progress'],
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(project['color']),
            ),
            const SizedBox(height: 8),
            Text(
              '${(project['progress'] * 100).toInt()}% complete',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'In Progress':
        return Colors.blue;
      case 'Completed':
        return Colors.green;
      case 'On Hold':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showAddProjectDialog() {
    final nameController = TextEditingController();
    final clientController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Project'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Project Name',
                  hintText: 'Enter project name',
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: clientController,
                decoration: const InputDecoration(
                  labelText: 'Client',
                  hintText: 'Enter client name',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final client = clientController.text.trim();
              
              if (name.isNotEmpty) {
                setState(() {
                  _projects.add({
                    'id': DateTime.now().toString(),
                    'name': name,
                    'client': client.isEmpty ? 'No client' : client,
                    'deadline': DateTime.now().add(const Duration(days: 14)),
                    'status': 'In Progress',
                    'color': Colors.blue,
                    'progress': 0.0,
                  });
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