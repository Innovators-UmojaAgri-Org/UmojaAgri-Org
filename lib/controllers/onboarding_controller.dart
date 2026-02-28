import 'package:get/get.dart';
import 'package:umoja_agri/models/onboarding_model.dart';

class OnboardingController extends GetxController {
  var currentIndex = 0.obs;
  var selectedLanguage = 'en'.obs;

  final List<OnboardingModel> onboardingPages = [
    OnboardingModel(
      id: 0,
      title: 'Real-Time Tracking',
      description: 'Track your produce in real time, stay ahead.',
      image: 'assets/images/onboarding_2.jpg',
    ),
    OnboardingModel(
      id: 1,
      title: 'Fresh, Healthy Produce',
      description: 'From farm to market. No spoilage. No loss.',
      image: 'assets/images/onboarding_3.jpg',
    ),
  ];

  final List<Language> languages = [
    Language(name: 'English', nativeName: 'English', code: 'en'),
    Language(name: 'Swahili', nativeName: 'Kiswahili', code: 'sw'),
    Language(name: 'Hausa', nativeName: 'Hausa', code: 'ha'),
    Language(name: 'Yoruba', nativeName: 'Yoruba', code: 'yo'),
    Language(name: 'Igbo', nativeName: 'Igbo', code: 'ig'),
    Language(name: 'Amharic', nativeName: 'Amharic', code: 'am'),
    Language(name: 'Zulu', nativeName: 'isiZulu', code: 'zu'),
    Language(name: 'Somali', nativeName: 'Somali', code: 'so'),
  ];

  void updatePageIndex(int index) {
    currentIndex.value = index;
  }

  void selectLanguage(String languageCode) {
    selectedLanguage.value = languageCode;
  }

  void nextPage() {
    if (currentIndex.value < onboardingPages.length - 1) {
      currentIndex.value++;
    }
  }

  void previousPage() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
    }
  }

  bool get isLastPage => currentIndex.value == onboardingPages.length - 1;
  bool get isFirstPage => currentIndex.value == 0;
}
