import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/game_provider.dart';

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
          return const Center(child: CircularProgressIndicator());
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
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Preço Atual: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(game.isFree ? 'GRÁTIS' : 'R\$ ${game.currentPrice}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Menor Preço Histórico: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('R\$ ${game.historicalLow}'),
                      ],
                    ),
                    if (game.isHistoricalLow) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'MENOR PREÇO HISTÓRICO!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    if (game.dealUrl != null) ...[
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => launchUrl(Uri.parse(game.dealUrl!)),
                          child: Text(
                            game.displayStoreName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatDayMonth(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
  }
}
