import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_card.dart';

class DealsView extends StatelessWidget {
  const DealsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promoções'),
      ),
      body: Consumer<GameProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingDeals && provider.deals.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchDeals(),
            child: provider.deals.isEmpty
                ? ListView(
                    children: const [
                      SizedBox(height: 100),
                      Center(
                        child: Text(
                          'Nenhuma promoção disponível no momento',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    itemCount: provider.deals.length,
                    itemBuilder: (context, index) {
                      final game = provider.deals[index];
                      return GameCard(game: game);
                    },
                  ),
          );
        },
      ),
    );
  }
}
