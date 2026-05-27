import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_card.dart';
import '../widgets/game_card_skeleton.dart';

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
            return ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => const GameCardSkeleton(),
            );
          }

          final sortedDeals = List.from(provider.deals)
            ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

          final recentDeals = List.from(provider.deals)
            ..sort((a, b) {
              if (a.promoStartDate == null && b.promoStartDate == null) return 0;
              if (a.promoStartDate == null) return 1;
              if (b.promoStartDate == null) return -1;
              return b.promoStartDate!.compareTo(a.promoStartDate!);
            });

          final topRecentDeals = recentDeals.take(10).toList();

          return RefreshIndicator(
            onRefresh: () => provider.fetchDeals(),
            child: sortedDeals.isEmpty
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
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Text(
                            'Ofertas Recentes',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 350,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            itemCount: topRecentDeals.length,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: 340,
                                child: GameCard(game: topRecentDeals[index]),
                              );
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                          child: Text(
                            'Todas as Ofertas',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 16),
                          itemCount: sortedDeals.length,
                          itemBuilder: (context, index) {
                            final game = sortedDeals[index];
                            return GameCard(game: game);
                          },
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
