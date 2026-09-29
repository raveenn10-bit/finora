// ─────────────────────────────────────────────────────────
//  test/widget_test.dart
//  Basic smoke tests — verifies app renders without crash.
// ─────────────────────────────────────────────────────────
import 'package:finora/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App renders SplashScreen without crash', (tester) async {
    await tester.pumpWidget(const FinoraApp());
    expect(find.text('FINORA'), findsOneWidget);
    expect(find.text('Track. Save. Grow.'), findsOneWidget);
  });
}
