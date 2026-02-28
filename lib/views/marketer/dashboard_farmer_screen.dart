// lib/views/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umoja_agri/controllers/marketer/market_controller.dart';
import 'package:umoja_agri/models/marketer/marketer_model.dart';
import 'package:umoja_agri/utils/app_colors.dart';
import 'package:umoja_agri/views/marketer/my_order_screen.dart';
import 'package:umoja_agri/views/marketer/finance_screen.dart';
import 'package:umoja_agri/views/marketer/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final RxInt selectedTabIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(MarketerController());

    return Obx(
      () => Scaffold(
        backgroundColor: Color.fromRGBO(245, 245, 243, 1),
        body: IndexedStack(
          index: selectedTabIndex.value,
          children: [
            _HomeContent(ctrl: ctrl),
            const MyOrderScreen(),
            const FinanceScreen(),
            const SettingsScreen(),
          ],
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: AppColors.marketerNavBackground,
        elevation: 0,
        currentIndex: selectedTabIndex.value,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: AppTheme.textSecondary,
        onTap: (index) => selectedTabIndex.value = index,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'My Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Finance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final MarketerController ctrl;
  const _HomeContent({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () =>
            ctrl.isLoading.value
                ? const Center(
                  child: CircularProgressIndicator(color: AppTheme.primary),
                )
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Header(ctrl: ctrl),
                      const SizedBox(height: 16),
                      const _AiInsight(),
                      const SizedBox(height: 20),
                      _IncomingDeliveries(ctrl: ctrl),
                      const SizedBox(height: 20),
                      _FarmProduceSection(ctrl: ctrl),
                    ],
                  ),
                ),
      ),
    );
  }
}

// ── Sub-widgets
class _Header extends StatelessWidget {
  final MarketerController ctrl;
  const _Header({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(width: 6),
              Image.asset(
                'assets/images/UmojaAgri.png',
                width: 100,
                height: 40,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 2),
              Text(
                'Welcome, ${ctrl.sellerName.value}',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _LocationChip(market: ctrl.market.value),
              const SizedBox(width: 4),
              _IconBtn(icon: Icons.shopping_cart_rounded),
              const SizedBox(width: 2),
              _IconBtn(icon: Icons.notifications_rounded),
            ],
          ),
        ],
      ),
    );
  }
}

class _LocationChip extends StatelessWidget {
  final String market;
  const _LocationChip({required this.market});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        // color: AppTheme.border,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, size: 12, color: Colors.red),
          const SizedBox(width: 1),
          Text(
            market,
            style: const TextStyle(fontSize: 11, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  const _IconBtn({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      // decoration: BoxDecoration(
      //   color: AppTheme.surface,
      //   borderRadius: BorderRadius.circular(8),
      //   // border: Border.all(color: AppTheme.border),
      // ),
      child: Icon(icon, size: 16, color: AppColors.iconGreen),
    );
  }
}

class _AiInsight extends StatelessWidget {
  const _AiInsight();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.accentLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.accent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: AppTheme.accent,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'AI Supply Insight',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.flash_on, size: 12, color: AppTheme.accent),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  'Supply drop expected next week due to Kaduna rains. Stock up now to maintain inventory levels.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IncomingDeliveries extends StatelessWidget {
  final MarketerController ctrl;
  const _IncomingDeliveries({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Incoming Deliveries',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          const SizedBox(height: 10),
          ...ctrl.deliveries.map((d) => _DeliveryCard(delivery: d)),
        ],
      ),
    );
  }
}

class _DeliveryCard extends StatelessWidget {
  final Delivery delivery;
  const _DeliveryCard({required this.delivery});

  @override
  Widget build(BuildContext context) {
    final d = delivery;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.local_shipping,
                  color: AppTheme.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d.product,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'Status: On the way',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.green.shade600,
                      ),
                    ),
                    Text(
                      'From ${d.from} • Shipment #${d.shipmentId}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Text(
                      'ETA',
                      style: TextStyle(
                        fontSize: 9,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Text(
                      d.eta,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Delivery Progress',
                style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
              ),
              Text(
                '${d.progressPercent}%',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: d.progressPercent / 100,
              backgroundColor: AppTheme.border,
              valueColor: const AlwaysStoppedAnimation(AppTheme.primary),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class _FarmProduceSection extends StatelessWidget {
  final MarketerController ctrl;
  const _FarmProduceSection({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Farm Produce',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'See All',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.80,
            ),
            itemCount: ctrl.farmProduce.length,
            itemBuilder: (_, i) => _ProduceCard(produce: ctrl.farmProduce[i]),
          ),
        ],
      ),
    );
  }
}

class _ProduceCard extends StatelessWidget {
  final FarmProduce produce;
  const _ProduceCard({required this.produce});

  @override
  Widget build(BuildContext context) {
    final p = produce;
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Text(p.imageEmoji, style: const TextStyle(fontSize: 52)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'Qty: ${p.quantity.toInt()}${p.unit} • ${formatNaira(p.pricePerKg)}/kg',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.circle,
                      size: 8,
                      color: AppTheme.confirmed,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Freshness: ${p.freshness}%',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  p.farm,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        () => Get.snackbar(
                          'Order Placed',
                          'Added ${p.name} to your order',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppTheme.primary,
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(12),
                          borderRadius: 10,
                        ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orderButton,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      minimumSize: const Size(0, 28),
                    ),
                    child: const Text(
                      'Order here',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
