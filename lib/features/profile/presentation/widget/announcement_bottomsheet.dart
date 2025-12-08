import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/core/extension/extended_context.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:deepple_app/features/profile/presentation/widget/common_button_group.dart';

class AnnouncementBottomSheet extends StatelessWidget {
  const AnnouncementBottomSheet({
    super.key,
    required this.title,
    required this.subTitle,
    required this.content,
    required this.submitLabel,
    required this.onSubmit,
    this.cancelLabel,
    this.onCancel,
  });

  final String title;
  final String subTitle;
  final String content;
  final String submitLabel;
  final VoidCallback onSubmit;
  final String? cancelLabel;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      type: MaterialType.canvas,
      color: context.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _BottomSheetHeader(title),
            const Gap(8.0),
            _BottomSheetSubTitle(subTitle),
            const Gap(24.0),
            _AnnouncementContent(content),
            const Gap(24.0),
            if (isPrimary)
              CommonPrimaryButton(onSubmit: onSubmit, submit: Text(submitLabel))
            else
              CommonButtonGroup(
                onCancel: onCancel!,
                onSubmit: onSubmit,
                cancelLabel: cancelLabel!,
                submitLabel: submitLabel,
              ),
          ],
        ),
      ),
    );
  }

  bool get isPrimary {
    assert(
      !((cancelLabel == null) ^ (onCancel == null)),
      '[cancelLabel] and [onCancel] must be provided together.',
    );
    return cancelLabel == null || onCancel == null;
  }

  static Future<void> openPrimary(
    BuildContext context, {
    required String title,
    required String subTitle,
    required String content,
    required String submitLabel,
    required VoidCallback onSubmit,
  }) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    builder: (context) => AnnouncementBottomSheet(
      title: title,
      subTitle: subTitle,
      content: content,
      submitLabel: submitLabel,
      onSubmit: onSubmit,
    ),
  );

  static Future<void> open(
    BuildContext context, {
    required String title,
    required String subTitle,
    required String content,
    required String submitLabel,
    required VoidCallback onSubmit,
    required String cancelLabel,
    required VoidCallback onCancel,
  }) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    builder: (context) => AnnouncementBottomSheet(
      title: title,
      subTitle: subTitle,
      content: content,
      submitLabel: submitLabel,
      onSubmit: onSubmit,
      cancelLabel: cancelLabel,
      onCancel: onCancel,
    ),
  );
}

class _BottomSheetHeader extends StatelessWidget {
  const _BottomSheetHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Fonts.header03());
  }
}

class _BottomSheetSubTitle extends StatelessWidget {
  const _BottomSheetSubTitle(this.subTitle);

  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Text(
      subTitle,
      style: Fonts.body02Medium(context.colorScheme.secondary),
    );
  }
}

class _AnnouncementContent extends StatelessWidget {
  const _AnnouncementContent(this.content);

  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: context.colorScheme.secondary),
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
      ),
      constraints: const BoxConstraints(minHeight: 160.0),
      child: Text(content),
    );
  }
}
