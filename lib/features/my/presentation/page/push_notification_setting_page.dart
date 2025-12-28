import 'package:deepple_app/app/widget/view/default_app_bar.dart';
import 'package:deepple_app/core/extension/extension.dart';
import 'package:deepple_app/features/my/presentation/provider/my_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deepple_app/features/my/presentation/provider/my_setting_notifier.dart';

class PushNotificationSettingPage extends ConsumerWidget {
  const PushNotificationSettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(mySettingProvider);
    return provider.when(
      data: (settings) => Scaffold(
        appBar: const DefaultAppBar(title: '푸쉬알림 설정'),
        body: SafeArea(
          child: Column(
            children: [
              _LabelSwitchRow(
                label: '앱푸시 알림을 설정하시면\n새로운 메시지, 관심을 받는 즉시 알려드려요',
                value: settings.notificationEnabled,
                onChanged: (_) => ref
                    .read(mySettingProvider.notifier)
                    .tryToggleNotificationEnableStatus(),
              ),
              Divider(
                height: 3.0,
                thickness: 3.0,
                color: context.colorScheme.outline,
              ),
              if (settings.notificationEnabled)
                ...UserNotificationType.values.map(
                  (type) => _LabelSwitchRow(
                    label: type.description,
                    value: settings.enabledNotifications.contains(type),
                    onChanged: (_) => ref
                        .read(mySettingProvider.notifier)
                        .toggleNotification(type),
                    labelStyle: TextStyle(
                      color: settings.enabledNotifications.contains(type)
                          ? Colors.black
                          : const Color(0xffB2B2B2),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      error: (error, stack) => Center(child: Text('Error: $error')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class _LabelSwitchRow extends StatelessWidget {
  final String label;
  final TextStyle? labelStyle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _LabelSwitchRow({
    required this.label,
    this.labelStyle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: context.colorScheme.outline, width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: labelStyle),
          SizedBox(
            height: 24,
            child: Switch(
              inactiveTrackColor: const Color(0xffDEDEDE),
              inactiveThumbImage: const AssetImage(
                'assets/icons/inactive_thumb_image.svg',
              ),
              value: value,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
