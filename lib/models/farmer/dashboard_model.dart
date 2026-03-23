class WeeklyYield {
  final String day;
  final int value;

  const WeeklyYield({required this.day, required this.value});

  factory WeeklyYield.fromJson(Map<String, dynamic> json) {
    return WeeklyYield(
      day: json['day'] ?? '',
      value: json['value'] ?? 0,
    );
  }
}

class DashboardStatsModel {
  final String farmerName;
  final double monthlyRevenue;
  final int newOrders;
  final int totalCrops;
  final List<WeeklyYield> weeklyYield;

  const DashboardStatsModel({
    required this.farmerName,
    required this.monthlyRevenue,
    required this.newOrders,
    required this.totalCrops,
    required this.weeklyYield,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    final yields = (json['weeklyYield'] as List? ?? [])
        .map((y) => WeeklyYield.fromJson(y))
        .toList();

    return DashboardStatsModel(
      farmerName: json['farmerName'] ?? 'Farmer',
      monthlyRevenue: (json['monthlyRevenue'] ?? 0).toDouble(),
      newOrders: json['newOrders'] ?? 0,
      totalCrops: json['totalCrops'] ?? 0,
      weeklyYield: yields.isNotEmpty
          ? yields
          : [
              WeeklyYield(day: 'Mon', value: 16),
              WeeklyYield(day: 'Tues', value: 22),
              WeeklyYield(day: 'Wed', value: 27),
              WeeklyYield(day: 'Peak\nThurs', value: 45),
              WeeklyYield(day: 'Fri', value: 33),
            ],
    );
  }
}
