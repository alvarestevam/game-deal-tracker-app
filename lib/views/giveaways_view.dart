import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_card.dart';

class GiveawaysView extends StatelessWidget {
  const GiveawaysView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogos Gratuitos'),
      ),
      body: Consumer<GameProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingGiveaways && provider.giveaways.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchGiveaways(),
            child: provider.giveaways.isEmpty
                ? ListView(
                    children: const [
                      SizedBox(height: 100),
                      Center(
                        child: Text(
                          'Nenhum jogo gratuito disponível no momento',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    itemCount: provider.giveaways.length,
                    itemBuilder: (context, index) {
                      final game = provider.giveaways[index];
                      return GameCard(game: game);
                    },
                  ),
          );
        },
      ),
    );
  }
}
