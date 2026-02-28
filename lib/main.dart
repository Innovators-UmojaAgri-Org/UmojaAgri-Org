import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umoja_agri/utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'UmojaAgri',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1F7A3D)),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F7A3D),
          elevation: 0,
          centerTitle: true,
        ),
      ),
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
    );
  }
}
