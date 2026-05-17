import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:umoja_agri/services/produce_service.dart';
import 'package:umoja_agri/utils/app_snackbar.dart';

class ProduceModel {
  final String id;
  final String name;
  final double quantity;
  final String unit;
  final double? pricePerUnit;
  final int? freshnessScore;
  final String? imageUrl;
  final String? harvestDate;
  final String? expiryDate;

  ProduceModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    this.pricePerUnit,
    this.freshnessScore,
    this.imageUrl,
    this.harvestDate,
    this.expiryDate,
  });
}

class ProduceController extends GetxController {
  final produces = <ProduceModel>[].obs;
  final isLoading = false.obs;
  final _box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadMyProduces();
  }

  Future<void> loadMyProduces() async {
    isLoading.value = true;
    try {
      final token = _box.read('token') ?? '';
      // print('=== FARMER LOADING PRODUCES ===');
      final res = await ProduceService().getMyProduces(token);
      // print('My Produces API Response Status: ${res.statusCode}');
      // print('My Produces API Response Body: ${res.body}');
      // print('=== END FARMER PRODUCES ===\n');

      if (res.statusCode == 200) {
        final response = jsonDecode(res.body);
        final data = response['data'] as List? ?? [];
        produces.assignAll(
          data.map(
            (p) => ProduceModel(
              id: p['id'] ?? '',
              name: p['name'] ?? 'Unknown',
              quantity: (p['quantity'] ?? 0).toDouble(),
              unit: p['unit'] ?? 'kg',
              pricePerUnit:
                  p['pricePerUnit'] != null
                      ? (p['pricePerUnit']).toDouble()
                      : null,
              freshnessScore: p['freshnessScore'],
              imageUrl: p['imageUrl'],
              harvestDate: p['harvestDate'],
              expiryDate: p['expiryDate'],
            ),
          ),
        );
        print('✓ Loaded ${produces.length} produces successfully');
      } else {
        print('✗ Produces API returned status: ${res.statusCode}');
      }
    } catch (e, stackTrace) {
      print('✗ Error loading produces: $e');
      print('Stack trace: $stackTrace');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createProduce({
    required String name,
    required double quantity,
    required String unit,
    String? harvestDate,
    String? expiryDate,
  }) async {
    try {
      final token = _box.read('token') ?? '';
      // print('=== CREATING PRODUCE ===');
      // print(
      //   'Name: $name, Quantity: $quantity, Unit: $unit, Harvest: $harvestDate, Expiry: $expiryDate',
      // );

      final res = await ProduceService().createProduce(
        token: token,
        name: name,
        quantity: quantity,
        unit: unit,
        harvestDate: harvestDate,
        expiryDate: expiryDate,
      );
      // print('Create Produce API Response Status: ${res.statusCode}');
      // print('Create Produce API Response Body: ${res.body}');
      // print('=== END CREATE PRODUCE ===\n');

      if (res.statusCode == 200 || res.statusCode == 201) {
        await loadMyProduces();
        AppSnackbar.success('Produce added successfully');
        //print('Produce created and list refreshed');
      } else {
        // print('Create produce API returned status: ${res.statusCode}');
        AppSnackbar.error('Failed to add produce');
      }
    } catch (e, stackTrace) {
      // print('✗ Error creating produce: $e');
      // print('Stack trace: $stackTrace');
      AppSnackbar.error('Failed to add produce: $e');
    }
  }

  Future<void> editProduce({
    required String produceId,
    String? name,
    String? description,
    double? quantity,
    String? unit,
    double? pricePerUnit,
    double? freshnessScore,
    String? imageUrl,
    String? location,
    String? harvestDate,
    String? expiryDate,
  }) async {
    try {
      final token = _box.read('token') ?? '';
      final res = await ProduceService().editProduce(
        token: token,
        produceId: produceId,
        name: name,
        description: description,
        quantity: quantity,
        unit: unit,
        pricePerUnit: pricePerUnit,
        freshnessScore: freshnessScore,
        imageUrl: imageUrl,
        location: location,
        harvestDate: harvestDate,
        expiryDate: expiryDate,
      );
      if (res.statusCode == 200) {
        await loadMyProduces();
        AppSnackbar.success('Produce updated successfully');
      } else {
        AppSnackbar.error('Failed to update produce');
      }
    } catch (e) {
      AppSnackbar.error('Failed to update produce: $e');
    }
  }

  Future<void> deleteProduce(String produceId) async {
    try {
      final token = _box.read('token') ?? '';
      final res = await ProduceService().deleteProduce(token, produceId);
      if (res.statusCode == 200) {
        await loadMyProduces();
        AppSnackbar.success('Produce deleted successfully');
      } else {
        AppSnackbar.error('Failed to delete produce');
      }
    } catch (e) {
      AppSnackbar.error('Failed to delete produce: $e');
    }
  }
}
