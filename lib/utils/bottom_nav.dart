import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umoja_agri/controllers/nav_controller.dart';
import 'package:umoja_agri/views/farmer/crop_view.dart';
import 'package:umoja_agri/views/farmer/dashboard_screen.dart';
import 'package:umoja_agri/views/farmer/finance_view.dart';
import 'package:umoja_agri/views/farmer/ship_view.dart';

class MainNavigation extends StatelessWidget {
  MainNavigation({Key? key}) : super(key: key);

  final NavigationController navController = Get.put(NavigationController());

  final List<Widget> pages = [
    DashboardScreen(),
    const CropScreen(),
    ShipmentScreen(),
    const financeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: pages[navController.selectedIndex.value],
        bottomNavigationBar: Container(
          height: 75,
          decoration: const BoxDecoration(
            color: Color(0xFFDDE5CF),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home, "Home", 0),
              _navItem(Icons.eco, "Crop", 1),
              _navItem(Icons.local_shipping, "Shipment", 2),
              _navItem(Icons.account_balance_wallet, "Finance", 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isSelected = navController.selectedIndex.value == index;

    return GestureDetector(
      onTap: () => navController.changeIndex(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.green : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isSelected ? Colors.white : Colors.green),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.green : Colors.black54,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
