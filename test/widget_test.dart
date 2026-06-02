import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:gamedeal_tracker/main.dart';
import 'package:gamedeal_tracker/providers/game_provider.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => GameProvider()),
        ],
        child: const GameModelTrackerApp(),
      ),
    );

    // Verify that the navigation labels are present
    expect(find.text('Gratuitos'), findsOneWidget);
    expect(find.text('Promoções'), findsOneWidget);
    expect(find.text('Auditoria'), findsOneWidget);
  });
}
