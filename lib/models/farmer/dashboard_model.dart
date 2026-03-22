class DashboardStatsModel {
  final String farmerName;
  final double monthlyRevenue;
  final int notificationsCount;
  final List<Map<String, dynamic>> yieldTrends;
  final List<Map<String, dynamic>> recentShipments;

  DashboardStatsModel({
    required this.farmerName,
    required this.monthlyRevenue,
    required this.notificationsCount,
    required this.yieldTrends,
    required this.recentShipments,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      farmerName: json['user']['name'] ?? '',
      monthlyRevenue: (json['monthly_revenue'] ?? 0).toDouble(),
      notificationsCount: json['notifications_count'] ?? 0,
      yieldTrends: List<Map<String, dynamic>>.from(json['yield_trends'] ?? []),
      recentShipments: List<Map<String, dynamic>>.from(
        json['recent_shipments'] ?? [],
      ),
    );
  }
}
