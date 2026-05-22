class GameDeal {
  final int id;
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
      id: json['id'] as int,
      title: json['title'] as String,
      currentPrice: json['current_price'].toString(),
      historicalLow: json['historical_low'].toString(),
      originalPrice: json['original_price']?.toString(),
      platform: json['platform'] as String?,
      isFree: json['is_free'] as bool,
      isHistoricalLow: json['is_historical_low'] as bool? ?? false,
      updatedAt: DateTime.parse(json['updated_at'] as String),
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
