import 'package:app/features/auth/domain/repos/auth_repo.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Create a mock class for AuthRepo
class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Create a mock instance of AuthRepo
    final mockAuthRepo = MockAuthRepo();

    // Pass the mockAuthRepo to MyApp
    await tester.pumpWidget(MyApp(authRepo: mockAuthRepo));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
