import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../models/farmer/shipment_model.dart';
import '../../models/transporter_model.dart';
import '../../services/shipment_service.dart';
import '../../controllers/farmer/shipment_controller.dart';
import 'dart:convert';
import 'package:umoja_agri/utils/app_snackbar.dart';

class TransporterSelectionScreen extends StatefulWidget {
  final ShipmentModel shipment;

  const TransporterSelectionScreen({Key? key, required this.shipment})
    : super(key: key);

  @override
  State<TransporterSelectionScreen> createState() =>
      _TransporterSelectionScreenState();
}

class _TransporterSelectionScreenState
    extends State<TransporterSelectionScreen> {
  final RxBool isLoading = true.obs;
  final RxList<TransporterModel> transporters = <TransporterModel>[].obs;
  final _box = GetStorage();

  @override
  void initState() {
    super.initState();
    loadTransporters();
  }

  Future<void> loadTransporters() async {
    try {
      final token = _box.read('token') ?? '';
      final res = await ShipmentService().getAvailableTransporters(token);
      print('Available transporters response: ${res.body}');
      if (res.statusCode == 200) {
        final response = jsonDecode(res.body);
        final data = response['data'] as List;
        transporters.value =
            data
                .map(
                  (t) => TransporterModel(
                    id: t['id'],
                    name: t['name'] ?? 'Unknown',
                    tag: 'Verified Carrier',
                    driverName: 'N/A', 
                    vehicleType: t['vehicle_type'] ?? 'Truck',
                    phoneNumber: 'N/A',
                    licensePlate: 'N/A',
                    rate: '₦${t['price_per_km'] ?? 0}',
                    eta: '${t['estimated_delivery_hours'] ?? 0} hours',
                  ),
                )
                .toList();
      }
    } catch (e) {
      print('Error loading transporters: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectTransporter(TransporterModel t) async {
    try {
      final token = _box.read('token') ?? '';
      final res = await ShipmentService().selectTransporter(
        token,
        widget.shipment.id,
        t.id,
      );
      print('Select transporter response: ${res.body}');
      if (res.statusCode == 200) {
        // Refresh shipments
        final shipmentController = Get.find<ShipmentController>();
        shipmentController.loadShipments();
        // Success, show dialog and navigate back
        _showConfirmationDialog(context, t);
      } else {
        AppSnackbar.error('Failed to select transporter');
      }
    } catch (e) {
      print('Error selecting transporter: $e');
      AppSnackbar.error('Failed to select transporter');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE5CF),
      body: SafeArea(
        child: Obx(() {
          if (isLoading.value) {
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
                  "Choose a carrier for ${widget.shipment.id}",
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
                              widget.shipment.id,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "${widget.shipment.product} • ${widget.shipment.bags} Bags  →  ${widget.shipment.destination}",
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
                child:
                    transporters.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.local_shipping_outlined,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'No transporters available',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Please make sure transporters are registered in the system.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: transporters.length,
                          itemBuilder: (context, index) {
                            final t = transporters[index];
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
              onPressed: () => selectTransporter(t),
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
                    "${t.name} has been assigned to ${widget.shipment.id}",
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
                              widget.shipment.id,
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
                          "${widget.shipment.product} • ${widget.shipment.bags} Bags",
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
                                widget.shipment.destination,
                              ),
                            ),
                            Expanded(
                              child: _detailCell(
                                "Departure",
                                widget.shipment.departureDate,
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
                                widget.shipment.arrivalDate,
                              ),
                            ),
                            Expanded(
                              child: _detailCell(
                                "Distance",
                                "${widget.shipment.distanceKm} km",
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
