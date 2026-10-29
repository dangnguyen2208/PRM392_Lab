import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_lab11_taskly/models/task.dart';
import 'package:prm393_lab11_taskly/repositories/task_repository.dart';
import 'package:prm393_lab11_taskly/screens/task_list_screen.dart';

void main() {
  testWidgets('Navigate from TaskListScreen to TaskDetailScreen', (tester) async {
    // 1. Seed repository với 1 task
    final repository = TaskRepository();
    repository.addTask(Task(id: 'nav_1', title: 'Navigation Seeded Task'));

    // 2. Pump TaskListScreen
    await tester.pumpWidget(MaterialApp(
      home: TaskListScreen(repository: repository),
    ));

    // 3. Tap vào task seeded & pumpAndSettle
    await tester.tap(find.text('Navigation Seeded Task'));
    await tester.pumpAndSettle();

    // 4. Validate AppBar title & TextField key
    expect(find.text('Task Detail'), findsOneWidget);
    expect(find.byKey(const Key('detailTitleField')), findsOneWidget);
  });
}