import 'package:flutter/material.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  final TaskRepository repository;

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.repository,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _saveTask() {
    final updatedTitle = _titleController.text.trim();
    if (updatedTitle.isNotEmpty) {
      widget.task.title = updatedTitle;
      widget.repository.updateTask(widget.task);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Detail'),
        actions: [
          IconButton(
            key: const Key('saveTaskButton'),
            icon: const Icon(Icons.check),
            onPressed: _saveTask,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          key: const Key('detailTitleField'),
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Task Title',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}