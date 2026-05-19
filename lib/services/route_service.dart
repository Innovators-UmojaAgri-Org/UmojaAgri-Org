import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class RouteService {
  static const String _baseUrl = ApiConfig.baseUrl;

  Future<http.Response> getCurrentRoute(String token, String shipmentId) {
    final uri = Uri.parse('$_baseUrl/api/routes/$shipmentId/current');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> getRouteCost(String token, String routeId) {
    final uri = Uri.parse('$_baseUrl/api/routes/$routeId/cost');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> getRouteWaypoints(String token, String routeId) {
    final uri = Uri.parse('$_baseUrl/api/routes/$routeId/waypoints');
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> getAlternativeRoutes(
    String token,
    String origin,
    String destination,
  ) {
    final uri = Uri.parse(
      '$_baseUrl/api/routes/alternatives?origin=$origin&destination=$destination',
    );
    return http.get(uri, headers: {'Authorization': 'Bearer $token'});
  }

  Future<http.Response> acceptRoute({
    required String token,
    required String shipmentId,
    required String routeId,
  }) {
    final uri = Uri.parse('$_baseUrl/api/routes/accept');
    return http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'shipmentId': shipmentId, 'routeId': routeId}),
    );
  }

  Future<http.Response> createRoute({
    required String token,
    required String origin,
    required String destination,
    required double distanceKm,
    required double estimatedTimeMinutes,
    String? riskLevel,
    double? fuelCost,
    double? tollCost,
    List<String>? stops,
  }) {
    final uri = Uri.parse('$_baseUrl/api/routes');
    return http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'origin': origin,
        'destination': destination,
        'distanceKm': distanceKm,
        'estimatedTimeMinutes': estimatedTimeMinutes,
        if (riskLevel != null) 'riskLevel': riskLevel,
        if (fuelCost != null) 'fuelCost': fuelCost,
        if (tollCost != null) 'tollCost': tollCost,
        if (stops != null) 'stops': stops,
      }),
    );
  }
}
