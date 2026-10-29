import 'package:flutter/material.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  final TaskRepository repository;

  const TaskListScreen({super.key, required this.repository});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _textController = TextEditingController();

  void _handleAddTask() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        widget.repository.addTask(
          Task(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: text,
          ),
        );
        _textController.clear();
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskList = widget.repository.tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Taskly'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Enter task...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  key: const Key('addTaskButton'),
                  onPressed: _handleAddTask,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: taskList.isEmpty
                ? const Center(
              child: Text('No tasks yet. Add one!'),
            )
                : ListView.builder(
              itemCount: taskList.length,
              itemBuilder: (context, index) {
                final item = taskList[index];
                return ListTile(
                  title: Text(item.title),
                  trailing: Checkbox(
                    value: item.completed,
                    onChanged: (_) {
                      setState(() {
                        item.toggle();
                      });
                    },
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TaskDetailScreen(
                          task: item,
                          repository: widget.repository,
                        ),
                      ),
                    );
                    setState(() {});
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('fabAddTask'),
        onPressed: _handleAddTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}