import 'package:dio/dio.dart';
import '../core/constants.dart';
import '../models/game_deal.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: apiBaseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  Future<List<GameDeal>> getGiveaways() async {
    try {
      final response = await _dio.get('/giveaways');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => GameDeal.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      print('Erro ao buscar giveaways: ${e.message}');
      return [];
    } catch (e) {
      print('Erro inesperado: $e');
      return [];
    }
  }

  Future<List<GameDeal>> getDeals() async {
    try {
      final response = await _dio.get('/deals');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => GameDeal.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      print('Erro ao buscar deals: ${e.message}');
      return [];
    } catch (e) {
      print('Erro inesperado: $e');
      return [];
    }
  }

  Future<GameDeal?> auditGame(String title) async {
    try {
      final encodedTitle = Uri.encodeComponent(title);
      final response = await _dio.get('/games/$encodedTitle/audit');
      if (response.statusCode == 200) {
        return GameDeal.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      print('Erro na auditoria: ${e.message}');
      return null;
    } catch (e) {
      print('Erro inesperado: $e');
      return null;
    }
  }
}
