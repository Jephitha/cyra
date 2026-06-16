import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/core/design/widgets/health_stat_card.dart';
import 'package:cyra/features/wearables/models/wearable_models.dart';
import 'package:cyra/features/wearables/providers/wearable_providers.dart';

class DeviceDetailScreen extends ConsumerStatefulWidget {
  final WearableDevice device;

  const DeviceDetailScreen({super.key, required this.device});

  @override
  ConsumerState<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends ConsumerState<DeviceDetailScreen> {
  late WearableDevice _device;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _device = widget.device;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _device.name,
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xxxxl,
        ),
        children: [
          _buildDeviceHeader(isDark),
          const SizedBox(height: AppSpacing.xl),
          _buildConnectionStatus(isDark),
          const SizedBox(height: AppSpacing.lg),
          _buildSyncButton(isDark),
          const SizedBox(height: AppSpacing.xl),
          _buildEnabledDataTypes(isDark),
          const SizedBox(height: AppSpacing.xl),
          _buildRecentDataSummary(isDark),
          const SizedBox(height: AppSpacing.xl),
          _buildDataUsageExplanations(isDark),
          const SizedBox(height: AppSpacing.xxl),
          _buildDisconnectButton(isDark),
        ],
      ),
    );
  }

  Widget _buildDeviceHeader(bool isDark) {
    return AppCard.standard(
      child: Row(
        children: [
          _deviceIcon(isDark, _device.type),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _device.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                if (_device.deviceModel != null)
                  Text(
                    'Model: ${_device.deviceModel}',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.slate,
                    ),
                  ),
                if (_device.firmwareVersion != null)
                  Text(
                    'Firmware: ${_device.firmwareVersion}',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.slate,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus(bool isDark) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          size: 10,
          color: _device.isConnected ? AppColors.success : AppColors.error,
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          _device.isConnected ? 'Connected' : 'Disconnected',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: _device.isConnected ? AppColors.success : AppColors.error,
          ),
        ),
        const Spacer(),
        if (_device.lastSyncAt != null)
          Text(
            'Last sync: ${DateFormat.yMd().add_jm().format(_device.lastSyncAt!)}',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.slate,
            ),
          ),
      ],
    );
  }

  Widget _buildSyncButton(bool isDark) {
    return AppButton.primary(
      'Sync Now',
      icon: Icons.sync_rounded,
      isLoading: _isSyncing,
      onPressed: _isSyncing ? null : _performSync,
      width: double.infinity,
    );
  }

  Future<void> _performSync() async {
    setState(() => _isSyncing = true);
    try {
      final service = ref.read(wearableServiceProvider);
      await service.syncData(_device.id);
      ref.invalidate(deviceDataSummaryProvider(_device.id));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sync complete')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sync failed'), backgroundColor: Theme.of(context).colorScheme.error));
      }
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  Widget _buildEnabledDataTypes(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enabled Data Types',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard.standard(
          child: Column(
            children: [
              _buildDataTypeToggle(
                isDark,
                'Temperature',
                'temperature',
                Icons.thermostat_rounded,
              ),
              const Divider(
                height: 1,
                color: AppColors.borderLight,
              ),
              _buildDataTypeToggle(
                isDark,
                'Sleep Data',
                'sleep',
                Icons.bedtime_rounded,
              ),
              const Divider(
                height: 1,
                color: AppColors.borderLight,
              ),
              _buildDataTypeToggle(
                isDark,
                'Heart Rate',
                'heartRate',
                Icons.monitor_heart_rounded,
              ),
              const Divider(
                height: 1,
                color: AppColors.borderLight,
              ),
              _buildDataTypeToggle(
                isDark,
                'Activity',
                'activity',
                Icons.directions_walk_rounded,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataTypeToggle(
    bool isDark,
    String label,
    String dataType,
    IconData icon,
  ) {
    final enabled = _device.enabledDataTypes[dataType] ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.forestGreen),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              ),
            ),
          ),
          Switch(
            value: enabled,
            activeTrackColor: AppColors.forestGreen,
            onChanged: (val) => _toggleDataType(dataType),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleDataType(String dataType) async {
    final service = ref.read(wearableServiceProvider);
    await service.enableDataType(_device.id, dataType);
    setState(() {
      final updated = Map<String, bool>.from(_device.enabledDataTypes);
      updated[dataType] = !(updated[dataType] ?? false);
      _device = _device.copyWith(enabledDataTypes: updated);
    });
  }

  Widget _buildRecentDataSummary(bool isDark) {
    final summaryAsync = ref.watch(
      deviceDataSummaryProvider(_device.id, days: 7),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Last 7 Days Summary',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        summaryAsync.when(
          data: (summary) => GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            childAspectRatio: 1.4,
            children: [
              HealthStatCard(
                label: 'Avg Temperature',
                value: '${summary.averageTemperature.toStringAsFixed(1)}°C',
                icon: Icons.thermostat_rounded,
                accentColor: AppColors.softGold,
              ),
              HealthStatCard(
                label: 'Avg Heart Rate',
                value: '${summary.averageHeartRate.toStringAsFixed(0)} bpm',
                icon: Icons.monitor_heart_rounded,
                accentColor: AppColors.error,
              ),
              HealthStatCard(
                label: 'Avg Sleep',
                value: '${summary.averageSleepHours.toStringAsFixed(1)} hrs',
                icon: Icons.bedtime_rounded,
                accentColor: const Color(0xFF7B61FF),
              ),
              HealthStatCard(
                label: 'Steps',
                value: _formatSteps(summary.stepCount),
                icon: Icons.directions_walk_rounded,
                accentColor: AppColors.forestGreen,
              ),
            ],
          ),
          loading: () => GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            childAspectRatio: 1.4,
            children: const [
              HealthStatCard(label: '', value: '', icon: Icons.thermostat_rounded, isLoading: true),
              HealthStatCard(label: '', value: '', icon: Icons.monitor_heart_rounded, isLoading: true),
              HealthStatCard(label: '', value: '', icon: Icons.bedtime_rounded, isLoading: true),
              HealthStatCard(label: '', value: '', icon: Icons.directions_walk_rounded, isLoading: true),
            ],
          ),
          error: (_, __) => AppCard.standard(
            child: Center(
              child: Text(
                'Could not load data summary',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.slate,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataUsageExplanations(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How Your Data Is Used',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard.standard(
          child: Column(
            children: [
              _buildExplanationRow(
                Icons.thermostat_rounded,
                'Temperature data improves ovulation detection',
              ),
              const Divider(height: 1, color: AppColors.borderLight),
              _buildExplanationRow(
                Icons.bedtime_rounded,
                'Sleep data helps track cycle-related sleep changes',
              ),
              const Divider(height: 1, color: AppColors.borderLight),
              _buildExplanationRow(
                Icons.monitor_heart_rounded,
                'Heart rate variability indicates recovery phases',
              ),
              const Divider(height: 1, color: AppColors.borderLight),
              _buildExplanationRow(
                Icons.directions_walk_rounded,
                'Activity levels correlate with cycle phases',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExplanationRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.sage),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.slate,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisconnectButton(bool isDark) {
    return AppButton.secondary(
      'Disconnect',
      icon: Icons.link_off_rounded,
      onPressed: _confirmDisconnect,
      width: double.infinity,
    );
  }

  Future<void> _confirmDisconnect() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Disconnect Device'),
        content: Text(
          'Disconnect ${_device.name}? Your synced data will be preserved on this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.slate),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Disconnect',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final service = ref.read(wearableServiceProvider);
      await service.disconnect(_device.id);
      ref.invalidate(connectedDevicesProvider);
      if (mounted) Navigator.of(context).maybePop();
    }
  }

  Widget _deviceIcon(bool isDark, WearableType type) {
    IconData icon;
    Color color;

    switch (type) {
      case WearableType.appleWatch:
        icon = Icons.watch_rounded;
        color = Colors.black;
      case WearableType.fitbit:
        icon = Icons.fitness_center_rounded;
        color = AppColors.softGold;
      case WearableType.garmin:
        icon = Icons.explore_rounded;
        color = Colors.blueGrey;
      case WearableType.oura:
        icon = Icons.ring_volume_rounded;
        color = const Color(0xFF7B61FF);
      case WearableType.oneplus:
        icon = Icons.devices_rounded;
        color = const Color(0xFFEB0029);
      case WearableType.oppo:
        icon = Icons.watch_rounded;
        color = const Color(0xFF0D7A3F);
      case WearableType.redmi:
        icon = Icons.watch_rounded;
        color = const Color(0xFFFF6B00);
    }

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Icon(icon, size: 28, color: color),
    );
  }

  String _formatSteps(int steps) {
    if (steps >= 1000) {
      return '${(steps / 1000).toStringAsFixed(1)}k';
    }
    return steps.toString();
  }
}
