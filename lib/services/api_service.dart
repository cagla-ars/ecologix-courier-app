import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/shipment.dart';
import '../models/route_summary.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';

  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['role'] != 'COURIER') {
        throw Exception(
          'Bu uygulamaya sadece kurye kullanıcıları giriş yapabilir.',
        );
      }

      if (data['courierId'] == null) {
        throw Exception(
          'Bu kullanıcı bir kurye hesabına bağlı değil.',
        );
      }

      return Map<String, dynamic>.from(data);
    }

    throw Exception('Kullanıcı adı veya şifre hatalı.');
  }

  static Future<List<Shipment>> getActiveRoute(int courierId) async {
    final url = Uri.parse(
      '$baseUrl/shipments/courier/$courierId/active-route',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body);

      return list
          .map((item) => Shipment.fromJson(item))
          .toList();
    }

    throw Exception('Aktif rota alınamadı.');
  }

  static Future<int> getTodayDeliveredCount(
    int courierId,
  ) async {
    final url = Uri.parse(
      '$baseUrl/shipments/courier/$courierId/today-delivered-count',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return int.tryParse(response.body) ?? 0;
    }

    throw Exception(
      'Bugün teslim edilen sayısı alınamadı.',
    );
  }

  static Future<void> updateCourierLocation({
    required int courierId,
    required double lat,
    required double lon,
  }) async {
    final url = Uri.parse(
      '$baseUrl/couriers/$courierId/location?lat=$lat&lon=$lon',
    );

    final response = await http.patch(url);

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception('Kurye konumu güncellenemedi.');
    }
  }

  static Future<void> deliverShipment(
    int shipmentId,
  ) async {
    final url = Uri.parse(
      '$baseUrl/shipments/$shipmentId/deliver',
    );

    final response = await http.post(url);

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        'Teslimat tamamlanamadı.',
      );
    }
  }

  static Future<void> changePassword({
    required String username,
    required String oldPassword,
    required String newPassword,
  }) async {
    final url = Uri.parse(
      '$baseUrl/auth/change-password',
    );

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        response.body.isEmpty
            ? 'Şifre güncellenemedi.'
            : response.body,
      );
    }
  }

  static Future<RouteSummary> getOptimizedRoute(
    int courierId,
  ) async {
    final response = await http.post(
      Uri.parse(
        '$baseUrl/routing/assign-best/$courierId',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Optimizasyon sonucu alınamadı.',
      );
    }

    return RouteSummary.fromJson(
      Map<String, dynamic>.from(
        jsonDecode(response.body),
      ),
    );
  }
}