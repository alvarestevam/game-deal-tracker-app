import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/game_deal.dart';

class GameCard extends StatelessWidget {
  final GameModel game;

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
            if (game.imageUrl != null && game.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: game.imageUrl!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 150,
                    color: Colors.grey[800],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 150,
                    color: Colors.grey[800],
                    child: const Icon(Icons.broken_image, size: 50),
                  ),
                ),
              )
            else
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image_not_supported, size: 50),
              ),
            const SizedBox(height: 12),
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
            if (game.promoEndDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Termina em: ${_formatDayMonth(game.promoEndDate!)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else if (game.promoStartDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Começou em: ${_formatDayMonth(game.promoStartDate!)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
            const Divider(height: 24),
            ...game.offers.map((offer) => _buildOfferRow(context, offer)),
            const SizedBox(height: 8),
            Text(
              'Atualizado em: ${_formatDate(game.updatedAt)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferRow(BuildContext context, GameOffer offer) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          if (offer.storeIconUrl != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CachedNetworkImage(
                imageUrl: offer.storeIconUrl!,
                width: 24,
                height: 24,
                errorWidget: (context, url, error) => const Icon(Icons.store, size: 24),
              ),
            ),
          Expanded(
            child: Text(
              offer.displayStoreName,
              style: theme.textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            offer.estimatedFinalPrice == '0.0' || offer.estimatedFinalPrice == '0'
                ? 'GRÁTIS'
                : 'R\$ ${offer.estimatedFinalPrice}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.greenAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          if (offer.dealUrl != null)
            ElevatedButton(
              onPressed: () => launchUrl(Uri.parse(offer.dealUrl!)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                minimumSize: const Size(60, 30),
              ),
              child: const Text('Ver', style: TextStyle(fontSize: 12)),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatDayMonth(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
  }
}
