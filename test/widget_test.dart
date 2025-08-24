import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:bwino_link_youthcare/main.dart';
import 'package:bwino_link_youthcare/providers/app_state.dart';

void main() {
  testWidgets('BwinoLink YouthCare app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => AppState(),
        child: const BwinoLinkApp(),
      ),
    );

    // Verify that the app loads with the splash screen
    expect(find.text('BwinoLink YouthCare'), findsOneWidget);
    expect(find.text('Health where you are'), findsOneWidget);
  });
}
