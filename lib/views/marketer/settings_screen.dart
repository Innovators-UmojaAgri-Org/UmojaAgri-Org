import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umoja_agri/utils/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'Settings',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ),
              _SettingsSection(
                title: 'Account',
                items: [
                  _SettingItem(
                    icon: Icons.person,
                    label: 'Profile',
                    onTap: () => Get.snackbar('Profile', 'Profile tapped'),
                  ),
                  _SettingItem(
                    icon: Icons.lock,
                    label: 'Change Password',
                    onTap:
                        () =>
                            Get.snackbar('Password', 'Change password tapped'),
                  ),
                  _SettingItem(
                    icon: Icons.email,
                    label: 'Email & Phone',
                    onTap:
                        () => Get.snackbar('Contact', 'Email & Phone tapped'),
                  ),
                ],
              ),
              _SettingsSection(
                title: 'Preferences',
                items: [
                  _SettingItem(
                    icon: Icons.notifications,
                    label: 'Notifications',
                    onTap:
                        () => Get.snackbar(
                          'Notifications',
                          'Notifications tapped',
                        ),
                  ),
                  _SettingItem(
                    icon: Icons.language,
                    label: 'Language',
                    onTap: () => Get.snackbar('Language', 'Language tapped'),
                  ),
                ],
              ),
              _SettingsSection(
                title: 'Support',
                items: [
                  _SettingItem(
                    icon: Icons.help,
                    label: 'Help & Support',
                    onTap: () => Get.snackbar('Help', 'Help & Support tapped'),
                  ),
                  _SettingItem(
                    icon: Icons.info,
                    label: 'About',
                    onTap: () => Get.snackbar('About', 'About tapped'),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offAllNamed('/');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Sign Out',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
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
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingItem> items;

  const _SettingsSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder:
                  (_, __) => Divider(color: AppTheme.border, height: 0),
              itemBuilder: (_, i) => items[i],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppTheme.primary, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
