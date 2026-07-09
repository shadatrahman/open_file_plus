import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('shows idle status and open button', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Idle'), findsOneWidget);
    expect(find.text('Open test file'), findsOneWidget);
  });
}
