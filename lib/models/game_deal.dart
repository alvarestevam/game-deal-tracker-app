typedef GameAuditResponse = GameModel;

class GameOffer {
  final String? storeName;
  final String? storeIconUrl;
  final String currentPrice;
  final String historicalLow;
  final String estimatedFinalPrice;
  final String? dealUrl;

  GameOffer({
    this.storeName,
    this.storeIconUrl,
    required this.currentPrice,
    required this.historicalLow,
    required this.estimatedFinalPrice,
    this.dealUrl,
  });

  factory GameOffer.fromJson(Map<String, dynamic> json) {
    return GameOffer(
      storeName: json['store_name']?.toString(),
      storeIconUrl: json['store_icon_url']?.toString(),
      currentPrice: json['current_price']?.toString() ?? '0.0',
      historicalLow: json['historical_low']?.toString() ?? '0.0',
      estimatedFinalPrice: json['estimated_final_price']?.toString() ?? '0.0',
      dealUrl: json['deal_url']?.toString(),
    );
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

class GameModel {
  final String id;
  final String title;
  final String? platform;
  final DateTime updatedAt;
  final DateTime? promoStartDate;
  final DateTime? promoEndDate;
  final String? imageUrl;
  final List<GameOffer> offers;

  GameModel({
    required this.id,
    required this.title,
    this.platform,
    required this.updatedAt,
    this.promoStartDate,
    this.promoEndDate,
    this.imageUrl,
    required this.offers,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    var offersList = json['offers'] as List? ?? [];
    List<GameOffer> parsedOffers =
        offersList.map((i) => GameOffer.fromJson(i)).toList();

    return GameModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String,
      platform: json['platform'] as String?,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
      promoStartDate: json['promo_start_date'] != null
          ? DateTime.tryParse(json['promo_start_date'].toString())
          : null,
      promoEndDate: json['promo_end_date'] != null
          ? DateTime.tryParse(json['promo_end_date'].toString())
          : null,
      imageUrl: json['image_url']?.toString(),
      offers: parsedOffers,
    );
  }
}
