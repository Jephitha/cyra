import 'package:flutter/material.dart';
import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_button.dart';

class _MucusTypeOption {
  final String id;
  final String name;
  final String description;
  final String fertilityMeaning;
  final IconData icon;
  final bool isFertile;

  const _MucusTypeOption({
    required this.id,
    required this.name,
    required this.description,
    required this.fertilityMeaning,
    required this.icon,
    required this.isFertile,
  });
}

const _mucusTypes = [
  _MucusTypeOption(
    id: 'dry',
    name: 'Dry',
    description: 'No visible mucus, dry sensation',
    fertilityMeaning: 'Not fertile — low chance of conception',
    icon: Icons.eco_outlined,
    isFertile: false,
  ),
  _MucusTypeOption(
    id: 'sticky',
    name: 'Sticky',
    description: 'Thick, white or yellow, crumbly texture',
    fertilityMeaning: 'Low fertility — approaching fertile window',
    icon: Icons.circle_rounded,
    isFertile: false,
  ),
  _MucusTypeOption(
    id: 'creamy',
    name: 'Creamy',
    description: 'White, creamy, lotion-like texture',
    fertilityMeaning: 'Moderate fertility — fertile window opening',
    icon: Icons.opacity_rounded,
    isFertile: false,
  ),
  _MucusTypeOption(
    id: 'egg_white',
    name: 'Egg White',
    description: 'Clear, stretchy, slippery — like raw egg white',
    fertilityMeaning: 'Peak fertility — optimal time for conception',
    icon: Icons.blur_on_rounded,
    isFertile: true,
  ),
  _MucusTypeOption(
    id: 'watery',
    name: 'Watery',
    description: 'Clear, watery, wet sensation',
    fertilityMeaning: 'High fertility — fertile window',
    icon: Icons.water_drop_outlined,
    isFertile: true,
  ),
];

const _consistencyOptions = ['Stretchy', 'Sticky', 'Crumbly', 'Smooth', 'Lumpy'];
const _colorOptions = ['Clear', 'White', 'Yellow', 'Brown', 'Pink'];
const _amountOptions = ['None', 'Scant', 'Light', 'Moderate', 'Heavy'];

class LogMucusScreen extends StatefulWidget {
  const LogMucusScreen({super.key});

  @override
  State<LogMucusScreen> createState() => _LogMucusScreenState();
}

class _LogMucusScreenState extends State<LogMucusScreen> {
  String? _selectedTypeId;
  String? _consistency;
  String? _color;
  String _amount = 'Moderate';

  int currentCycleDay = 14;
  int cycleLength = 28;

  _MucusTypeOption? get _selectedType {
    if (_selectedTypeId == null) return null;
    return _mucusTypes.firstWhere((t) => t.id == _selectedTypeId);
  }

  bool get _isInFertileWindow {
    final ovulationDay = cycleLength - 14;
    return currentCycleDay >= ovulationDay - 5 && currentCycleDay <= ovulationDay + 1;
  }

  String get _educationalTip {
    if (_selectedType == null) return '';
    switch (_selectedType!.id) {
      case 'dry':
        return 'Dry days are typically non-fertile. This is normal after menstruation and in the early follicular phase.';
      case 'sticky':
        return 'Sticky mucus indicates estrogen is beginning to rise. Fertility is still low, but the fertile window is approaching.';
      case 'creamy':
        return 'Creamy mucus is a transition type. Estrogen levels are increasing, and fertility is moderate. Watch for changes to egg white mucus.';
      case 'egg_white':
        return 'Egg white cervical mucus (EWCM) is the most fertile type. It helps sperm survive and travel. This is your peak fertility signal!';
      case 'watery':
        return 'Watery mucus indicates high fertility. It allows sperm to pass through easily. You may be in or near your fertile window.';
      default:
        return '';
    }
  }

