import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_lab11_taskly/models/task.dart';

void main() {
  group('Task Model Tests', () {
    test('Default completed value should be false', () {
      // Arrange & Act
      final task = Task(id: '1', title: 'Sample Task');

      // Assert
      expect(task.completed, isFalse);
    });

    test('toggle() switches true <-> false', () {
      // Arrange
      final task = Task(id: '1', title: 'Toggle Task', completed: false);

      // Act & Assert 1: false -> true
      task.toggle();
      expect(task.completed, isTrue);

      // Act & Assert 2: true -> false
      task.toggle();
      expect(task.completed, isFalse);
    });
  });
}