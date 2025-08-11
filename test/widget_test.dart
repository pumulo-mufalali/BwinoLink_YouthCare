// This is a basic Flutter widget test for AfyaLink Market app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:vsla/main.dart';
import 'package:vsla/providers/app_state.dart';

void main() {
  testWidgets('AfyaLink app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => AppState(),
        child: const AfyaLinkApp(),
      ),
    );

    // Verify that the app loads with the login screen
    expect(find.text('AfyaLink Market'), findsOneWidget);
  });
}
