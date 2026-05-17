import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umoja_agri/controllers/auth_controller.dart';
import 'package:umoja_agri/utils/app_colors.dart';
import 'package:umoja_agri/utils/constants.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset("assets/images/rolebg.png", fit: BoxFit.cover),
          ),
          Container(color: Colors.black.withOpacity(0.4)),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const Spacer(),
                  const SizedBox(height: 60),

                  /// Logo
                  Image.asset(
                    'assets/images/logo2.png',
                    width: 275,
                    height: 91,
                    fit: BoxFit.contain,
                  ),

                  const Spacer(),

                  /// Farmer Button
                  _buildPrimaryButton(
                    text: "Sign in as a Farmer",
                    onTap: () {
                      final auth = Get.put(AuthController());
                      auth.selectedRole.value = RoleIds.farmer;
                      Get.toNamed('/sign-in');
                    },
                  ),

                  const SizedBox(height: 16),

                  _buildOutlineButton(
                    text: "Sign in as a Transporter",
                    onTap: () {
                      final auth = Get.put(AuthController());
                      auth.selectedRole.value = RoleIds.transporter;
                      Get.toNamed('/sign-in');
                    },
                  ),

                  const SizedBox(height: 16),

                  _buildPrimaryButton(
                    text: "Sign in as a Market Seller",
                    backgroundColor: AppColors.primaryBlue,
                    onTap: () {
                      final auth = Get.put(AuthController());
                      auth.selectedRole.value = RoleIds.marketer;
                      Get.toNamed('/sign-in');
                    },
                  ),

                  const SizedBox(height: 20),

                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => Get.toNamed('/sign-up'),
                      child: const Text(
                        "Don't have an account? Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String text,
    required VoidCallback onTap,
    Color backgroundColor = AppColors.primaryOrange,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildOutlineButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(color: AppColors.primaryOrange),
        ),
      ),
    );
  }
}
