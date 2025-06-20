import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/constants.dart';

class TimeTrackerScreen extends StatefulWidget {
  const TimeTrackerScreen({super.key});

  @override
  State<TimeTrackerScreen> createState() => _TimeTrackerScreenState();
}

class _TimeTrackerScreenState extends State<TimeTrackerScreen> {
  bool _isRunning = false;
  int _seconds = 0;
  Timer? _timer;
  final TextEditingController _projectController = TextEditingController();
  final TextEditingController _taskController = TextEditingController();
  String? _selectedProject;
  
  final List<Map<String, dynamic>> _timeEntries = [
    {
      'id': '1',
      'project': 'Website Redesign',
      'task': 'Header Component',
      'duration': '1h 25m',
      'date': DateTime.now().subtract(const Duration(hours: 3)),
    },
    {
      'id': '2',
      'project': 'Mobile App',
      'task': 'Authentication Flow',
      'duration': '2h 10m',
      'date': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'id': '3',
      'project': 'Website Redesign',
      'task': 'Contact Form',
      'duration': '45m',
      'date': DateTime.now().subtract(const Duration(days: 1, hours: 4)),
    },
  ];

  final List<String> _projects = [
    'Website Redesign',
    'Mobile App',
    'UI Kit Creation',
  ];

  @override
  void dispose() {
    _timer?.cancel();
    _projectController.dispose();
    _taskController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
    setState(() {
      _isRunning = true;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
    
    if (_seconds > 0) {
      _showSaveEntryDialog();
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _seconds = 0;
      _isRunning = false;
    });
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String _formatEntryTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Tracker'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimerCard(),
            const SizedBox(height: 30),
            Text(
              'Recent Time Entries',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildTimeEntriesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project selection dropdown
            DropdownButtonFormField<String>(
              value: _selectedProject,
              decoration: const InputDecoration(
                labelText: 'Select Project',
                border: OutlineInputBorder(),
              ),
              hint: const Text('Select Project'),
              items: _projects.map((project) {
                return DropdownMenuItem<String>(
                  value: project,
                  child: Text(project),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedProject = value;
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Task input
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                labelText: 'What are you working on?',
                border: OutlineInputBorder(),
                hintText: 'Enter task description',
              ),
            ),
            const SizedBox(height: 24),
            
            // Timer display
            Center(
              child: Column(
                children: [
                  Text(
                    _formatTime(_seconds),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isRunning) ...[
                        _buildTimerButton(
                          icon: Icons.pause,
                          label: 'Pause',
                          color: Colors.orange,
                          onPressed: _stopTimer,
                        ),
                        const SizedBox(width: 16),
                        _buildTimerButton(
                          icon: Icons.stop,
                          label: 'Stop',
                          color: Colors.red,
                          onPressed: () {
                            _stopTimer();
                            _resetTimer();
                          },
                        ),
                      ] else ...[
                        _buildTimerButton(
                          icon: Icons.play_arrow,
                          label: 'Start',
                          color: Colors.green,
                          onPressed: _startTimer,
                        ),
                        if (_seconds > 0) ...[
                          const SizedBox(width: 16),
                          _buildTimerButton(
                            icon: Icons.save,
                            label: 'Save',
                            color: AppColors.darkBlue,
                            onPressed: _showSaveEntryDialog,
                          ),
                          const SizedBox(width: 16),
                          _buildTimerButton(
                            icon: Icons.refresh,
                            label: 'Reset',
                            color: Colors.grey,
                            onPressed: _resetTimer,
                          ),
                        ],
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildTimeEntriesList() {
    if (_timeEntries.isEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(
              Icons.timer_off,
              size: 60,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'No time entries yet',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _timeEntries.length,
      itemBuilder: (context, index) {
        final entry = _timeEntries[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              entry['task'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  entry['project'],
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatEntryDateTime(entry['date']),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                entry['duration'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatEntryDateTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    }
  }

  void _showSaveEntryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Time Entry'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedProject,
              decoration: const InputDecoration(
                labelText: 'Project',
              ),
              hint: const Text('Select Project'),
              items: _projects.map((project) {
                return DropdownMenuItem<String>(
                  value: project,
                  child: Text(project),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedProject = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                labelText: 'Task Description',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Duration: ${_formatEntryTime(_seconds)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
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
              if (_selectedProject != null && _taskController.text.isNotEmpty) {
                setState(() {
                  _timeEntries.insert(0, {
                    'id': DateTime.now().toString(),
                    'project': _selectedProject!,
                    'task': _taskController.text,
                    'duration': _formatEntryTime(_seconds),
                    'date': DateTime.now(),
                  });
                  _resetTimer();
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
} 