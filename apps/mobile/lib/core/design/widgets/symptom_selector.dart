import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/app_typography.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/utils/extensions.dart';

class SymptomOption {
  final String id;
  final String name;
  final IconData icon;
  final String category;
  final Color color;

  const SymptomOption({
    required this.id,
    required this.name,
    required this.icon,
    required this.category,
    this.color = AppColors.sage,
  });

  static List<SymptomOption> defaultSymptoms() => const [
    SymptomOption(id: 'cramping', name: 'Cramping', icon: Icons.healing, category: 'Pain'),
    SymptomOption(id: 'bloating', name: 'Bloating', icon: Icons.water_drop, category: 'Digestive'),
    SymptomOption(id: 'headache', name: 'Headache', icon: Icons.face, category: 'Pain'),
    SymptomOption(id: 'fatigue', name: 'Fatigue', icon: Icons.battery_alert, category: 'Energy'),
    SymptomOption(id: 'nausea', name: 'Nausea', icon: Icons.sick, category: 'Digestive'),
    SymptomOption(id: 'breast_tenderness', name: 'Breast Tenderness', icon: Icons.favorite, category: 'Physical'),
    SymptomOption(id: 'mood_swings', name: 'Mood Swings', icon: Icons.mood_bad, category: 'Emotional'),
    SymptomOption(id: 'spotting', name: 'Spotting', icon: Icons.colorize, category: 'Bleeding'),
    SymptomOption(id: 'backache', name: 'Backache', icon: Icons.accessibility_new, category: 'Pain'),
    SymptomOption(id: 'acne', name: 'Acne', icon: Icons.face_retouching_natural, category: 'Skin'),
    SymptomOption(id: 'cravings', name: 'Cravings', icon: Icons.restaurant, category: 'Digestive'),
    SymptomOption(id: 'insomnia', name: 'Insomnia', icon: Icons.bedtime, category: 'Sleep'),
    SymptomOption(id: 'dizziness', name: 'Dizziness', icon: Icons.air, category: 'Physical'),
    SymptomOption(id: 'ovulation_pain', name: 'Ovulation Pain', icon: Icons.circle, category: 'Pain'),
    SymptomOption(id: 'increased_appetite', name: 'Increased Appetite', icon: Icons.restaurant_menu, category: 'Digestive'),
    SymptomOption(id: 'leg_cramps', name: 'Leg Cramps', icon: Icons.directions_walk, category: 'Pain'),
    SymptomOption(id: 'hot_flashes', name: 'Hot Flashes', icon: Icons.whatshot, category: 'Physical'),
    SymptomOption(id: 'anxiety', name: 'Anxiety', icon: Icons.psychology, category: 'Emotional'),
    SymptomOption(id: 'constipation', name: 'Constipation', icon: Icons.hourglass_bottom, category: 'Digestive'),
    SymptomOption(id: 'gas', name: 'Gas', icon: Icons.bubble_chart, category: 'Digestive'),
  ];
}

class SymptomSelector extends StatefulWidget {
  final List<SymptomOption> symptoms;
  final List<String> selectedSymptomIds;
  final ValueChanged<List<String>>? onSelectionChanged;
  final bool searchable;

  const SymptomSelector({
    super.key,
    required this.symptoms,
    required this.selectedSymptomIds,
    this.onSelectionChanged,
    this.searchable = false,
  });

  @override
  State<SymptomSelector> createState() => _SymptomSelectorState();
}

