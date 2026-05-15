import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umoja_agri/utils/app_colors.dart';
import 'package:umoja_agri/controllers/auth_controller.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
                const SizedBox(height: 40),

                const Text(
                  "Sign in",
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

                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Forgot password?",
                    style: TextStyle(
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const Center(child: Text("Or sign in with Google")),

                const SizedBox(height: 20),

                Center(
                  child: Image.asset("assets/images/google.png", height: 50),
                ),

                const SizedBox(height: 40),

                Obx(() {
                  return authCtrl.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : _buildPrimaryButton("Sign in");
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
          await authCtrl.login();
        },
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
