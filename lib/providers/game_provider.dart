import 'package:flutter/material.dart';
import '../models/game_deal.dart';
import '../services/api_service.dart';

class GameProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<GameDeal> _giveaways = [];
  List<GameDeal> _deals = [];
  bool _isLoadingGiveaways = false;
  bool _isLoadingDeals = false;

  // Auditoria
  GameDeal? _auditedGame;
  bool _isAuditing = false;

  List<GameDeal> get giveaways => _giveaways;
  List<GameDeal> get deals => _deals;
  bool get isLoadingGiveaways => _isLoadingGiveaways;
  bool get isLoadingDeals => _isLoadingDeals;

  GameDeal? get auditedGame => _auditedGame;
  bool get isAuditing => _isAuditing;

  Future<void> fetchGiveaways() async {
    _isLoadingGiveaways = true;
    notifyListeners();

    try {
      _giveaways = await _apiService.getGiveaways();
    } finally {
      _isLoadingGiveaways = false;
      notifyListeners();
    }
  }

  Future<void> fetchDeals() async {
    _isLoadingDeals = true;
    notifyListeners();

    try {
      _deals = await _apiService.getDeals();
    } finally {
      _isLoadingDeals = false;
      notifyListeners();
    }
  }

  Future<bool> auditGame(String title) async {
    _isAuditing = true;
    _auditedGame = null;
    notifyListeners();

    try {
      final result = await _apiService.auditGame(title);
      _auditedGame = result;
      return result != null;
    } finally {
      _isAuditing = false;
      notifyListeners();
    }
  }
}
