// views/transporter/transporter_routes_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umoja_agri/controllers/transporter/transporter_controller.dart';
import 'package:umoja_agri/utils/app_colors.dart';
import 'package:umoja_agri/utils/app_routes.dart';

// ── Routes Screen ─────────────────────────────────────────────────────────────

class RoutesScreen extends StatefulWidget {
  const RoutesScreen({Key? key}) : super(key: key);

  @override
  State<RoutesScreen> createState() =>
      _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  late final TransporterController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = Get.find<TransporterController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundTrans,
      
      appBar: _buildAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _StatsSummary(totalDistance: '752 km', estTime: '11.5 hrs'),
          const SizedBox(height: 20),
          _RouteCard(
            title: 'Kaduna – Lagos Route',
            badge: _RouteBadge.active,
            distance: '752 km',
            duration: '11 hrs 30 min',
            trafficStatus: 'Moderate',
            trafficColor: AppColors.primaryOrange,
            trafficIcon: '🟠',
            totalTolls: '₦12,500',
            onSelect: () {},
            buttonLabel: 'Select Route',
            buttonFilled: false,
          ),
          const SizedBox(height: 14),
          _RouteCard(
            title: 'Alternative Route via Abuja',
            badge: _RouteBadge.aiPick,
            distance: '700 km',
            duration: '09 hrs 45 min',
            trafficStatus: 'Light',
            trafficColor: AppColors.primaryGreen,
            trafficIcon: '🟢',
            totalTolls: '₦9,300',
            onSelect: () => _showAiRouteSelectedDialog(context),
            buttonLabel: 'Select AI Route',
            buttonFilled: true,
          ),
          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: _BottomNav(ctrl: ctrl, selectedIndex: 1),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.buttonGreen,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.white),
        onPressed: () => Get.back(),
      ),
      title: const Text(
        'Routes',
        style: TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.notifications_outlined,
                color: AppColors.white,
                size: 26,
              ),
              Positioned(
                right: 0,
                top: 10,
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
        ),
      ],
    );
  }

  void _showAiRouteSelectedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black38,
      builder: (_) => const _AiRouteSelectedDialog(),
    ).then((_) {
      Get.toNamed(AppRoutes.transporterRouteDetails);
    });
  }
}

// ── Stats Summary ─────────────────────────────────────────────────────────────

class _StatsSummary extends StatelessWidget {
  final String totalDistance;
  final String estTime;

  const _StatsSummary({required this.totalDistance, required this.estTime});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Manage and optimize your delivery routes',
          style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _StatItem(label: 'Total Distance', value: totalDistance),
            
            _StatItem(label: 'Est. Time', value: estTime),
          ],
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
          ),
        ),
      ],
    );
  }
}

// ── Route Badge enum ──────────────────────────────────────────────────────────

enum _RouteBadge { active, aiPick }

// ── Route Card ────────────────────────────────────────────────────────────────

class _RouteCard extends StatelessWidget {
  final String title;
  final _RouteBadge badge;
  final String distance;
  final String duration;
  final String trafficStatus;
  final Color trafficColor;
  final String trafficIcon;
  final String totalTolls;
  final VoidCallback onSelect;
  final String buttonLabel;
  final bool buttonFilled;

  const _RouteCard({
    required this.title,
    required this.badge,
    required this.distance,
    required this.duration,
    required this.trafficStatus,
    required this.trafficColor,
    required this.trafficIcon,
    required this.totalTolls,
    required this.onSelect,
    required this.buttonLabel,
    required this.buttonFilled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundTrans,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              _buildBadge(),
            ],
          ),
          const SizedBox(height: 4),

          Text(
            '↑ $distance  •  $duration',
            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 14),

