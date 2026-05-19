import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umoja_agri/controllers/language_controller.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({Key? key}) : super(key: key);

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  final LanguageController languageController = Get.put(LanguageController());
  bool _expanded = false;

  final List<Map<String, String>> languages = [
    {'name': 'English', 'native': 'English', 'code': 'en'},
    {'name': 'Swahili', 'native': 'Kiswahili', 'code': 'sw'},
    {'name': 'Hausa', 'native': 'Hausa', 'code': 'ha'},
    {'name': 'Yoruba', 'native': 'Yorùbá', 'code': 'yo'},
    {'name': 'Igbo', 'native': 'Igbo', 'code': 'ig'},
    {'name': 'Amharic', 'native': 'Amharic', 'code': 'am'},
    {'name': 'Zulu', 'native': 'isiZulu', 'code': 'zu'},
    {'name': 'Somali', 'native': 'Soomaali', 'code': 'so'},
  ];

  void _toggleExpanded() {
    setState(() {
      _expanded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEBF4DE), Color(0xFF84B737)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: _expanded ? _buildList(context) : _buildIntroCard(context),
          ),
        ),
      ),
    );
  }

  Widget _buildIntroCard(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _toggleExpanded,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.language, size: 28, color: Color(0xFF1A3C1F)),
              SizedBox(width: 12),
              Text(
                'Select Language',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A3C1F),
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_drop_down, color: Color(0xFF1A3C1F)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 12),
        Text(
          'Select Language',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: const Color(0xFF1A3C1F),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 28),
        Expanded(
          child: ListView.builder(
            itemCount: languages.length,
            itemBuilder: (context, index) {
              final language = languages[index];
              return Obx(() {
                final isSelected =
                    languageController.selectedLanguage.value ==
                    language['code'];
                return GestureDetector(
                  onTap: () {
                    languageController.changeLanguage(language['code']!);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? const Color(0xFF2E7D32)
                              : Colors.white.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color:
                            isSelected
                                ? const Color(0xFF2E7D32)
                                : Colors.transparent,
                        width: 1.5,
                      ),
                      boxShadow:
                          isSelected
                              ? []
                              : [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              language['name']!,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                color:
                                    isSelected
                                        ? Colors.white
                                        : const Color(0xFF1A3C1F),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              language['native']!,
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color:
                                    isSelected
                                        ? Colors.white70
                                        : const Color(0xFF4A6741),
                              ),
                            ),
                          ],
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              Get.offNamed('/onboarding');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1F7A3D),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              'Continue',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
