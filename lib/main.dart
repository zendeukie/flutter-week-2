// main.dart
import 'package:flutter/material.dart';

void main() => runApp(const TaskApp());

/// ---------------------------
/// Root App
/// ---------------------------
class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Widget Fundamentals Demo',
      theme: ThemeData(useMaterial3: true),
      home: const TaskListPage(),
    );
  }
}

/// ---------------------------
/// Task List Page
/// ---------------------------
class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  // ✅ demo tasks now include dueDate + assignee
  static final _demoTasks = [
    {
      'title': 'Write unit tests',
      'description': 'Cover TaskCard widget and interactive behavior.',
      'priority': 'High',
      'dueDate': '2025-09-25',
      'assignee': 'Santi',
    },
    {
      'title': 'Refactor auth',
      'description': 'Move logic into a reusable AuthService and clean up UI.',
      'priority': 'Low',
      'dueDate': '2025-09-28',
      'assignee': 'Alex',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: _demoTasks.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final t = _demoTasks[i];
          return TaskCard(
            title: t['title']!,
            description: t['description']!,
            priority: t['priority']!,
            dueDate: t['dueDate'],
            assignee: t['assignee'],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddModal(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openAddModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Add Task', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                const TextField(
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 8),
                const TextField(
                  maxLines: 2,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Create (UI only)'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// ---------------------------
/// Widget: TaskCard (Stateless)
/// ---------------------------
class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final String priority;
  final String? dueDate; // ✅ Task B
  final String? assignee; // ✅ Task B

  const TaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.priority,
    this.dueDate,
    this.assignee,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: Title + Due Date
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      if (dueDate != null)
                        IconLabel(
                          icon: Icons.access_time,
                          label: dueDate!,
                          color: Colors.blue,
                        ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Description
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Row 2: Assignee
                  if (assignee != null) ...[
                    Row(
                      children: [
                        IconLabel(
                          icon: Icons.person,
                          label: assignee!,
                          color: Colors.purple,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Row 3: Comments + done count (just sample)
                  Row(
                    children: [
                      IconLabel(
                        icon: Icons.comment,
                        label: '2 comments',
                        color: Colors.grey[700],
                      ),
                      const SizedBox(width: 12),
                      IconLabel(
                        icon: Icons.check_circle_outline,
                        label: '0 done',
                        color: Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _PriorityBadge(priority: priority),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------
/// Priority Badge
/// ---------------------------
class _PriorityBadge extends StatelessWidget {
  final String priority;
  const _PriorityBadge({super.key, required this.priority});

  // ✅ Improved: support High/Medium/Low
  Color get _color {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        priority,
        style: TextStyle(color: _color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// ---------------------------
/// Reusable IconLabel widget
/// ---------------------------
class IconLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const IconLabel({
    super.key,
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(label, style: textStyle?.copyWith(color: color)),
      ],
    );
  }
}
