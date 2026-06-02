import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class GameCardSkeleton extends StatelessWidget {
  const GameCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final baseColor = Colors.grey[800]!;
    final highlightColor = Colors.grey[600]!;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 20,
                width: 200,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Container(
                height: 14,
                width: 100,
                color: Colors.white,
              ),
              const Divider(height: 24),
              // Simula duas ofertas
              _buildOfferSkeleton(),
              const SizedBox(height: 8),
              _buildOfferSkeleton(),
              const SizedBox(height: 12),
              Container(
                height: 14,
                width: 150,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOfferSkeleton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 16,
            width: 100,
            color: Colors.white,
          ),
          const Spacer(),
          Container(
            height: 16,
            width: 60,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Container(
            height: 30,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
