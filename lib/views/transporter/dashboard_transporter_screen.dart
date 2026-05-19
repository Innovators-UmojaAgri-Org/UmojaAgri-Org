// views/transporter/transporter_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:umoja_agri/controllers/auth_controller.dart';
import 'package:umoja_agri/controllers/transporter/transporter_controller.dart';
import 'package:umoja_agri/models/transporter/transporter_model.dart';
import 'package:umoja_agri/services/auth_service.dart';
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
    // Use Get.find() to get the existing controller (created by binding)
    ctrl = Get.find<TransporterController>();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Show loading indicator while data is loading (but include nav)
      if (ctrl.isLoading.value) {
        return Scaffold(
          backgroundColor: AppColors.backgroundTrans,
          appBar: _buildAppBar(),
          body: const Center(child: CircularProgressIndicator()),
          bottomNavigationBar: _BottomNav(ctrl: ctrl),
        );
      }

      // Show error state if data load failed and we have no transporter data
      if (ctrl.errorMessage.isNotEmpty && ctrl.transporter.value == null) {
        return Scaffold(
          backgroundColor: AppColors.backgroundTrans,
          appBar: _buildAppBar(),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  ctrl.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => ctrl.loadTransporterData(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          bottomNavigationBar: _BottomNav(ctrl: ctrl),
        );
      }

      // Show main content once data is loaded (even if no shipments)
      return Scaffold(
        backgroundColor: AppColors.backgroundTrans,
        appBar: _buildAppBar(),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _JobsSection(ctrl: ctrl),
            const SizedBox(height: 20),
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
    });
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.buttonGreen,
      elevation: 0,
      automaticallyImplyLeading: false, // 👈 remove default leading space

      title: Obx(() {
        final transporter = ctrl.transporter.value;
        final initial = transporter?.name.substring(0, 1).toUpperCase() ?? 'A';
        final name = transporter?.name ?? '';

        return Row(
          children: [
            // Avatar
            GestureDetector(
              onTap: () {
                final box = GetStorage();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => _TransporterProfileSheet(
                    token: box.read('token') ?? '',
                  ),
                );
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: const Color.fromRGBO(0, 201, 80, 1),
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10), // 👈 controlled spacing
            // Text
            Column(
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
            ),
          ],
        );
      }),

      actions: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 12, top: 12),
              child: Icon(
                Icons.notifications_outlined,
                color: Colors.white,
                size: 26,
              ),
            ),
            Positioned(
              right: 14,
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
      final shipments = ctrl.transporter.value?.shipments ?? [];
      final s = shipments.isNotEmpty ? shipments.first : null;

      if (s == null) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.backgroundTrans,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Text(
              'No shipments yet',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        );
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
                  'Recent Shipment',
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
                onPressed: () => Get.toNamed(AppRoutes.transporterRouteDetails),
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
              onPressed: () => Get.toNamed(AppRoutes.transporterRouteDetails),
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

class _JobsSection extends StatelessWidget {
  final TransporterController ctrl;
  const _JobsSection({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ctrl.isLoadingJobs.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final jobs = ctrl.assignedJobs;
      if (jobs.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Incoming Jobs',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...jobs.map((job) => _JobCard(job: job, ctrl: ctrl)).toList(),
        ],
      );
    });
  }
}

class _JobCard extends StatelessWidget {
  final Map<String, dynamic> job;
  final TransporterController ctrl;
  const _JobCard({required this.job, required this.ctrl});

  Color _statusColor(String status) {
    switch (status) {
      case 'TRANSPORTER_ASSIGNED': return const Color(0xFFF59E0B);
      case 'PICKED_UP': return const Color(0xFF3B82F6);
      case 'IN_TRANSIT': return const Color(0xFF8B5CF6);
      case 'DELIVERED': return const Color(0xFF16A34A);
      default: return Colors.grey;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'TRANSPORTER_ASSIGNED': return 'Awaiting Acceptance';
      case 'PICKED_UP': return 'Picked Up';
      case 'IN_TRANSIT': return 'In Transit';
      case 'DELIVERED': return 'Delivered';
      default: return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = job['status'] as String? ?? '';
    final farmer = job['farmer'] as Map<String, dynamic>?;
    final route = job['route'] as Map<String, dynamic>?;
    final origin = route?['origin'] ?? farmer?['location'] ?? 'Origin';
    final destination = job['destination'] ?? route?['destination'] ?? 'Destination';
    final cargo = job['cargo'] ?? 'Cargo';
    final weight = job['weight']?.toString() ?? '0';
    final weightUnit = job['weightUnit'] ?? 'kg';
    final price = (job['price'] ?? 0).toDouble();
    final farmerName = farmer?['name'] ?? 'Farmer';
    final statusColor = _statusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                cargo,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _statusLabel(status),
                  style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person_outline, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(farmerName, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(width: 16),
              const Icon(Icons.scale_outlined, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text('$weight $weightUnit', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.arrow_forward, size: 14, color: Color(0xFF2E7D32)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '$origin → $destination',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '₦${price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildActions(job['id'] as String, status),
        ],
      ),
    );
  }

  Widget _buildActions(String id, String status) {
    if (status == 'TRANSPORTER_ASSIGNED') {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => ctrl.declineJob(id),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Decline'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () => ctrl.acceptJob(id),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16A34A),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Accept', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      );
    }

    if (status == 'PICKED_UP') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => ctrl.updateJobStatus(id, 'IN_TRANSIT'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8B5CF6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Mark In Transit', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    if (status == 'IN_TRANSIT') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => ctrl.updateJobStatus(id, 'DELIVERED'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF16A34A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Mark Delivered', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class _TransporterProfileSheet extends StatefulWidget {
  final String token;
  const _TransporterProfileSheet({required this.token});

  @override
  State<_TransporterProfileSheet> createState() =>
      _TransporterProfileSheetState();
}

class _TransporterProfileSheetState extends State<_TransporterProfileSheet> {
  Map<String, dynamic>? profile;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final res = await AuthService().getProfile(widget.token);
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        setState(() {
          profile = body['data'];
          loading = false;
        });
      } else {
        setState(() => loading = false);
      }
    } catch (_) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          CircleAvatar(
            radius: 36,
            backgroundColor: AppColors.buttonGreen,
            child: Text(
              loading || profile == null
                  ? '?'
                  : (profile!['name'] as String? ?? '?')[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (loading)
            const Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            )
          else if (profile == null)
            const Text('Could not load profile')
          else ...[
            Text(
              profile!['name'] ?? '—',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              profile!['role']?['name'] ?? '—',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),
            _profileRow(Icons.email_outlined, 'Email', profile!['email']),
            _profileRow(Icons.phone_outlined, 'Phone', profile!['phone']),
            _profileRow(Icons.location_on_outlined, 'Location', profile!['location']),
            _profileRow(
              Icons.calendar_today_outlined,
              'Joined',
              profile!['createdAt'] != null
                  ? profile!['createdAt'].toString().substring(0, 10)
                  : null,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Get.back();
                  Get.put(AuthController()).logout();
                },
                icon: const Icon(Icons.logout, size: 18, color: Colors.red),
                label: const Text('Logout', style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _profileRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.buttonGreen),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value ?? 'Not set',
              style: TextStyle(
                fontSize: 13,
                color: value != null ? Colors.black87 : Colors.grey.shade400,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
