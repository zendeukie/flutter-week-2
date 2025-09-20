import 'package:flutter/material.dart';
import 'icon_label.dart'; // ✅ import IconLabel

class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final String priority;
  final String? dueDate;
  final String? assignee;

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
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task: $title\nPriority: $priority')),
        );
      },
      onLongPress: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$title marked as done! ✅')));
      },
      child: Card(
        color: Colors.grey[50],
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Priority + due date inline
                    Row(
                      children: [
                        _PriorityBadge(priority: priority),
                        const SizedBox(width: 12),
                        if (dueDate != null)
                          IconLabel(
                            icon: Icons.access_time,
                            label: dueDate!,
                            color: Colors.blue,
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 8),

                    // Assignee + comments
                    Row(
                      children: [
                        if (assignee != null)
                          IconLabel(
                            icon: Icons.person,
                            label: assignee!,
                            color: Colors.purple,
                          ),
                        const SizedBox(width: 12),
                        IconLabel(
                          icon: Icons.comment,
                          label: '2 comments',
                          color: Colors.grey[700],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small private sub-widget
class _PriorityBadge extends StatelessWidget {
  final String priority;
  const _PriorityBadge({super.key, required this.priority});

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
