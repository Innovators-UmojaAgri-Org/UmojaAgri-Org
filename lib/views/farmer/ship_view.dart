import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umoja_agri/utils/app_colors.dart';
import 'package:umoja_agri/views/farmer/transporter_screen.dart';
import '../../controllers/farmer/shipment_controller.dart';
import '../../models/farmer/shipment_model.dart';

class ShipmentScreen extends StatelessWidget {
  ShipmentScreen({Key? key}) : super(key: key);

  final ShipmentController controller = Get.put(ShipmentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE5CF),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),

                /// HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: const Icon(Icons.chevron_left, size: 22),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          "Shipments",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        const Icon(Icons.notifications_none, size: 26),
                        Positioned(
                          right: 0,
                          top: 0,
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
                const SizedBox(height: 4),
                const Padding(
                  padding: EdgeInsets.only(left: 26),
                  child: Text(
                    "Monitor all product deliveries in real-time",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),

                const SizedBox(height: 20),

                /// ACTIVE SHIPMENTS CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1B5E20), Color(0xFF43A047)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Active Shipments",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${controller.shipments.length} Routes",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          _countItem(controller.inTransitCount, "In Transit"),
                          _divider(),
                          _countItem(controller.deliveredCount, "Delivered"),
                          _divider(),
                          _countItem(controller.pendingCount, "Pending"),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// FILTERS
                Obx(
                  () => Row(
                    children: [
                      _filterChip("All Shipments", false),
                      const SizedBox(width: 10),
                      _filterChip(
                        "Needs Transport (${controller.needsTransportCount})",
                        true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// SHIPMENT LIST
                ...controller.filteredShipments
                    .map((shipment) => _shipmentCard(shipment))
                    .toList(),

                const SizedBox(height: 40),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.white30,
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _filterChip(String label, bool needsTransport) {
    final selected =
        controller.selectedFilter.value == (needsTransport ? "Needs" : "All");

    return GestureDetector(
      onTap:
          () =>
              controller.selectedFilter.value =
                  needsTransport ? "Needs" : "All",
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1F7A3D) : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _shipmentCard(ShipmentModel shipment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4E6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top row: truck icon + ID + status badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.local_shipping_outlined,
                      size: 18,
                      color: Color(0xFF1F7A3D),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shipment.id,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "${shipment.product} • ${shipment.bags} Bags",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              _statusBadge(shipment.status),
            ],
          ),

          const SizedBox(height: 14),

          /// Recommended vehicle info box
          if (shipment.recommendedVehicle != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                // color: const Color(0xFF4DB6AC).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF4DB6AC), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.directions_car_outlined,
                        size: 14,
                        color: Color(0xFF00796B),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Recommended: ${shipment.recommendedVehicle}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  if (shipment.vehicleReasons != null) ...[
                    const SizedBox(height: 6),
                    ...shipment.vehicleReasons!.map(
                      (reason) => Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //using a tick icon instead l
                            const Icon(
                              Icons.check,
                              size: 11,
                              color: Colors.white70,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                reason,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

          const SizedBox(height: 14),

          /// Destination + Driver row
          Row(
            children: [
              Expanded(child: _infoColumn("Destination", shipment.destination)),
              Expanded(
                child: _infoColumn(
                  "Driver",
                  shipment.driverName ?? "Not Assigned",
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// Departure + Est. Arrival row
          Row(
            children: [
              Expanded(child: _infoColumn("Departure", shipment.departureDate)),
              Expanded(
                child: _infoColumn("Est. Arrival", shipment.arrivalDate),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// Distance
          _infoColumn("Distance", "${shipment.distanceKm} km"),

          /// Select Transporter button
          if (shipment.needsTransport) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F7A3D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(
                  Icons.local_shipping_outlined,
                  size: 16,
                  color: Colors.white,
                ),
                label: const Text(
                  "Select Transporter",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed:
                    () => Get.to(
                      () => TransporterSelectionScreen(shipment: shipment),
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.black45),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _statusBadge(String status) {
    Color color;
    if (status == "Pending") {
      color = Colors.orange;
    } else if (status == "In Transit") {
      color = Colors.blue;
    } else {
      color = const Color(0xFF1F7A3D);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _countItem(int count, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}
