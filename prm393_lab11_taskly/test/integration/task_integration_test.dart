import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_lab11_taskly/repositories/task_repository.dart';
import 'package:prm393_lab11_taskly/screens/task_list_screen.dart';

void main() {
  testWidgets('Full flow: Add -> Open detail -> Edit -> Save -> Verify update', (tester) async {
    final repository = TaskRepository();

    await tester.pumpWidget(MaterialApp(
      home: TaskListScreen(repository: repository),
    ));

    // 1. Add "Original title"
    await tester.enterText(find.byType(TextField), 'Original title');
    await tester.tap(find.byKey(const Key('addTaskButton')));
    await tester.pumpAndSettle();
    expect(find.text('Original title'), findsOneWidget);

    // 2. Tap task -> open detail
    await tester.tap(find.text('Original title'));
    await tester.pumpAndSettle();

    // 3. Edit -> "Updated title"
    final detailField = find.byKey(const Key('detailTitleField'));
    await tester.enterText(detailField, 'Updated title');

    // 4. Save
    await tester.tap(find.byKey(const Key('saveTaskButton')));
    await tester.pumpAndSettle();

    // 5. Verify updated title appears in list
    expect(find.text('Updated title'), findsOneWidget);
    expect(find.text('Original title'), findsNothing);
  });
}