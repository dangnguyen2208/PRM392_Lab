import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_lab08/main.dart';

void main() {
  testWidgets('App renders PostListScreen test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('API Posts List'), findsOneWidget);
  });
}
