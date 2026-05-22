class GameDeal {
  final String id;
  final String title;
  final String currentPrice;
  final String historicalLow;
  final String? originalPrice;
  final String? platform;
  final bool isFree;
  final bool isHistoricalLow;
  final DateTime updatedAt;

  GameDeal({
    required this.id,
    required this.title,
    required this.currentPrice,
    required this.historicalLow,
    this.originalPrice,
    this.platform,
    required this.isFree,
    required this.isHistoricalLow,
    required this.updatedAt,
  });

  factory GameDeal.fromJson(Map<String, dynamic> json) {
    return GameDeal(
      id: json['id']?.toString() ?? '', // Usa vazio se id faltar
      title: json['title'] as String,
      currentPrice: json['current_price']?.toString() ?? '0.0',
      historicalLow: json['historical_low']?.toString() ?? '0.0',
      originalPrice: json['original_price']?.toString(), // Permanece null se faltar
      platform: json['platform'] as String?,
      isFree: json['is_free'] as bool? ?? false, // Default false se faltar
      isHistoricalLow: json['is_historical_low'] as bool? ?? false,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(), // Usa data atual se faltar
    );
  }

  int? get discountPercentage {
    if (isFree) return 100;

    final current = double.tryParse(currentPrice);
    final original = double.tryParse(originalPrice ?? '');

    if (current != null && original != null && original > 0) {
      final discount = ((original - current) / original) * 100;
      return discount > 0 ? discount.round() : null;
    }

    return null;
  }
}
