import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umoja_agri/views/farmer/crop_view.dart';
import 'package:umoja_agri/views/farmer/ship_view.dart';
import 'package:umoja_agri/views/farmer/finance_view.dart';
import '../../controllers/farmer/dashboard_controller.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key? key}) : super(key: key);

  final DashboardController controller = Get.find<DashboardController>();
  final RxInt selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: const Color(0xFFEAF0DC),
        body: SafeArea(child: _buildBody()),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildBody() {
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    // ── fallback if data is null or error
    final data = controller.dashboardData.value ?? _fallbackData();

    return IndexedStack(
      index: selectedIndex.value,
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // ── HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.grey.shade300,
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome,",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            data.farmerName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "You did great in the past 28 days",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.notifications_none, size: 24),
                      ),
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // ── REVENUE CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B4D1F), Color(0xFF2E7D32)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "February",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "₦${data.monthlyRevenue.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: 0.7,
                        minHeight: 7,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.orange,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "70% profit",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              // ── STATS ROW
              Row(
                children: [
                  _statCard(
                    "New Orders",
                    data.newOrders.toString(),
                    Icons.receipt_long_outlined,
                    const Color(0xFF1B5E20),
                  ),
                  const SizedBox(width: 12),
                  _statCard(
                    "Total Crops",
                    data.totalCrops.toString(),
                    Icons.eco_outlined,
                    const Color(0xFF2E7D32),
                  ),
                ],
              ),

              const SizedBox(height: 26),

              // ── ACTIVITIES
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Activities",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "See All",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 2.2,
                children: [
                  _ActivityCard(
                    title: "New Crop",
                    icon: Icons.eco,
                    iconColor: const Color(0xFF2E7D32),
                    bgColor: const Color(0xFFE2EDD4),
                    onTap: () => selectedIndex.value = 1,
                  ),
                  const _ActivityCard(
                    title: "Weather",
                    icon: Icons.cloud_outlined,
                    iconColor: Color(0xFF1565C0),
                    bgColor: Color(0xFFE2EDD4),
                  ),
                  _ActivityCard(
                    title: "Inventory",
                    icon: Icons.agriculture,
                    iconColor: const Color(0xFF6D4C41),
                    bgColor: const Color(0xFFE2EDD4),
                    onTap: () => selectedIndex.value = 2,
                  ),
                  _ActivityCard(
                    title: "Reports",
                    icon: Icons.bar_chart_rounded,
                    iconColor: const Color(0xFFE65100),
                    bgColor: const Color(0xFFE2EDD4),
                    onTap: () => selectedIndex.value = 3,
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ── YIELD TRENDS
              const Text(
                "Yields Trends",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 60),

              Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    right: 30,
                    top: -58,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.orange.shade300,
                          width: 1,
                        ),
                      ),
                      child: const Text(
                        "Thursday yield was high\n—consider booking extra\ntransport for next week",
                        style: TextStyle(fontSize: 9, color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: data.weeklyYield.map((y) {
                      final colors = [
                        Colors.teal,
                        const Color(0xFF1B5E20),
                        Colors.lightGreen,
                        Colors.orange,
                        Colors.deepOrange,
                      ];
                      final idx = data.weeklyYield.indexOf(y);
                      return _bar(
                        y.value,
                        y.day,
                        colors[idx % colors.length],
                      );
                    }).toList(),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // ── REFRESH BUTTON
              if (controller.hasError.value)
                Center(
                  child: TextButton.icon(
                    onPressed: () => controller.refreshDashboard(),
                    icon: const Icon(Icons.refresh, color: Color(0xFF2E7D32)),
                    label: const Text(
                      "Refresh Data",
                      style: TextStyle(color: Color(0xFF2E7D32)),
                    ),
                  ),
                ),

              const SizedBox(height: 40),
            ],
          ),
        ),

        CropScreen(),
        ShipmentScreen(),
        const financeScreen(),
      ],
    );
  }

  // ── FALLBACK DATA when API fails
  DashboardStatsModel _fallbackData() {
    return DashboardStatsModel.fromJson({
      "farmerName": "Farmer",
      "monthlyRevenue": 280836.00,
      "newOrders": 0,
      "totalCrops": 0,
      "weeklyYield": [
        {"day": "Mon", "value": 16},
        {"day": "Tues", "value": 22},
        {"day": "Wed", "value": 27},
        {"day": "Peak\nThurs", "value": 45},
        {"day": "Fri", "value": 33},
      ],
    });
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _bar(int value, String day, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          value.toString(),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        ),
        const SizedBox(height: 5),
        Container(
          height: value * 2.2,
          width: 30,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 52,
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  // ── BOTTOM NAV
  Widget _buildBottomNav() {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFFEAF0DC),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home_rounded, "Home", 0),
          _navItem(Icons.eco_rounded, "Crop", 1),
          _navItem(Icons.local_shipping_rounded, "Shipment", 2),
          _navItem(Icons.account_balance_wallet_rounded, "Finance", 3),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isSelected = selectedIndex.value == index;
    return GestureDetector(
      onTap: () => selectedIndex.value = index,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color:
                  isSelected ? const Color(0xFF2E7D32) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 22,
              color:
                  isSelected ? Colors.white : const Color(0xFF4A7C3F),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color:
                  isSelected ? const Color(0xFF2E7D32) : Colors.black45,
              fontWeight:
                  isSelected ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final VoidCallback? onTap;

  const _ActivityCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 22, color: iconColor),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
