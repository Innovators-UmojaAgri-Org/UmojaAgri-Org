// views/transporter/transporter_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umoja_agri/controllers/transporter/transporter_controller.dart';
import 'package:umoja_agri/models/transporter/transporter_model.dart';
import 'package:umoja_agri/utils/app_colors.dart';
import 'package:umoja_agri/utils/app_routes.dart';

class TransporterScreen extends StatefulWidget {
  const TransporterScreen({Key? key}) : super(key: key);

  @override
  State<TransporterScreen> createState() => _TransporterScreenState();
}

class _TransporterScreenState extends State<TransporterScreen> {
  late final TransporterController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = Get.put(TransporterController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundTrans,
      appBar: _buildAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ActiveShipmentCard(ctrl: ctrl),
          const SizedBox(height: 16),
          _StatusSelector(ctrl: ctrl),
          const SizedBox(height: 20),
          _AiTrafficPrediction(ctrl: ctrl),
          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: _BottomNav(ctrl: ctrl),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.buttonGreen,
      elevation: 0,
      titleSpacing: 4,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          final initial =
              ctrl.transporter.value?.name.substring(0, 1).toUpperCase() ?? 'A';
          return CircleAvatar(
            backgroundColor: Color.fromRGBO(0, 201, 80, 1),
            child: Text(
              initial,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }),
      ),

      title: Obx(() {
        final name = ctrl.transporter.value?.name ?? '';
        //reducing space between icon of the name and the welcome text

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome,',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        );
      }),
      actions: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 6, top: 12),
              child: Icon(
                Icons.notifications_outlined,
                color: Colors.white,
                size: 26,
              ),
            ),
            Positioned(
              right: 10,
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
      ],
    );
  }
}

// ── Active Shipment Card

class _ActiveShipmentCard extends StatelessWidget {
  final TransporterController ctrl;
  const _ActiveShipmentCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final s =
          ctrl.activeShipments.isNotEmpty ? ctrl.activeShipments.first : null;

      if (s == null) {
        return const Center(child: Text('No active shipments'));
      }

      return Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundTrans,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Active Shipment',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                _StatusBadge(label: s.status),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Produce',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Text('🍅', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const Text(
                      'Fresh Grade A',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Color.fromRGBO(220, 243, 213, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  _RouteStop(
                    icon: Icons.radio_button_checked,
                    iconColor: AppTheme.primary,
                    label: 'Pickup',
                    city: s.origin,
                    subtitle: 'Sabon Gari Farm Complex',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      width: 1.5,
                      height: 20,
                      color: AppTheme.primary.withOpacity(0.3),
                    ),
                  ),
                  _RouteStop(
                    icon: Icons.location_on,
                    iconColor: AppTheme.primary,
                    label: 'Destination',
                    city: s.destination,
                    subtitle: 'Mile 12 International Market',
                    eta: 'Estimated Time of Arrival: ${s.departureTime}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Get.toNamed(AppRoutes.transporterRoutes),
                icon: const Icon(
                  Icons.navigation,
                  size: 16,
                  color: Colors.white,
                ),
                label: const Text(
                  'AI-Recommended Route',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ── Route Stop

class _RouteStop extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String city;
  final String subtitle;
  final String? eta;

  const _RouteStop({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.city,
    required this.subtitle,
    this.eta,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            Text(
              city,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            if (eta != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  eta!,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.primary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// ── Status Badge

class _StatusBadge extends StatelessWidget {
  final String label;
  const _StatusBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.confirmed.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: AppTheme.confirmed,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── Status Selector

class _StatusSelector extends StatelessWidget {
  final TransporterController ctrl;
  const _StatusSelector({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // ✅ Obx at top of build(), directly reading ctrl.activeShipments
      if (ctrl.activeShipments.isEmpty) return const SizedBox.shrink();
      final s = ctrl.activeShipments.first;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Update Shipment Status',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Row(
            children:
                ShipmentStatus.values.sublist(0, 3).map((stat) {
                  final label = ctrl.statusToString(stat);
                  final selected = s.shipmentStatus == stat;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => ctrl.updateShipmentStatus(s.id, stat),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color:
                              selected ? AppTheme.primary : Colors.transparent,
                          border: Border.all(
                            color:
                                selected ? AppTheme.primary : AppTheme.border,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            label,
                            style: TextStyle(
                              color:
                                  selected
                                      ? Colors.white
                                      : AppTheme.textPrimary,
                              fontSize: 12,
                              fontWeight:
                                  selected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      );
    });
  }
}

// ── AI Traffic Prediction

class _AiTrafficPrediction extends StatelessWidget {
  final TransporterController ctrl;
  const _AiTrafficPrediction({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4F0),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.pending.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.pending.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: AppTheme.pending,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'AI Traffic Prediction',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
              const Spacer(),
              const Icon(Icons.open_in_new, size: 14, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 10),
          // ✅ Obx only around the section that reads the observable
          Obx(() {
            if (ctrl.routeRecommendations.isEmpty)
              return const SizedBox.shrink();
            final note = ctrl.routeRecommendations.first.note;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '45min Traffic Delay detected on your current route.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.pending,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  note.isNotEmpty
                      ? note
                      : 'Rerouting recommended to preserve tomato freshness and maintain optimal delivery temperature.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.pending.withOpacity(0.85),
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.pending,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Get.toNamed(AppRoutes.transporterRoutes),
              child: const Text(
                'View Alternative Route',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bottom Nav

class _BottomNav extends StatelessWidget {
  final TransporterController ctrl;
  const _BottomNav({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // ✅ Directly reads ctrl.selectedTabIndex.value here
      return BottomNavigationBar(
        currentIndex: ctrl.selectedTabIndex.value,
        onTap: (i) {
          ctrl.selectTab(i);
          if (i == 1) Get.toNamed(AppRoutes.transporterRoutes);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: Colors.grey,
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
      );
    });
  }
}
