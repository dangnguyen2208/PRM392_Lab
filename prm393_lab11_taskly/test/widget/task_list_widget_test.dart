import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_lab11_taskly/repositories/task_repository.dart';
import 'package:prm393_lab11_taskly/screens/task_list_screen.dart';

void main() {
  late TaskRepository repository;

  setUp(() {
    repository = TaskRepository();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: TaskListScreen(repository: repository),
    );
  }

  group('TaskListScreen Widget Tests', () {
    testWidgets('Empty State displays: "No tasks yet. Add one!"', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('No tasks yet. Add one!'), findsOneWidget);
    });

    testWidgets('Add Task: enter text -> tap add -> verify UI updates', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Nhập text
      await tester.enterText(find.byType(TextField), 'Complete Assignment');

      // Tap nút Add
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      // Kiểm tra kết quả
      expect(find.text('Complete Assignment'), findsOneWidget);
      expect(find.text('No tasks yet. Add one!'), findsNothing);
    });

    testWidgets('Multiple Tasks: add two tasks -> verify both visible', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Thêm task 1
      await tester.enterText(find.byType(TextField), 'First Item');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      // Thêm task 2
      await tester.enterText(find.byType(TextField), 'Second Item');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      // Xác thực cả 2 item cùng hiển thị
      expect(find.text('First Item'), findsOneWidget);
      expect(find.text('Second Item'), findsOneWidget);
    });
  });
}