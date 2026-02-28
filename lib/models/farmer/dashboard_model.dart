class DashboardStatsModel {
  final String farmerName;
  final double monthlyRevenue;
  final int newOrders;
  final int totalCrops;
  final List<Map<String, dynamic>> weeklyYield;

  DashboardStatsModel({
    required this.farmerName,
    required this.monthlyRevenue,
    required this.newOrders,
    required this.totalCrops,
    required this.weeklyYield,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      farmerName: json['farmerName'],
      monthlyRevenue: json['monthlyRevenue'].toDouble(),
      newOrders: json['newOrders'],
      totalCrops: json['totalCrops'],
      weeklyYield: List<Map<String, dynamic>>.from(json['weeklyYield']),
    );
  }
}
