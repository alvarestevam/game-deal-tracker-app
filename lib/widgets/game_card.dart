import 'package:flutter/material.dart';
import '../models/game_deal.dart';

class GameCard extends StatelessWidget {
  final GameDeal game;

  const GameCard({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (game.platform != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            game.platform!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (game.isFree)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'GRÁTIS',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'R\$ ${game.currentPrice}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (game.discountPercentage != null)
                        Text(
                          '-${game.discountPercentage}%',
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Atualizado em: ${_formatDate(game.updatedAt)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
