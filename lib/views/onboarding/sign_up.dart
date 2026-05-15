import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umoja_agri/controllers/auth_controller.dart';
import 'package:umoja_agri/utils/app_colors.dart';
import 'package:umoja_agri/utils/constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool obscurePassword = true;
  final AuthController authCtrl = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE5CF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),

                /// LOGO
                Center(
                  child: Image(
                    image: AssetImage("assets/images/UmojaAgri.png"),
                    height: 90,
                  ),
                ),

                // Center(
                //   child: Text(
                //     "UmojaAgri",
                //     style: TextStyle(
                //       fontSize: 32,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.green.shade700,
                //     ),
                //   ),
                // ),
                const SizedBox(height: 40),

                const Text(
                  "Sign up",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 30),

                _buildLabel("Email"),
                _buildTextField(
                  "example@gmail.com",
                  controller: authCtrl.emailCtrl,
                ),

                const SizedBox(height: 20),

                _buildLabel("Password"),
                _buildTextField(
                  "************",
                  isPassword: true,
                  controller: authCtrl.passwordCtrl,
                ),

                const SizedBox(height: 20),

                _buildLabel("Full name"),
                _buildTextField("Shola Adebola", controller: authCtrl.nameCtrl),

                const SizedBox(height: 16),
                // role selection
                Obx(() {
                  return DropdownButtonFormField<String>(
                    value: authCtrl.selectedRole.value,
                    items: const [
                      DropdownMenuItem(
                        value: RoleIds.farmer,
                        child: Text('Farmer'),
                      ),
                      DropdownMenuItem(
                        value: RoleIds.transporter,
                        child: Text('Transporter'),
                      ),
                      DropdownMenuItem(
                        value: RoleIds.marketer,
                        child: Text('Market Seller'),
                      ),
                    ],
                    onChanged: (v) {
                      if (v != null) authCtrl.selectedRole.value = v;
                    },
                    decoration: InputDecoration(
                      labelText: 'Role',
                      filled: true,
                      fillColor: const Color(0xFFE7ECD9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),

                Center(
                  child: Text.rich(
                    TextSpan(
                      text: "By continuing you agree to our ",
                      style: const TextStyle(fontSize: 12),
                      children: const [
                        TextSpan(
                          text: "Terms of Service",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(text: " and "),
                        TextSpan(
                          text: "Privacy Policy.",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 40),
                Obx(() {
                  return authCtrl.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : _buildPrimaryButton("Sign up");
                }),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildTextField(
    String hint, {
    bool isPassword = false,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? obscurePassword : false,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFE7ECD9),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                )
                : null,
      ),
    );
  }

  Widget _buildPrimaryButton(String text) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () async {
          await authCtrl.register();
        },
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
