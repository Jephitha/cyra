import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/features/wearables/models/wearable_models.dart';
import 'package:cyra/features/wearables/providers/wearable_providers.dart';
import 'package:cyra/features/wearables/screens/device_detail_screen.dart';

class WearablesHubScreen extends ConsumerStatefulWidget {
  const WearablesHubScreen({super.key});

  @override
  ConsumerState<WearablesHubScreen> createState() => _WearablesHubScreenState();
}

class _WearablesHubScreenState extends ConsumerState<WearablesHubScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final connectedAsync = ref.watch(connectedDevicesProvider);
    final availableAsync = ref.watch(availableDevicesProvider);
    final syncStatusAsync = ref.watch(syncStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wearables',
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(connectedDevicesProvider);
          ref.invalidate(availableDevicesProvider);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.xxxxl,
          ),
          children: [
            _buildSyncStatusSection(isDark, syncStatusAsync),
            const SizedBox(height: AppSpacing.xl),
            _buildConnectedDevicesSection(isDark, connectedAsync),
            const SizedBox(height: AppSpacing.xl),
            _buildAvailableDevicesSection(isDark, availableAsync),
            const SizedBox(height: AppSpacing.xxl),
            _buildPrivacyNote(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncStatusSection(
    bool isDark,
    AsyncValue<WearableSyncStatus> syncStatusAsync,
  ) {
    return syncStatusAsync.when(
      data: (status) => AppCard.standard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.sync_rounded,
                  size: 20,
                  color: status.isSyncing
                      ? AppColors.softGold
                      : AppColors.forestGreen,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Sync Status',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  ),
                ),
                const Spacer(),
                AppButton.ghost(
                  'Sync All',
                  icon: Icons.sync,
                  isLoading: status.isSyncing,
                  onPressed: status.isSyncing
                      ? null
                      : () => ref.read(syncAllDevicesProvider),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (status.isSyncing) ...[
              const LinearProgressIndicator(
                color: AppColors.forestGreen,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Syncing ${status.pendingRecords} records...',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.slate,
                ),
              ),
            ] else ...[
              Row(
                children: [
                  Text(
                    status.lastSuccessfulSync != null
                        ? 'Last sync: ${DateFormat.yMMMd().add_jm().format(status.lastSuccessfulSync!)}'
                        : 'No sync yet',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.slate,
                    ),
                  ),
                  if (status.pendingRecords > 0) ...[
                    const SizedBox(width: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xxs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                      ),
                      child: Text(
                        '${status.pendingRecords} pending',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (status.errorMessage != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  status.errorMessage!,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.error,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildConnectedDevicesSection(
    bool isDark,
    AsyncValue<List<WearableDevice>> connectedAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Connected Devices',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        connectedAsync.when(
          data: (devices) {
            if (devices.isEmpty) {
              return AppCard.standard(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                    child: Text(
                      'No devices connected',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.slate,
                      ),
                    ),
                  ),
                ),
              );
            }
            return Column(
              children: devices.map((device) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Dismissible(
                    key: ValueKey(device.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: const Icon(
                        Icons.link_off_rounded,
                        color: AppColors.onBrand,
                      ),
                    ),
                    confirmDismiss: (_) async {
                      return _confirmDisconnect(context, device);
                    },
                    onDismissed: (_) {
                      ref.read(wearableServiceProvider).disconnect(device.id);
                      ref.invalidate(connectedDevicesProvider);
                    },
                    child: AppCard.interactive(
                      onTap: () => _openDeviceDetail(device),
                      child: _buildDeviceRow(isDark, device),
                    ),
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => AppCard.standard(
            child: Text(
              'Could not load devices',
              style: TextStyle(color: AppColors.error, fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceRow(bool isDark, WearableDevice device) {
    return Row(
      children: [
        _deviceIcon(device.type),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                device.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                device.lastSyncAt != null
                    ? 'Synced ${DateFormat.yMd().add_jm().format(device.lastSyncAt!)}'
                    : 'Not synced yet',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.slate,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: device.isConnected
                ? AppColors.success
                : AppColors.slate,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget _buildAvailableDevicesSection(
    bool isDark,
    AsyncValue<List<WearableDevice>> availableAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Devices',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        availableAsync.when(
          data: (devices) {
            final available = devices.where((d) => !d.isConnected).toList();
            if (available.isEmpty) {
              return const SizedBox.shrink();
            }
            return Column(
              children: available.map((device) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: AppCard.standard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _deviceIcon(device.type),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    device.name,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: isDark
                                          ? AppColors.textPrimaryDark
                                          : AppColors.charcoal,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.xxs),
                                  Text(
                                    device.type.description,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.slate,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppButton.primary(
                          'Connect',
                          width: double.infinity,
                          onPressed: () => _connectDevice(device),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildPrivacyNote(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.charcoal.withValues(alpha: 0.2)
            : AppColors.mistWhite,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.privacy_tip_rounded,
            size: 18,
            color: AppColors.sage,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Your health data stays on your device. Wearable data is used only for cycle tracking and is never shared.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.slate,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _deviceIcon(WearableType type) {
    IconData icon;
    Color color;

    switch (type) {
      case WearableType.healthConnect:
        icon = Icons.health_and_safety_rounded;
        color = AppColors.forestGreen;
      case WearableType.appleWatch:
        icon = Icons.watch_rounded;
        color = AppColors.shadow;
      case WearableType.fitbit:
        icon = Icons.fitness_center_rounded;
        color = AppColors.softGold;
      case WearableType.garmin:
        icon = Icons.explore_rounded;
        color = AppColors.deviceOura;
      case WearableType.oura:
        icon = Icons.ring_volume_rounded;
        color = AppColors.deviceGeneric;
      case WearableType.oneplus:
        icon = Icons.devices_rounded;
        color = AppColors.deviceSamsung;
      case WearableType.oppo:
        icon = Icons.watch_rounded;
        color = AppColors.deviceGoogle;
      case WearableType.redmi:
        icon = Icons.watch_rounded;
        color = AppColors.deviceXiaomi;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Icon(icon, size: 22, color: color),
    );
  }

  Future<bool> _confirmDisconnect(BuildContext context, WearableDevice device) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Disconnect Device'),
        content: Text(
          'Disconnect ${device.name}? Synced data will be preserved.',
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
    return result ?? false;
  }

  void _openDeviceDetail(WearableDevice device) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DeviceDetailScreen(device: device),
      ),
    );
  }

  Future<void> _connectDevice(WearableDevice device) async {
    final service = ref.read(wearableServiceProvider);
    final success = await service.connect(device.type);
    if (success) {
      ref.invalidate(connectedDevicesProvider);
      ref.invalidate(availableDevicesProvider);
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? '${device.name} connected' : 'Failed to connect ${device.name}'),
          backgroundColor: success ? null : Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
