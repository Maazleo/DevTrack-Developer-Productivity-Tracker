import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../widgets/progress_card.dart';
import '../widgets/task_item.dart';
import '../widgets/pomodoro_timer.dart';
import '../utils/constants.dart';
import '../models/task.dart';
import '../widgets/greeting_card.dart';
import '../models/user_profile.dart';
import '../providers/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> _tasks = dummyTasks.map((taskData) => Task(
    id: taskData['id'],
    title: taskData['title'],
    isCompleted: taskData['isCompleted'],
  )).toList();

  final ScrollController _scrollController = ScrollController();
  
  // Reference to the sample user profile from constants
  UserProfile get sampleUserProfile => sampleUserProfile;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate task stats
    final completedTasks = _tasks.where((task) => task.isCompleted).length;
    final totalTasks = _tasks.length;
    final progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    // Format today's date
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, d MMMM').format(now);
    final shortFormattedDate = DateFormat('E, d MMM').format(now);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _buildDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(20),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Modern Greeting Card
              Consumer<UserProvider>(
                builder: (context, userProvider, _) => GreetingCard(
                  user: userProvider.userProfile,
                  onTap: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Daily Progress Card
              ProgressCard(
                tasksProgress: progress,
                completedTasks: completedTasks,
                totalTasks: totalTasks,
                focusTime: '1h 45m',
              ),
              const SizedBox(height: 24),

              // Tasks Section
              _buildTasksSection(),
              const SizedBox(height: 24),

              // Pomodoro Timer
              const PomodoroTimer(),
              const SizedBox(height: 32),

              // Bottom Quick Actions
              _buildQuickActions(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTasksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.task_alt, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Today\'s Tasks',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () {
                _showAddTaskDialog();
              },
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Add Task'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Tasks list
        Column(
          children: _tasks.map((task) => TaskItem(
            task: task,
            onToggle: (value) {
              setState(() {
                task.isCompleted = value ?? false;
              });
            },
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('New Project'),
            onPressed: () {
              Navigator.pushNamed(context, '/projects');
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Theme.of(context).colorScheme.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.timer_outlined),
            label: const Text('Log Time'),
            onPressed: () {
              Navigator.pushNamed(context, '/time-tracker');
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          _drawerItem(context, Icons.dashboard, 'Dashboard', '/'),
          _drawerItem(context, Icons.person, 'Profile', '/profile'),
          _drawerItem(context, Icons.folder, 'Projects', '/projects'),
          _drawerItem(context, Icons.task_alt, 'Tasks', '/tasks'),
          _drawerItem(context, Icons.timer, 'Time Tracker', '/time-tracker'),
          _drawerItem(context, Icons.settings, 'Settings', '/settings'),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final user = userProvider.userProfile;
        
        return DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: user.profileImageUrl != null
                    ? Image.network(user.profileImageUrl!)
                    : Text(
                        _getInitials(user.name),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (user.jobTitle != null) ...[
                      Text(
                        user.jobTitle!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                    ],
                    Text(
                      user.email,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/profile');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: const Size(0, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('View Profile'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String title, String route) {
    final isSelected = ModalRoute.of(context)?.settings.name == route || 
                      (route == '/' && ModalRoute.of(context)?.settings.name == null);
    
    return ListTile(
      leading: Icon(
        icon, 
        color: isSelected 
            ? Theme.of(context).colorScheme.primary
            : Colors.grey[600],
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected 
              ? Theme.of(context).colorScheme.primary
              : null,
        ),
      ),
      tileColor: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : null,
      onTap: () {
        Navigator.pop(context);
        if (route != '/' || ModalRoute.of(context)?.settings.name != null) {
          Navigator.pushNamed(context, route);
        }
      },
    );
  }

  void _showAddTaskDialog() {
    final TextEditingController titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Task'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(
            hintText: 'Task title',
            labelText: 'Task Title',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();
              if (title.isNotEmpty) {
                setState(() {
                  _tasks.add(Task(
                    id: DateTime.now().toString(),
                    title: title,
                  ));
                });
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return nameParts[0][0] + nameParts[1][0];
    } else if (name.isNotEmpty) {
      return name[0];
    } else {
      return 'U';
    }
  }
} 