class _SymptomSelectorState extends State<SymptomSelector> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  String _searchQuery = '';
  final Set<String> _collapsedCategories = {};

  List<SymptomOption> get _filteredSymptoms {
    if (_searchQuery.isEmpty) return widget.symptoms;
    return widget.symptoms.where((s) {
      return s.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  Map<String, List<SymptomOption>> get _groupedSymptoms {
    final result = <String, List<SymptomOption>>{};
    for (final symptom in _filteredSymptoms) {
      result.putIfAbsent(symptom.category, () => []).add(symptom);
    }
    return result;
  }

  void _toggleSymptom(String id) {
    final updated = List<String>.from(widget.selectedSymptomIds);
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    widget.onSelectionChanged?.call(updated);
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_collapsedCategories.contains(category)) {
        _collapsedCategories.remove(category);
      } else {
        _collapsedCategories.add(category);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;
    final crossAxisCount = isTablet ? 6 : 4;
    final grouped = _groupedSymptoms;
    final hasResults = _filteredSymptoms.isNotEmpty;
    final orderedCategories = ['physical', 'emotional', 'lifestyle'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.searchable) _buildSearchField(),
        if (!hasResults)
          _buildEmptyState()
        else
          ...orderedCategories.where(grouped.containsKey).map((category) {
            return _buildCategorySection(category, grouped[category]!, crossAxisCount);
          }),
      ],
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Search symptoms...',
          prefixIcon: const Icon(Icons.search, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    _searchQuery = '';
                    _searchFocusNode.unfocus();
                    setState(() {});
                  },
                )
              : null,
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48,
              color: AppColors.slate.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No symptoms found',
              style: AppTypography.light.bodyLarge?.copyWith(
                color: AppColors.slate,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(
    String category,
    List<SymptomOption> symptoms,
    int crossAxisCount,
  ) {
    final isCollapsed = _collapsedCategories.contains(category);
    final categoryLabel = _categoryLabel(category);
    final categoryIcon = _categoryIcon(category);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => _toggleCategory(category),
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.sm,
                horizontal: AppSpacing.xs,
              ),
              child: Row(
                children: [
                  Icon(categoryIcon, size: 18, color: AppColors.forestGreen),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    categoryLabel,
                    style: AppTypography.light.titleSmall?.copyWith(
                      color: AppColors.charcoal,
                    ),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: isCollapsed ? 0.0 : -0.5,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_up_rounded,
                      size: 20,
                      color: AppColors.slate,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: _buildSymptomGrid(symptoms, crossAxisCount),
            secondChild: const SizedBox.shrink(),
            crossFadeState: isCollapsed
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }

  String _categoryLabel(String category) {
    switch (category) {
      case 'physical':
        return 'Physical';
      case 'emotional':
        return 'Emotional';
      case 'lifestyle':
        return 'Lifestyle';
      default:
        return category;
    }
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'physical':
        return Icons.favorite_border_rounded;
      case 'emotional':
        return Icons.self_improvement_rounded;
      case 'lifestyle':
        return Icons.water_drop_rounded;
      default:
        return Icons.circle_outlined;
    }
  }

  Widget _buildSymptomGrid(List<SymptomOption> symptoms, int crossAxisCount) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 0.9,
          crossAxisSpacing: AppSpacing.sm,
          mainAxisSpacing: AppSpacing.sm,
        ),
        itemCount: symptoms.length,
        itemBuilder: (context, index) {
          return _SymptomTile(
            option: symptoms[index],
            isSelected: widget.selectedSymptomIds.contains(symptoms[index].id),
            onTap: () => _toggleSymptom(symptoms[index].id),
          );
        },
      ),
    );
  }

  static List<SymptomOption> defaultSymptoms() {
    return const [
      SymptomOption(
        id: 'cramps',
        name: 'Cramps',
        icon: Icons.healing_rounded,
        category: 'physical',
        color: Color(0xFFE57373),
      ),
      SymptomOption(
        id: 'headache',
        name: 'Headache',
        icon: Icons.face_rounded,
        category: 'physical',
        color: Color(0xFFF06292),
      ),
      SymptomOption(
        id: 'bloating',
        name: 'Bloating',
        icon: Icons.circle_outlined,
        category: 'physical',
        color: Color(0xFFBA68C8),
      ),
      SymptomOption(
        id: 'acne',
        name: 'Acne',
        icon: Icons.fiber_manual_record_rounded,
        category: 'physical',
        color: Color(0xFFF48FB1),
      ),
      SymptomOption(
        id: 'breast_tenderness',
        name: 'Breast Tenderness',
        icon: Icons.favorite_border_rounded,
        category: 'physical',
        color: Color(0xFFF06292),
      ),
      SymptomOption(
        id: 'fatigue',
        name: 'Fatigue',
        icon: Icons.bedtime_rounded,
        category: 'physical',
        color: Color(0xFF9575CD),
      ),
      SymptomOption(
        id: 'back_pain',
        name: 'Back Pain',
        icon: Icons.accessibility_new_rounded,
        category: 'physical',
        color: Color(0xFFE57373),
      ),
      SymptomOption(
        id: 'nausea',
        name: 'Nausea',
        icon: Icons.sentiment_very_dissatisfied_rounded,
        category: 'physical',
        color: Color(0xFF81C784),
      ),
      SymptomOption(
        id: 'anxiety',
        name: 'Anxiety',
        icon: Icons.psychology_rounded,
        category: 'emotional',
        color: Color(0xFF64B5F6),
      ),
      SymptomOption(
        id: 'mood_swings',
        name: 'Mood Swings',
        icon: Icons.mood_bad_rounded,
        category: 'emotional',
        color: Color(0xFF4FC3F7),
      ),
      SymptomOption(
        id: 'irritability',
        name: 'Irritability',
        icon: Icons.flash_on_rounded,
        category: 'emotional',
        color: Color(0xFFFF8A65),
      ),
      SymptomOption(
        id: 'sadness',
        name: 'Sadness',
        icon: Icons.cloud_rounded,
        category: 'emotional',
        color: Color(0xFF7986CB),
      ),
      SymptomOption(
        id: 'depression',
        name: 'Depression',
        icon: Icons.water_drop_rounded,
        category: 'emotional',
        color: Color(0xFF90A4AE),
      ),
      SymptomOption(
        id: 'sleep_quality',
        name: 'Sleep Quality',
        icon: Icons.nights_stay_rounded,
        category: 'lifestyle',
        color: Color(0xFF81C784),
      ),
      SymptomOption(
        id: 'exercise',
        name: 'Exercise',
        icon: Icons.directions_run_rounded,
        category: 'lifestyle',
        color: Color(0xFFAED581),
      ),
      SymptomOption(
        id: 'nutrition',
        name: 'Nutrition',
        icon: Icons.restaurant_rounded,
        category: 'lifestyle',
        color: Color(0xFFDCE775),
      ),
      SymptomOption(
        id: 'water_intake',
        name: 'Water Intake',
        icon: Icons.local_drink_rounded,
        category: 'lifestyle',
        color: Color(0xFF4DD0E1),
      ),
      SymptomOption(
        id: 'stress_level',
        name: 'Stress Level',
        icon: Icons.self_improvement_rounded,
        category: 'lifestyle',
        color: Color(0xFFFFB74D),
      ),
    ];
  }
}

class _SymptomTile extends StatelessWidget {
  final SymptomOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _SymptomTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tileColor = option.color;
    final selectedBg = tileColor.withValues(alpha: isDark ? 0.35 : 0.2);
    final unselectedBg = isDark
        ? AppColors.charcoal.withValues(alpha: 0.3)
        : AppColors.mistWhite;
    final unselectedBorder = isDark
        ? AppColors.borderDark
        : AppColors.borderLight;
    final iconColor = isSelected ? tileColor : AppColors.slate;
    final labelColor = isSelected
        ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
        : AppColors.slate;

    return Semantics(
      button: true,
      selected: isSelected,
      label: option.name,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedScale(
          scale: isSelected ? 1.0 : 0.95,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: isSelected ? selectedBg : unselectedBg,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: isSelected
                  ? Border.all(color: tileColor.withValues(alpha: 0.5), width: 1.5)
                  : Border.all(color: unselectedBorder, width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? tileColor.withValues(alpha: isDark ? 0.25 : 0.15)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    option.icon,
                    size: 22,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                  child: Text(
                    option.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.light.labelSmall?.copyWith(
                      color: labelColor,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
