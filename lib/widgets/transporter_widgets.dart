// views/widgets/shipment_card.dart

import 'package:flutter/material.dart';
import 'package:umoja_agri/models/transporter/transporter_model.dart';

class ShipmentCard extends StatelessWidget {
  final Shipment shipment;

  const ShipmentCard({super.key, required this.shipment});

  Color get _statusColor {
    switch (shipment.shipmentStatus) {
      case ShipmentStatus.inTransit:
        return const Color(0xFF2E9447);
      case ShipmentStatus.pending:
        return const Color(0xFFE67E22);
      case ShipmentStatus.delivered:
        return const Color(0xFF27AE60);
      case ShipmentStatus.cancelled:
        return const Color(0xFFE74C3C);
    }
  }

  Color get _statusBgColor {
    switch (shipment.shipmentStatus) {
      case ShipmentStatus.inTransit:
        return const Color(0xFFE8F5ED);
      case ShipmentStatus.pending:
        return const Color(0xFFFEF3E7);
      case ShipmentStatus.delivered:
        return const Color(0xFFE8F5ED);
      case ShipmentStatus.cancelled:
        return const Color(0xFFFEEBEB);
    }
  }

  IconData get _statusIcon {
    switch (shipment.shipmentStatus) {
      case ShipmentStatus.inTransit:
        return Icons.local_shipping_outlined;
      case ShipmentStatus.pending:
        return Icons.schedule_outlined;
      case ShipmentStatus.delivered:
        return Icons.check_circle_outline;
      case ShipmentStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5ED),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    color: Color(0xFF2E9447),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shipment.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Color(0xFF1A2E1A),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'ID: ${shipment.id}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF888888),
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(
                  label: shipment.status,
                  color: _statusColor,
                  bgColor: _statusBgColor,
                  icon: _statusIcon,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            const SizedBox(height: 16),

            // Route row
            Row(
              children: [
                Expanded(
                  child: _RoutePoint(
                    label: 'From',
                    location: shipment.origin,
                    isOrigin: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 1.5,
                        color: const Color(0xFFCCCCCC),
                      ),
                      const Icon(
                        Icons.arrow_forward,
                        size: 14,
                        color: Color(0xFF2E9447),
                      ),
                      Container(
                        width: 24,
                        height: 1.5,
                        color: const Color(0xFFCCCCCC),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _RoutePoint(
                    label: 'To',
                    location: shipment.destination,
                    isOrigin: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Footer details
            Row(
              children: [
                _DetailChip(
                  icon: Icons.scale_outlined,
                  label:
                      '${shipment.weight.toStringAsFixed(0)}${shipment.weightUnit}',
                ),
                const SizedBox(width: 8),
                _DetailChip(
                  icon: Icons.route_outlined,
                  label: '${shipment.distanceKm.toStringAsFixed(0)} km',
                ),
                const SizedBox(width: 8),
                _DetailChip(
                  icon: Icons.access_time_outlined,
                  label: shipment.departureTime,
                ),
                const Spacer(),
                Text(
                  '${shipment.currency}${_formatAmount(shipment.estimatedEarnings)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: Color(0xFF1D6B2E),
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
            if (shipment.shipmentStatus == ShipmentStatus.inTransit) ...[
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.map_outlined, size: 16),
                  label: const Text('Track Shipment'),
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2E9447),
                    side: const BorderSide(color: Color(0xFF2E9447)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}k';
    }
    return amount.toStringAsFixed(0);
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color bgColor;
  final IconData icon;

  const _StatusBadge({
    required this.label,
    required this.color,
    required this.bgColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoutePoint extends StatelessWidget {
  final String label;
  final String location;
  final bool isOrigin;

  const _RoutePoint({
    required this.label,
    required this.location,
    required this.isOrigin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isOrigin ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF999999)),
        ),
        const SizedBox(height: 2),
        Text(
          location,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF1A2E1A),
          ),
        ),
      ],
    );
  }
}

class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DetailChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: const Color(0xFF888888)),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF666666),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
// views/widgets/stats_card.dart

class StatsRow extends StatelessWidget {
  final TransporterStats stats;

  const StatsRow({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: Icons.local_shipping_outlined,
              value: stats.totalDeliveries.toString(),
              label: 'Deliveries',
              iconColor: const Color(0xFF2E9447),
            ),
          ),
          _Divider(),
          Expanded(
            child: _StatItem(
              icon: Icons.account_balance_wallet_outlined,
              value: '₦${_formatEarnings(stats.totalEarnings)}',
              label: 'Earnings',
              iconColor: const Color(0xFF1D6B2E),
            ),
          ),
          _Divider(),
          Expanded(
            child: _StatItem(
              icon: Icons.star_outline_rounded,
              value: stats.rating.toStringAsFixed(1),
              label: 'Rating',
              iconColor: const Color(0xFFE67E22),
            ),
          ),
          _Divider(),
          Expanded(
            child: _StatItem(
              icon: Icons.inventory_2_outlined,
              value: stats.activeShipments.toString(),
              label: 'Active',
              iconColor: const Color(0xFF3498DB),
            ),
          ),
        ],
      ),
    );
  }

  String _formatEarnings(double amount) {
    if (amount >= 1000000) return '${(amount / 1000000).toStringAsFixed(1)}M';
    if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(0)}k';
    return amount.toStringAsFixed(0);
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color iconColor;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15,
            color: Color(0xFF1A2E1A),
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF888888)),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: const Color(0xFFF0F0F0),
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}
// views/widgets/tab_selector.dart

class TabSelector extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const TabSelector({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFEAEFE6),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children:
            tabs.asMap().entries.map((entry) {
              final isSelected = entry.key == selectedIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTabSelected(entry.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? const Color(0xFF2E9447)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color:
                            isSelected ? Colors.white : const Color(0xFF666666),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
