import 'package:flutter_test/flutter_test.dart';
import 'package:gamedeal_tracker/providers/game_provider.dart';

void main() {
  group('GameProvider Audit Logic', () {
    test('Initial state is correct', () {
      final provider = GameProvider();
      expect(provider.isAuditing, false);
      expect(provider.games, isEmpty);
    });
  });
}
