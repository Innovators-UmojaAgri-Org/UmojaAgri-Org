class OnboardingModel {
  final int id;
  final String title;
  final String description;
  final String image;

  OnboardingModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
  });
}

class Language {
  final String name;
  final String nativeName;
  final String code;

  Language({
    required this.name,
    required this.nativeName,
    required this.code,
  });
}
