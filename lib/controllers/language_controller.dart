import 'package:get/get.dart';

class LanguageController extends GetxController {
  var selectedLanguage = 'en'.obs;

  void changeLanguage(String languageCode) {
    selectedLanguage.value = languageCode;
    // logic to change the app language
    // Get.updateLocale(Locale(languageCode));
  }
}
