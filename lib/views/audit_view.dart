import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/game_provider.dart';
import '../models/game_deal.dart';
import '../widgets/game_card_skeleton.dart';

class AuditView extends StatefulWidget {
  const AuditView({super.key});

  @override
  State<AuditView> createState() => _AuditViewState();
}

class _AuditViewState extends State<AuditView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auditoria de Preços'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Nome do Jogo',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _performAudit(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _performAudit,
                child: const Text('Auditar Preço'),
              ),
            ),
            const SizedBox(height: 24),
            const Expanded(
              child: AuditResultView(),
            ),
          ],
        ),
      ),
    );
  }

  void _performAudit() async {
    final title = _searchController.text.trim();
    if (title.isEmpty) return;

    final provider = Provider.of<GameProvider>(context, listen: false);
    final success = await provider.auditGame(title);

    if (success) {
      _searchController.clear();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jogo não encontrado ou erro de conexão')),
      );
    }
  }
}

class AuditResultView extends StatelessWidget {
  const AuditResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, child) {
        if (provider.isAuditing) {
          return ListView.builder(
            itemCount: 3,
            itemBuilder: (context, index) => const GameCardSkeleton(),
          );
        }

        final games = provider.games;
        if (games.isEmpty) {
          return const Center(
            child: Text('Nenhum jogo encontrado'),
          );
        }

        return ListView.separated(
          itemCount: games.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final game = games[index];
            return Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (game.imageUrl != null && game.imageUrl!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: game.imageUrl!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            httpHeaders: const {'User-Agent': 'GamesInDealApp/1.0'},
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[800]!,
                              highlightColor: Colors.grey[600]!,
                              child: Container(
                                height: 200,
                                width: double.infinity,
                                color: Colors.white,
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.grey[800],
                              child: const Icon(Icons.broken_image, size: 50),
                            ),
                          ),
                        ),
                      ),
                    Text(
                      game.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (game.promoEndDate != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Termina em: ${_formatDayMonth(game.promoEndDate!)}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.orangeAccent,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      )
                    else if (game.promoStartDate != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Começou em: ${_formatDayMonth(game.promoStartDate!)}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                      ),
                    const Divider(height: 32),
                    ...game.offers.map((offer) => _buildAuditOfferRow(context, offer)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAuditOfferRow(BuildContext context, GameOffer offer) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (offer.storeIconUrl != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CachedNetworkImage(
                    imageUrl: offer.storeIconUrl!,
                    width: 32,
                    height: 32,
                    httpHeaders: const {'User-Agent': 'GamesInDealApp/1.0'},
                    errorWidget: (context, url, error) => CircleAvatar(
                      radius: 16,
                      child: Text(
                        offer.displayStoreName.isNotEmpty ? offer.displayStoreName[0] : '?',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: Text(
                  offer.displayStoreName,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Preço Atual: ', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                offer.estimatedFinalPrice == '0.0' || offer.estimatedFinalPrice == '0'
                    ? 'GRÁTIS'
                    : 'R\$ ${offer.estimatedFinalPrice}',
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Text('Menor Preço Histórico: ', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('R\$ ${offer.historicalLow}'),
            ],
          ),
          if (offer.currentPrice == offer.historicalLow &&
              offer.currentPrice != '0.0' &&
              offer.currentPrice != '0') ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'MENOR PREÇO HISTÓRICO!',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ],
          if (offer.dealUrl != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => launchUrl(Uri.parse(offer.dealUrl!)),
                child: const Text('Ver na Loja'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDayMonth(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
  }
}
