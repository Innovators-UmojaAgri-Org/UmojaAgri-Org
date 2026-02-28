import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/transporter_controller.dart';
import '../../models/farmer/shipment_model.dart';
import '../../models/transporter_model.dart';

class TransporterSelectionScreen extends StatelessWidget {
  final ShipmentModel shipment;

  TransporterSelectionScreen({Key? key, required this.shipment})
    : super(key: key);

  final TransporterController controller = Get.put(TransporterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE5CF),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),

              // ── Header ────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
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
                          "Select Transporter",
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
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 46),
                child: Text(
                  "Choose a carrier for ${shipment.id}",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ),

              const SizedBox(height: 16),

              // ── Shipment summary 
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF4E6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
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
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
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
                              "${shipment.product} • ${shipment.bags} Bags  →  ${shipment.destination}",
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _statusBadge("Pending"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Transporter list 
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: controller.transporters.length,
                  itemBuilder: (context, index) {
                    final t = controller.transporters[index];
                    return _transporterCard(context, t);
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _transporterCard(BuildContext context, TransporterModel t) {
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
          // Name + verified badge
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.local_shipping_outlined,
                  size: 22,
                  color: Color(0xFF1F7A3D),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.verified,
                          size: 13,
                          color: Color(0xFF1F7A3D),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          t.tag,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF1F7A3D),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFD6E4C7)),
          const SizedBox(height: 14),

          // Details grid
          Row(
            children: [
              Expanded(child: _detailCell("Driver Name", t.driverName)),
              Expanded(child: _detailCell("Vehicle Type", t.vehicleType)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _detailCell("Phone Number", t.phoneNumber)),
              Expanded(child: _detailCell("License Plate", t.licensePlate)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _detailCell("Rate", t.rate)),
              Expanded(child: _detailCell("ETA", t.eta)),
            ],
          ),

          const SizedBox(height: 16),

          // Select button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1F7A3D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                controller.selectTransporter(t);
                _showConfirmationDialog(context, t);
              },
              child: const Text(
                "Select Transporter",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, TransporterModel t) {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      builder:
          (_) => Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Close
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.black54,
                      ),
                    ),
                  ),

                  // Green checkmark
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1F7A3D),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                  const SizedBox(height: 14),

                  const Text(
                    "Transporter Selected",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${t.name} has been assigned to ${shipment.id}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Transporter summary
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF4E6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.local_shipping_outlined,
                          size: 22,
                          color: Color(0xFF1F7A3D),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.verified,
                                size: 12,
                                color: Color(0xFF1F7A3D),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                t.tag,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF1F7A3D),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _detailCell("Driver Name", t.driverName)),
                      Expanded(
                        child: _detailCell("Vehicle Type", t.vehicleType),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _detailCell("Phone Number", t.phoneNumber),
                      ),
                      Expanded(
                        child: _detailCell("License Plate", t.licensePlate),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _detailCell("Rate", t.rate)),
                      Expanded(child: _detailCell("ETA", t.eta)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Assigned shipment mini-card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF4E6),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              shipment.id,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            _statusBadge("In Transit"),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "${shipment.product} • ${shipment.bags} Bags",
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _detailCell(
                                "Destination",
                                shipment.destination,
                              ),
                            ),
                            Expanded(
                              child: _detailCell(
                                "Departure",
                                shipment.departureDate,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _detailCell(
                                "Est. Arrival",
                                shipment.arrivalDate,
                              ),
                            ),
                            Expanded(
                              child: _detailCell(
                                "Distance",
                                "${shipment.distanceKm} km",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Done button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1F7A3D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        controller.clearSelection();
                        Get.back(); // close dialog
                        Get.back(); // back to shipments
                      },
                      child: const Text(
                        "Done",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _detailCell(String label, String value) {
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
}
