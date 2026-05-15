// adding app colors
import 'package:flutter/material.dart';

class AppColors {
  //WHITE COLOR
  static const Color white = Color(0xFFFFFFFF);
  static const Color primaryGreen = Color(0xFF1F7A3D);
  static const Color lightGreen = Color(0xFF4CAF50);
  static const Color darkGreen = Color(0xFF2E7D32);
  static const Color accentGreen = Color(0xFF81C784);
  static const Color backgroundGreen = Color(0xFFE8F5E9);
  //background -transporter
  static const Color backgroundTrans = Color(0xFFDCE8CC);
  //icon color
  static const Color iconGreen = Color(0xFF449720);

  //button color
  static const Color buttonGreen = Color(0xFF1F7A3D);
  // orange
  static const Color primaryOrange = Color(0xFFE65100);
  //blue
  static const Color primaryBlue = Color(0xFF00B8DB);

  //market-colors
  //bottom-nav colors
  static const Color marketerNavBackground = Color(0xFFEBF4DE);
  static const Color orderButton = Color(0xFF102C12);
  static const Color insight = Color(0xFFF9A825);
}

class AppTheme {
  static const Color primary = Color(0xFF1A6B3A);
  static const Color primaryLight = Color(0xFF2E8B57);
  static const Color accent = Color(0xFFF5A623);
  static const Color accentLight = Color(0xFFFFF3DC);
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);
  static const Color pending = Color(0xFFF5A623);
  static const Color confirmed = Color(0xFF10B981);
  static const Color inTransit = Color(0xFF3B82F6);
  static const Color delivered = Color(0xFF6B7280);

  static ThemeData get theme => ThemeData(
    fontFamily: 'SF Pro Display',
    colorScheme: ColorScheme.fromSeed(seedColor: primary),
    scaffoldBackgroundColor: background,
    appBarTheme: const AppBarTheme(
      backgroundColor: surface,
      elevation: 0,
      iconTheme: IconThemeData(color: textPrimary),
    ),
    useMaterial3: true,
  );
}

String formatNaira(double amount) {
  if (amount >= 1000000) {
    return '₦${(amount / 1000000).toStringAsFixed(1)}M';
  } else if (amount >= 1000) {
    return '₦${(amount / 1000).toStringAsFixed(0)},${(amount % 1000).toStringAsFixed(0).padLeft(3, '0')}';
  }
  return '₦${amount.toStringAsFixed(0)}';
}

String formatDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}
