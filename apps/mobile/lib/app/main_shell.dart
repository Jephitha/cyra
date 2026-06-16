import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/app_typography.dart';
import 'package:cyra/core/design/widgets/privacy_lock.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/providers/security_providers.dart';
import 'package:cyra/core/security/privacy_service.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> with WidgetsBindingObserver {
  int _currentIndex = 0;
  bool _isPrivateMode = false;
  int _tripleTapCount = 0;
  DateTime? _lastBackPress;
  final _navigatorKeys = List.generate(5, (_) => GlobalKey<NavigatorState>());

  final _tabLabels = const [
    'Home',
    'Calendar',
    'Insights',
    'Community',
    'Settings',
  ];

  final _tabIcons = const [
    Icons.home_outlined,
    Icons.calendar_month_outlined,
    Icons.insights_outlined,
    Icons.forum_outlined,
    Icons.settings_outlined,
  ];

  final _tabActiveIcons = const [
    Icons.home,
    Icons.calendar_month,
    Icons.insights,
    Icons.forum,
    Icons.settings,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() => _tripleTapCount = 0);
    }
  }

  void _onTabTapped(int index) {
    if (index == _currentIndex) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentIndex = index);
    }
  }

  Future<bool> _onWillPop() async {
    final navigator = _navigatorKeys[_currentIndex].currentState;
    if (navigator != null && navigator.canPop()) {
      navigator.pop();
      return false;
    }

    if (_currentIndex != 0) {
      setState(() => _currentIndex = 0);
      return false;
    }

    final now = DateTime.now();
    if (_lastBackPress != null &&
        now.difference(_lastBackPress!) < const Duration(seconds: 2)) {
      return true;
    }

    _lastBackPress = now;
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Press back again to exit'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    return false;
  }

  void _handleAppBarTripleTap() {
    setState(() => _tripleTapCount++);
    if (_tripleTapCount >= 3) {
      _tripleTapCount = 0;
      _activateEmergencyLock();
    }
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _tripleTapCount = 0);
    });
  }

  Future<void> _activateEmergencyLock() async {
    try {
      final privacyService = ref.read(privacyServiceProvider);
      await privacyService.activateEmergencyLock();
      setState(() => _isPrivateMode = true);

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: const Text('Emergency Lock Active'),
            content: const Text(
              'Your health data is now hidden. The app is displaying a safe screen.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to activate emergency lock: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.backgroundDark : AppColors.warmIvory;

    if (_isPrivateMode) {
      return _buildSafeScreen(context, isDark);
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            _buildAppBar(context, isDark),
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: List.generate(5, (index) {
                  return _buildTabPage(index);
                }),
              ),
            ),
            _buildBottomNav(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDark) {
    final showTitle = _currentIndex == 0;
    final bgColor = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;

    return Semantics(
      label: 'Triple tap to activate emergency lock. Current tab: ${_tabLabels[_currentIndex]}',
      child: GestureDetector(
        onTap: _handleAppBarTripleTap,
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            border: Border(
              bottom: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  if (showTitle) ...[
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.forestGreen,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: const Icon(
                        Icons.water_drop,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Cyra',
                      style: AppTypography.light.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.charcoal,
                      ),
                    ),
                  ] else ...[
                    Text(
                      _tabLabels[_currentIndex],
                      style: AppTypography.light.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.charcoal,
                      ),
                    ),
                  ],
                  const Spacer(),
                  _buildEmergencyLockButton(),
                  const SizedBox(width: AppSpacing.sm),
                  PrivacyLockIcon(isLocked: false),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyLockButton() {
    return Semantics(
      label: 'Activate emergency lock',
      child: Tooltip(
        message: 'Emergency Lock',
        child: GestureDetector(
          onLongPress: _activateEmergencyLock,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: AppColors.error,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(5, (index) {
              final isActive = index == _currentIndex;
              return Expanded(
                child: Semantics(
                  label: _tabLabels[index],
                  selected: isActive,
                  child: GestureDetector(
                    onTap: () => _onTabTapped(index),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.forestGreen.withValues(alpha: 0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isActive
                                ? _tabActiveIcons[index]
                                : _tabIcons[index],
                            size: 24,
                            color: isActive
                                ? AppColors.forestGreen
                                : AppColors.slate,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _tabLabels[index],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight:
                                  isActive ? FontWeight.w600 : FontWeight.w500,
                              color: isActive
                                  ? AppColors.forestGreen
                                  : AppColors.slate,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildTabPage(int index) {
    switch (index) {
      case 0:
        return _buildPlaceholderTab('Home', Icons.home_outlined);
      case 1:
        return _buildPlaceholderTab('Calendar', Icons.calendar_month_outlined);
      case 2:
        return _buildPlaceholderTab('Insights', Icons.insights_outlined);
      case 3:
        return _buildPlaceholderTab('Community', Icons.forum_outlined);
      case 4:
        return _buildPlaceholderTab('Settings', Icons.settings_outlined);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPlaceholderTab(String name, IconData icon) {
    return Navigator(
      key: _navigatorKeys[_tabLabels.indexOf(name)],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 48, color: AppColors.sage),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    name,
                    style: AppTypography.light.titleLarge?.copyWith(
                      color: AppColors.slate,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSafeScreen(BuildContext context, bool isDark) {
    final bgColor = isDark ? AppColors.backgroundDark : AppColors.warmIvory;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.charcoal;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.forestGreen.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_outline,
                    size: 40,
                    color: AppColors.forestGreen,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                Text(
                  'Health Tracker',
                  style: AppTypography.light.headlineSmall?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Your app is locked for privacy.\nTap here to continue.',
                  textAlign: TextAlign.center,
                  style: AppTypography.light.bodyMedium?.copyWith(
                    color: AppColors.slate,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                TextButton(
                  onPressed: () async {
                    final privacyService = ref.read(privacyServiceProvider);
                    try {
                      await privacyService.deactivateEmergencyLock();
                      setState(() => _isPrivateMode = false);
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to unlock: $e')),
                        );
                      }
                    }
                  },
                  child: const Text('Tap to Unlock'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
