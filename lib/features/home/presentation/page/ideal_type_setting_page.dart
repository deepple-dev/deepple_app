import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/widget/dialogue/error_dialog.dart';
import 'package:deepple_app/app/widget/error/dialogue_error.dart';
import 'package:deepple_app/app/widget/widget.dart';
import 'package:deepple_app/features/home/presentation/provider/ideal_type_notifier.dart';
import 'package:deepple_app/features/home/presentation/widget/ideal/ideal_age_setting_area.dart';
import 'package:deepple_app/features/home/presentation/widget/ideal/ideal_setting_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class IdealTypeSettingPage extends ConsumerWidget {
  const IdealTypeSettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idealTypeNotifier = ref.read(idealTypeProvider.notifier);
    final idealTypeAsync = ref.watch(idealTypeProvider);

    return idealTypeAsync.when(
      data: (data) => Scaffold(
        appBar: const DefaultAppBar(title: '이상형 설정'),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                IdealAgeSettingArea(
                  minAge: data.idealType.minAge,
                  maxAge: data.idealType.maxAge,
                ),
                const Gap(24),
                IdealSettingArea(idealType: data.idealType),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: Dimens.bottomPadding,
          ),
          child: DefaultElevatedButton(
            primary: data.isFilterPossible
                ? Palette.colorPrimary500
                : Palette.colorGrey200,
            onPressed: data.isFilterPossible
                ? () async {
                    if (await idealTypeNotifier.updateIdealType() &&
                        context.mounted) {
                      return context.pop();
                    }
                  }
                : null,
            child: Text(
              '필터 적용하기',
              style: Fonts.body01Medium(
                data.isFilterPossible
                    ? Palette.colorWhite
                    : Palette.colorGrey300,
              ),
            ),
          ),
        ),
      ),
      error: (error, stack) =>
          ErrorDialog(error: DialogueErrorType.network, onConfirm: context.pop),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
