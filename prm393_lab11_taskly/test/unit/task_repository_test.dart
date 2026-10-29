import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_lab11_taskly/models/task.dart';
import 'package:prm393_lab11_taskly/repositories/task_repository.dart';

void main() {
  late TaskRepository repository;

  setUp(() {
    repository = TaskRepository();
  });

  group('TaskRepository Tests', () {
    test('addTask() adds a task into repository', () {
      // Arrange
      final task = Task(id: 't1', title: 'Buy groceries');

      // Act
      repository.addTask(task);

      // Assert
      expect(repository.tasks.length, 1);
      expect(repository.tasks.first.title, 'Buy groceries');
    });

    test('deleteTask() removes task by id', () {
      // Arrange
      final task1 = Task(id: 't1', title: 'Task 1');
      final task2 = Task(id: 't2', title: 'Task 2');
      repository.addTask(task1);
      repository.addTask(task2);

      // Act
      repository.deleteTask('t1');

      // Assert
      expect(repository.tasks.length, 1);
      expect(repository.tasks.any((task) => task.id == 't1'), isFalse);
    });

    test('updateTask() modifies existing task properties', () {
      // Arrange
      final task = Task(id: 't1', title: 'Original Name', completed: false);
      repository.addTask(task);

      // Act
      final updatedTask = Task(id: 't1', title: 'Updated Name', completed: true);
      repository.updateTask(updatedTask);

      // Assert
      final result = repository.tasks.firstWhere((t) => t.id == 't1');
      expect(result.title, 'Updated Name');
      expect(result.completed, isTrue);
    });
  });
}