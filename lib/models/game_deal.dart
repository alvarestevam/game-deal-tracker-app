class GameDeal {
  final String id;
  final String title;
  final String currentPrice;
  final String historicalLow;
  final String? originalPrice;
  final String? platform;
  final String? storeName;
  final String? dealUrl;
  final bool isFree;
  final bool isHistoricalLow;
  final DateTime updatedAt;
  final DateTime? promoStartDate;
  final DateTime? promoEndDate;

  GameDeal({
    required this.id,
    required this.title,
    required this.currentPrice,
    required this.historicalLow,
    this.originalPrice,
    this.platform,
    this.storeName,
    this.dealUrl,
    required this.isFree,
    required this.isHistoricalLow,
    required this.updatedAt,
    this.promoStartDate,
    this.promoEndDate,
  });

  factory GameDeal.fromJson(Map<String, dynamic> json) {
    return GameDeal(
      id: json['id']?.toString() ?? '', // Usa vazio se id faltar
      title: json['title'] as String,
      currentPrice: json['current_price']?.toString() ?? '0.0',
      historicalLow: json['historical_low']?.toString() ?? '0.0',
      originalPrice: json['original_price']?.toString(), // Permanece null se faltar
      platform: json['platform'] as String?,
      storeName: json['store_name']?.toString(),
      dealUrl: json['deal_url']?.toString(),
      isFree: json['is_free'] as bool? ?? false, // Default false se faltar
      isHistoricalLow: json['is_historical_low'] as bool? ?? false,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(), // Usa data atual se faltar
      promoStartDate: json['promo_start_date'] != null
          ? DateTime.tryParse(json['promo_start_date'].toString())
          : null,
      promoEndDate: json['promo_end_date'] != null
          ? DateTime.tryParse(json['promo_end_date'].toString())
          : null,
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

  String get displayStoreName {
    if (storeName == null ||
        storeName!.isEmpty ||
        RegExp(r'^\d+$').hasMatch(storeName!)) {
      return "Ver Oferta";
    }
    return storeName!;
  }
}
