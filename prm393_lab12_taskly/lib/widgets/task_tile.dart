import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({
    required ValueKey<String> key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Chỉ lắng nghe và rebuild khi thuộc tính completed của task này thay đổi
    return Selector<TaskProvider, bool>(
      selector: (_, provider) =>
      provider.tasks.firstWhere((t) => t.id == task.id).completed,
      builder: (context, isCompleted, child) {
        return ListTile(
          leading: Checkbox(
            value: isCompleted,
            onChanged: (_) {
              context.read<TaskProvider>().toggleTask(task.id);
            },
          ),
          title: Text(
            task.title,
            style: TextStyle(
              decoration: isCompleted ? TextDecoration.lineThrough : null,
              color: isCompleted ? Colors.grey : Colors.black,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () {
              context.read<TaskProvider>().deleteTask(task.id);
            },
          ),
        );
      },
    );
  }
}