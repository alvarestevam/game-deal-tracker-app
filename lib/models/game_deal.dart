class GameDeal {
  final int id;
  final String title;
  final String currentPrice;
  final String historicalLow;
  final bool isFree;
  final DateTime updatedAt;

  GameDeal({
    required this.id,
    required this.title,
    required this.currentPrice,
    required this.historicalLow,
    required this.isFree,
    required this.updatedAt,
  });

  factory GameDeal.fromJson(Map<String, dynamic> json) {
    return GameDeal(
      id: json['id'] as int,
      title: json['title'] as String,
      currentPrice: json['current_price'].toString(),
      historicalLow: json['historical_low'].toString(),
      isFree: json['is_free'] as bool,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
