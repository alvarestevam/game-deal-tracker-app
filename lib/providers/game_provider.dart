import 'package:flutter/material.dart';
import '../models/game_deal.dart';
import '../services/api_service.dart';

class GameProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<GameModel> _giveaways = [];
  List<GameModel> _deals = [];
  List<GameModel> _bestDeals = [];
  bool _isLoadingGiveaways = false;
  bool _isLoadingDeals = false;
  bool _isLoadingBestDeals = false;

  // Auditoria
  List<GameAuditResponse> _games = [];
  bool _isAuditing = false;

  List<GameModel> get giveaways => _giveaways;
  List<GameModel> get deals => _deals;
  List<GameModel> get bestDeals => _bestDeals;
  bool get isLoadingGiveaways => _isLoadingGiveaways;
  bool get isLoadingDeals => _isLoadingDeals;
  bool get isLoadingBestDeals => _isLoadingBestDeals;

  List<GameAuditResponse> get games => _games;
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

  Future<void> fetchBestDeals() async {
    _isLoadingBestDeals = true;
    notifyListeners();

    try {
      _bestDeals = await _apiService.getBestDeals();
    } finally {
      _isLoadingBestDeals = false;
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
    _games = [];
    notifyListeners();

    try {
      final results = await _apiService.auditGame(title);
      _games = results;
      return results.isNotEmpty;
    } finally {
      _isAuditing = false;
      notifyListeners();
    }
  }
}
