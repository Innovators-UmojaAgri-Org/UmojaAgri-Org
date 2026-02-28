import 'package:get/get.dart';
import 'package:umoja_agri/views/farmer/dashboard_screen.dart';
import 'package:umoja_agri/views/marketer/dashboard_farmer_screen.dart';
import 'package:umoja_agri/views/onboarding/role_selection.dart';
import 'package:umoja_agri/views/onboarding/sign_in.dart';
import 'package:umoja_agri/views/onboarding/sign_up.dart';
import 'package:umoja_agri/views/onboarding/splash_screen.dart';
import 'package:umoja_agri/views/onboarding/language_selection_screen.dart';
import 'package:umoja_agri/views/onboarding/onboarding_screen.dart';
import 'package:umoja_agri/views/transporter/transporter_screen.dart';
import 'package:umoja_agri/views/transporter/route_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String languageSelection = '/language-selection';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String roleSelection = '/role-selection';
  static const String sign_up = '/sign-up';
  static const String sign_in = '/sign-in';
  static const String dashboard = '/dashboard';
  static const String transporter = '/transporter';
  static const String transporterRoutes = '/transporter/routes';
  static const String transporterRouteDetails = '/transporter/route-details';
  //home-marketer
  static const String home_marketer = '/home-marketer';

  static final routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(
      name: languageSelection,
      page: () => LanguageSelectionScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: onboarding,
      page: () => OnboardingScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: home,
      page: () => HomeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: roleSelection,
      page: () => const RoleSelectionScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: sign_up,
      page: () => const SignUpScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: sign_in,
      page: () => const SignInScreen(),
      transition: Transition.fadeIn,
    ),
    //dashbord
    GetPage(
      name: dashboard,
      page: () => DashboardScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: home_marketer,
      page: () => HomeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: transporter,
      page: () => TransporterScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: transporterRoutes,
      page: () => RouteScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}