          // Traffic + Tolls row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Traffic Status',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(trafficIcon, style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text(
                          trafficStatus,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: trafficColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Tolls',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      totalTolls,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Action button
          SizedBox(
            width: double.infinity,
            child:
                buttonFilled
                    ? ElevatedButton(
                      onPressed: onSelect,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonGreen,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        buttonLabel,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    )
                    : OutlinedButton(
                      onPressed: onSelect,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: AppTheme.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        buttonLabel,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge() {
    switch (badge) {
      case _RouteBadge.active:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.backgroundGreen,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Active',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.darkGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      case _RouteBadge.aiPick:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.buttonGreen,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'AI Pick',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
    }
  }
}

// ── AI Route Selected Dialog ──────────────────────────────────────────────────

class _AiRouteSelectedDialog extends StatelessWidget {
  const _AiRouteSelectedDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      backgroundColor: AppTheme.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: const Icon(
                  Icons.close,
                  size: 20,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.primaryGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: AppColors.white,
                size: 34,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'AI Route Selected',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'And added to favorite routes',
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Progress bar
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.backgroundGreen,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.65,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Alternative Route Details Screen ─────────────────────────────────────────

class TransporterAlternativeRouteScreen extends StatelessWidget {
  const TransporterAlternativeRouteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<TransporterController>();
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppColors.buttonGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Route Details',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.white,
                  size: 26,
                ),
                Positioned(
                  right: 0,
                  top: 10,
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
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Title + AI Pick badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text(
                  'Alternative Route via Abuja',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.buttonGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'AI Pick',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            '812 km  •  12 hrs 45 min',
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 16),

          // 2×2 Stats grid
          const _RouteStatsGrid(
            trafficStatus: 'Light',
            trafficColor: AppColors.primaryGreen,
            totalTolls: '₦15,200',
            estFuelCost: '₦84,500',
            roadQuality: 'Good',
            roadQualityColor: AppColors.primaryGreen,
          ),
          const SizedBox(height: 20),

          // Why AI Picked This Route
          const _WhyAiCard(
            reasons: [
              'Light traffic conditions throughout the route',
              'Better road quality via Abuja expressway',
              'Lower fuel consumption on highway sections',
              'Fewer toll gates compared to direct route',
            ],
          ),
          const SizedBox(height: 20),

          // Route Waypoints
          const _RouteWaypoints(
            waypoints: [
              _Waypoint(
                label: 'Kaduna (Start)',
                distanceFromPrev: '0 km',
                timeFromPrev: '0 min',
                isFirst: true,
              ),
              _Waypoint(
                label: 'Abuja Junction',
                distanceFromPrev: '185 km',
                timeFromPrev: '2 hrs 10 min',
              ),
              _Waypoint(
                label: 'Lokoja',
                distanceFromPrev: '230 km',
                timeFromPrev: '2 hrs 50 min',
              ),
              _Waypoint(
                label: 'Ore',
                distanceFromPrev: '280 km',
                timeFromPrev: '3 hrs 20 min',
              ),
              _Waypoint(
                label: 'Lagos (End)',
                distanceFromPrev: '117 km',
                timeFromPrev: '1 hr 25 min',
                isLast: true,
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: _BottomNav(ctrl: ctrl, selectedIndex: 1),
    );
  }
}

// ── Route Stats Grid ──────────────────────────────────────────────────────────

class _RouteStatsGrid extends StatelessWidget {
  final String trafficStatus;
  final Color trafficColor;
  final String totalTolls;
  final String estFuelCost;
  final String roadQuality;
  final Color roadQualityColor;

  const _RouteStatsGrid({
    required this.trafficStatus,
    required this.trafficColor,
    required this.totalTolls,
    required this.estFuelCost,
    required this.roadQuality,
    required this.roadQualityColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCell(
                label: 'Traffic Status',
                value: trafficStatus,
                valueColor: trafficColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCell(
                label: 'Total Tolls',
                value: totalTolls,
                valueColor: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCell(
                label: 'Est. Fuel Cost',
                value: estFuelCost,
                valueColor: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCell(
                label: 'Road Quality',
                value: roadQuality,
                valueColor: roadQualityColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _StatCell({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Why AI Picked This Route card ─────────────────────────────────────────────

class _WhyAiCard extends StatelessWidget {
  final List<String> reasons;
  const _WhyAiCard({required this.reasons});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundGreen,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primaryGreen.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.primaryGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.psychology_outlined,
                  color: AppColors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Why AI Picked This Route',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...reasons.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Icon(
                      Icons.circle,
                      size: 6,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      r,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Route Waypoints ───────────────────────────────────────────────────────────

@immutable
class _Waypoint {
  final String label;
  final String distanceFromPrev;
  final String timeFromPrev;
  final bool isFirst;
  final bool isLast;

  const _Waypoint({
    required this.label,
    required this.distanceFromPrev,
    required this.timeFromPrev,
    this.isFirst = false,
    this.isLast = false,
  });
}

class _RouteWaypoints extends StatelessWidget {
  final List<_Waypoint> waypoints;
  const _RouteWaypoints({required this.waypoints});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundTrans,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Route Waypoints',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          ...waypoints.asMap().entries.map((entry) {
            final idx = entry.key;
            final wp = entry.value;
            final isLast = idx == waypoints.length - 1;
            return _WaypointRow(waypoint: wp, showLine: !isLast);
          }),
        ],
      ),
    );
  }
}

class _WaypointRow extends StatelessWidget {
  final _Waypoint waypoint;
  final bool showLine;
  const _WaypointRow({required this.waypoint, required this.showLine});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline column
        SizedBox(
          width: 24,
          child: Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.primaryGreen,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child:
                      waypoint.isFirst
                          ? const Text(
                            '1',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                          : const Icon(
                            Icons.circle,
                            size: 6,
                            color: AppColors.white,
                          ),
                ),
              ),
              if (showLine)
                Container(width: 1.5, height: 36, color: AppColors.backgroundTrans),
            ],
          ),
        ),
        const SizedBox(width: 12),

        // Label + meta
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  waypoint.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${waypoint.distanceFromPrev}  •  ${waypoint.timeFromPrev}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Shared Bottom Nav ─────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final TransporterController ctrl;
  final int selectedIndex;
  const _BottomNav({required this.ctrl, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (i) {
          ctrl.selectTab(i);
          if (i == 0) Get.back();
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.iconGreen,
        unselectedItemColor: Colors.grey,
        backgroundColor: AppTheme.surface,
        elevation: 0,
        selectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping_outlined),
            activeIcon: Icon(Icons.local_shipping),
            label: 'My Loads',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.route_outlined),
            activeIcon: Icon(Icons.route),
            label: 'Routes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_outlined),
            activeIcon: Icon(Icons.attach_money),
            label: 'Earnings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            activeIcon: Icon(Icons.description),
            label: 'Documents',
          ),
        ],
      ),
    );
  }
}