  void _save() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Log Cervical Mucus',
            style: TextStyle(
              color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _buildCycleDayBanner(context, isDark),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'Mucus Type',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ..._mucusTypes.map((type) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _buildMucusOption(context, type, isDark),
              );
            }),
            if (_selectedType != null) ...[
              const SizedBox(height: AppSpacing.xxl),
              _buildDetailSelectors(context, isDark),
              const SizedBox(height: AppSpacing.lg),
              _buildEducationalTip(context, isDark),
            ],
            const SizedBox(height: AppSpacing.xxl),
            AppButton.primary(
              'Save',
              icon: Icons.save_rounded,
              onPressed: _selectedTypeId != null ? _save : null,
              width: double.infinity,
            ),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildCycleDayBanner(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: _isInFertileWindow
              ? AppColors.forestGreen.withValues(alpha: 0.3)
              : (isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        color: _isInFertileWindow
            ? AppColors.forestGreen.withValues(alpha: 0.06)
            : (isDark ? AppColors.charcoal.withValues(alpha: 0.15) : AppColors.mistWhite),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_rounded,
            size: 20,
            color: _isInFertileWindow ? AppColors.forestGreen : AppColors.slate,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'Cycle day $currentCycleDay — ${_isInFertileWindow ? "fertile" : "not fertile"}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: _isInFertileWindow ? AppColors.forestGreen : (isDark ? AppColors.textPrimaryDark : AppColors.charcoal),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMucusOption(BuildContext context, _MucusTypeOption type, bool isDark) {
    final isSelected = _selectedTypeId == type.id;
    final borderColor = type.isFertile ? AppColors.softGold : AppColors.forestGreen;

    return Semantics(
      button: true,
      selected: isSelected,
      label: '${type.name}: ${type.description}, ${type.fertilityMeaning}',
      child: GestureDetector(
        onTap: () => setState(() => _selectedTypeId = type.id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: isSelected
                ? borderColor.withValues(alpha: isDark ? 0.2 : 0.08)
                : (isDark ? AppColors.charcoal.withValues(alpha: 0.15) : AppColors.mistWhite),
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: isSelected ? borderColor.withValues(alpha: 0.6) : (isDark ? AppColors.borderDark : AppColors.borderLight),
              width: isSelected ? 2.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: borderColor.withValues(alpha: isSelected ? 0.2 : 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(type.icon, size: 24, color: borderColor.withValues(alpha: isSelected ? 1 : 0.7)),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          type.name,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: isSelected ? borderColor : (isDark ? AppColors.textPrimaryDark : AppColors.charcoal),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (type.isFertile) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppColors.softGold.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(AppRadius.xl),
                            ),
                            child: Text(
                              'Fertile',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.softGold,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      type.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.slate,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      type.fertilityMeaning,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: type.isFertile ? AppColors.softGold : AppColors.sage,
                        fontStyle: FontStyle.italic,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSelectors(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Details',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildSelectorRow(context, 'Consistency', _consistencyOptions, _consistency, (v) {
          setState(() => _consistency = v);
        }, isDark),
        const SizedBox(height: AppSpacing.md),
        _buildSelectorRow(context, 'Color', _colorOptions, _color, (v) {
          setState(() => _color = v);
        }, isDark),
        const SizedBox(height: AppSpacing.md),
        _buildSelectorRow(context, 'Amount', _amountOptions, _amount, (v) {
          setState(() => _amount = v);
        }, isDark),
      ],
    );
  }

  Widget _buildSelectorRow(
    BuildContext context,
    String label,
    List<String> options,
    String? selected,
    ValueChanged<String> onChanged,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.slate,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: options.map((option) {
              final isSelected = selected == option;
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: GestureDetector(
                  onTap: () => onChanged(option),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.forestGreen.withValues(alpha: isDark ? 0.3 : 0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.forestGreen
                            : (isDark ? AppColors.borderDark : AppColors.borderLight),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      option,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? (isDark ? Colors.white : AppColors.forestGreen)
                            : (isDark ? AppColors.textSecondaryDark : AppColors.slate),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildEducationalTip(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: (_selectedType!.isFertile ? AppColors.softGold : AppColors.forestGreen)
            .withValues(alpha: isDark ? 0.15 : 0.06),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: (_selectedType!.isFertile ? AppColors.softGold : AppColors.forestGreen)
              .withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline_rounded, size: 20,
              color: _selectedType!.isFertile ? AppColors.softGold : AppColors.forestGreen),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              _educationalTip,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.slate,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
