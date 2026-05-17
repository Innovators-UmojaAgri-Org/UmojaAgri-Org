import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umoja_agri/controllers/farmer/produce_controller.dart';
import 'package:umoja_agri/utils/app_snackbar.dart';

class CropScreen extends StatelessWidget {
  CropScreen({super.key});

  final ProduceController controller = Get.put(ProduceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4E8),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              /// HEADER
              _buildHeader(context),

              /// SCROLLABLE CONTENT
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      /// ACTIVE CROPS LABEL
                      const Text(
                        "Active Crops",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// PRODUCES LIST
                      if (controller.produces.isEmpty)
                        _buildEmptyState(context)
                      else
                        ...controller.produces
                            .map((produce) => _produceCard(produce))
                            .toList(),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: const Color(0xFFF0F4E8),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Row: Back + Title + Bell
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(
                      Icons.chevron_left,
                      size: 24,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "Crop Management",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  const Icon(
                    Icons.notifications_none_rounded,
                    size: 26,
                    color: Colors.black87,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 9,
                      height: 9,
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
          const SizedBox(height: 2),
          const Padding(
            padding: EdgeInsets.only(left: 28),
            child: Text(
              "Monitor and manage your crops",
              style: TextStyle(fontSize: 12, color: Colors.black45),
            ),
          ),
          const SizedBox(height: 14),

          /// Add New Crop Button
          GestureDetector(
            onTap: () => _showAddProduceDialog(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF1B5E20),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle_outline, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Add New Crop",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(Icons.agriculture, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              "No crops added yet",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _showAddProduceDialog(context),
              icon: const Icon(Icons.add),
              label: const Text("Add Crop"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B5E20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _produceCard(ProduceModel produce) {
    final stage = _getGrowthStage(produce);
    final stageColor = _getStageColor(stage);
    final healthScore = produce.freshnessScore ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Name + Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text("🌿", style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        produce.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        "${produce.quantity} ${produce.unit}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              /// Growth Stage Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: stageColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  stage,
                  style: TextStyle(
                    color: stageColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// Planted & Expected Harvest
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Planted",
                      style: TextStyle(fontSize: 10, color: Colors.black45),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      produce.harvestDate?.substring(0, 10) ?? "Not set",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Expected Harvest",
                      style: TextStyle(fontSize: 10, color: Colors.black45),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      produce.expiryDate?.substring(0, 10) ?? "Not set",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Crop Health Label + Percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Crop Health",
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              Text(
                "$healthScore%",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _getHealthColor(healthScore),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// Health Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: healthScore / 100,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getHealthColor(healthScore),
              ),
            ),
          ),

          /// Price row (optional)
          if (produce.pricePerUnit != null) ...[
            const SizedBox(height: 10),
            Text(
              "Price: ₦${produce.pricePerUnit!.toStringAsFixed(2)}/${produce.unit}",
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF1B5E20),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getGrowthStage(ProduceModel produce) {
    if (produce.freshnessScore == null) return "Unknown";
    final score = produce.freshnessScore!;
    if (score >= 85) return "Germination";
    if (score >= 70) return "Vegetative";
    if (score >= 50) return "Maturity";
    return "Harvest Ready";
  }

  Color _getStageColor(String stage) {
    switch (stage) {
      case "Germination":
        return const Color(0xFF1565C0);
      case "Vegetative":
        return const Color(0xFF2E7D32);
      case "Maturity":
        return const Color(0xFFE65100);
      default:
        return const Color(0xFF6D4C41);
    }
  }

  Color _getHealthColor(int score) {
    if (score >= 80) return const Color(0xFF2E7D32);
    if (score >= 60) return const Color(0xFFF57C00);
    return const Color(0xFFC62828);
  }

  void _showAddProduceDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final quantityCtrl = TextEditingController();
    String selectedUnit = 'kg';
    DateTime? harvestDate;
    DateTime? expiryDate;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Add New Crop",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      hintText: "Crop name (e.g., Tomato, Maize)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF1B5E20),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: quantityCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Quantity",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF1B5E20),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      DropdownButton<String>(
                        value: selectedUnit,
                        items:
                            ['kg', 'bags', 'tons', 'units', 'Hectares']
                                .map(
                                  (u) => DropdownMenuItem(
                                    value: u,
                                    child: Text(u),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            (v) => setState(() => selectedUnit = v ?? 'kg'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (date != null)
                              setState(() => harvestDate = date);
                          },
                          icon: const Icon(Icons.calendar_today, size: 16),
                          label: Text(
                            harvestDate == null
                                ? "Planted"
                                : harvestDate.toString().substring(0, 10),
                            style: const TextStyle(fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black87,
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now().add(
                                const Duration(days: 90),
                              ),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2030),
                            );
                            if (date != null) setState(() => expiryDate = date);
                          },
                          icon: const Icon(Icons.calendar_today, size: 16),
                          label: Text(
                            expiryDate == null
                                ? "Harvest"
                                : expiryDate.toString().substring(0, 10),
                            style: const TextStyle(fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black87,
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (nameCtrl.text.isNotEmpty &&
                                quantityCtrl.text.isNotEmpty) {
                              controller.createProduce(
                                name: nameCtrl.text,
                                quantity:
                                    double.tryParse(quantityCtrl.text) ?? 0,
                                unit: selectedUnit,
                                harvestDate: harvestDate
                                    ?.toIso8601String()
                                    .substring(0, 10),
                                expiryDate: expiryDate
                                    ?.toIso8601String()
                                    .substring(0, 10),
                              );
                              Get.back();
                            } else {
                              AppSnackbar.error('Please fill in all required fields');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B5E20),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Add Crop",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
