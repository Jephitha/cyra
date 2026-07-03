import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/features/auth/providers/auth_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const _pageCount = 3;

  final _gradients = [
    [AppColors.forestGreen, const Color(0xFF0D2B1E)],
    [const Color(0xFF1B4332), const Color(0xFF2D6A4F)],
    [const Color(0xFF2D6A4F), AppColors.forestGreenDark],
  ];

  final _pageData = const [
    _OnboardingPageData(
      icon: Icons.security,
      title: 'Your Body, Your Data',
      subtitle:
          'Your health information stays on your device. End-to-end encrypted and never shared without your explicit consent.',
      feature1: 'Local-first privacy architecture',
      feature2: 'No cloud storage by default',
      feature3: 'You control what leaves your device',
    ),
    _OnboardingPageData(
      icon: Icons.loop,
      title: 'Understand Your Cycle',
      subtitle:
          'Explainable AI that helps you understand your patterns without black-box predictions.',
      feature1: 'Evidence-based cycle insights',
      feature2: 'Clear, explainable predictions',
      feature3: 'Learn what your body is telling you',
    ),
    _OnboardingPageData(
      icon: Icons.timeline_outlined,
      title: 'Your Lifelong Companion',
      subtitle:
          'From your first period through fertility, pregnancy, and menopause — Cyra grows with you.',
      feature1: 'Period tracking & predictions',
      feature2: 'Fertility awareness & planning',
      feature3: 'Pregnancy & menopause support',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (!_pageController.hasClients) return;
      final page = _pageController.page ?? 0;
      setState(() {
        _currentPage = page.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _pageCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _onSkip() {
    _completeOnboarding();
  }

  void _completeOnboarding() {
    ref.read(onboardingStateProvider.notifier).complete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _pageController,
        builder: (context, _) {
          final progress = _pageController.hasClients ? _pageController.page ?? 0 : 0.0;
          final index = progress.floor();
          final fraction = progress - index;
          final nextIndex = (index + 1).clamp(0, _gradients.length - 1);

          final currentColors = _gradients[index];
          final nextColors = _gradients[nextIndex];

          final color1 = Color.lerp(currentColors[0], nextColors[0], fraction)!;
          final color2 = Color.lerp(currentColors[1], nextColors[1], fraction)!;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color1, color2],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildTopBar(),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _pageCount,
                      onPageChanged: (page) {
                        setState(() => _currentPage = page);
                      },
                      itemBuilder: (context, index) {
                        return _OnboardingPage(
                          data: _pageData[index],
                          index: index,
                          currentPage: _currentPage,
                        );
                      },
                    ),
                  ),
                  _buildBottomSection(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Cyra',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.9),
              letterSpacing: -0.3,
            ),
          ),
          if (_currentPage < _pageCount - 1)
            GestureDetector(
              onTap: _onSkip,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                child: Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xxl,
        AppSpacing.xl,
        AppSpacing.xxl,
        AppSpacing.xxxl,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.2),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDotIndicator(),
          const SizedBox(height: AppSpacing.xxl),
          AppButton.primary(
            _currentPage < _pageCount - 1 ? 'Next' : 'Get Started',
            onPressed: _onNext,
            width: double.infinity,
            height: 54,
          ),
        ],
      ),
    );
  }

  Widget _buildDotIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pageCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 28 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? Colors.white
                : Colors.white.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingPageData data;
  final int index;
  final int currentPage;

  const _OnboardingPage({
    required this.data,
    required this.index,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    final offset = (index - currentPage).toDouble();

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: (index - currentPage).abs() <= 1 ? 1.0 : 0.0,
      child: Transform.translate(
        offset: Offset(offset * 40, 0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIllustration(),
              const SizedBox(height: AppSpacing.xxxxl),
              Text(
                data.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                data.subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.55,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              _buildFeatureList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.12),
      ),
      child: Center(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.1),
          ),
          child: Icon(
            data.icon,
            size: 52,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureList() {
    final features = [data.feature1, data.feature2, data.feature3];
    return Column(
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                feature,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.75),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _OnboardingPageData {
  final IconData icon;
  final String title;
  final String subtitle;
  final String feature1;
  final String feature2;
  final String feature3;

  const _OnboardingPageData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.feature1,
    required this.feature2,
    required this.feature3,
  });
}
