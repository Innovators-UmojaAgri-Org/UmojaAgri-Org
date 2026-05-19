import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umoja_agri/controllers/onboarding_controller.dart';
import 'package:umoja_agri/widgets/onboarding_indicator.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({Key? key}) : super(key: key);

  final OnboardingController controller = Get.put(OnboardingController());
  late final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                controller.updatePageIndex(index);
              },
              itemCount: controller.onboardingPages.length,
              itemBuilder: (context, index) {
                final page = controller.onboardingPages[index];
                return OnboardingPageView(
                  title: page.title,
                  description: page.description,
                  image: page.image,
                  currentIndex: controller.currentIndex.value,
                  itemCount: controller.onboardingPages.length,
                );
              },
            ),

            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child:
                  controller.isLastPage
                      ? SizedBox(
                        height: 56,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.offNamed('/role-selection');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1F7A3D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Get Started',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                      : Center(
                        child: GestureDetector(
                          onTap: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: const BoxDecoration(
                              color: Color(0xFF1F7A3D),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPageView extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final int currentIndex;
  final int itemCount;

  const OnboardingPageView({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
    required this.currentIndex,
    required this.itemCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE8F5E9), Color(0xFFF1F8F6)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[300],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    image,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            OnboardingIndicator(
              itemCount: itemCount,
              currentIndex: currentIndex,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(
                        color: const Color(0xFF1F7A3D),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Space for the bottom button
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
