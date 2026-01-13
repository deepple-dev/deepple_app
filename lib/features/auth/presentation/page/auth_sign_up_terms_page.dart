import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/widget/button/default_elevated_button.dart';
import 'package:deepple_app/app/widget/dialogue/error_dialog.dart';
import 'package:deepple_app/app/widget/error/dialogue_error.dart';
import 'package:deepple_app/app/widget/icon/default_icon.dart';
import 'package:deepple_app/app/widget/text/title_text.dart';
import 'package:deepple_app/core/state/base_page_state.dart';
import 'package:deepple_app/features/auth/domain/provider/sign_up_process_notifier.dart';
import 'package:deepple_app/features/auth/presentation/widget/auth_step_indicator_widget.dart';
import 'package:deepple_app/features/photo/domain/model/profile_photo.dart';
import 'package:deepple_app/features/photo/domain/provider/photo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class AuthSignUpTermsPage extends ConsumerStatefulWidget {
  const AuthSignUpTermsPage({super.key});

  @override
  AuthSignUpTermsPageState createState() => AuthSignUpTermsPageState();
}

class AuthSignUpTermsPageState
    extends BaseConsumerStatefulPageState<AuthSignUpTermsPage> {
  AuthSignUpTermsPageState() : super(defaultAppBarTitle: '계정 생성');

  List<bool> _isChecked = List.generate(3, (_) => false);
  bool get isButtonEnabled => _isChecked[1] && _isChecked[2];

  void _updateCheckState(int index) {
    setState(() {
      // 모두 동의 체크박스일 경우
      if (index == 0) {
        bool isAllChecked = !_isChecked.every((element) => element);
        _isChecked = List.generate(3, (index) => isAllChecked);
      } else {
        _isChecked[index] = !_isChecked[index];
        _isChecked[0] = _isChecked.getRange(1, 3).every((element) => element);
      }
    });
  }

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AuthStepIndicatorWidget(totalSteps: 4, currentStep: 4),
                Gap(16.h),
                const TitleText(title: '서비스 이용 및 가입을 위해 \n약관에 동의해주세요'),
                Gap(28.h),
                ..._renderCheckList(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: Dimens.bottomPadding),
            child: DefaultElevatedButton(
              onPressed: isButtonEnabled
                  ? () async {
                      // 프로필 이미지 등록
                      final List<XFile?> photos = ref.read(photoProvider);

                      final profilePhotos = photos
                          .whereType<XFile>()
                          .map(
                            (e) => ProfilePhoto(imageFile: e, isUpdated: true),
                          )
                          .toList();

                      final profileImageUploaded = await ref
                          .read(photoProvider.notifier)
                          .uploadPhotos(profilePhotos);

                      if (!context.mounted) return;

                      if (!profileImageUploaded) {
                        ErrorDialog.open(
                          context,
                          error: DialogueErrorType.failSignUp,
                          onConfirm: context.pop,
                        );
                        return;
                      }

                      // 프로필 등록
                      final isSuccess = await ref
                          .read(signUpProcessProvider.notifier)
                          .uploadProfile();

                      if (!isSuccess) return;

                      if (!context.mounted) return;

                      // 심사대기 화면으로 이동
                      navigate(context, route: AppRoute.signUpProfileReview);
                    }
                  : null,
              child: Text(
                '회원가입 완료',
                style: Fonts.body01Medium(
                  isButtonEnabled ? palette.onPrimary : Palette.colorGrey400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _renderCheckList() {
    List<String> labels = ['전체 동의하기', '(필수) 이용약관 동의', '(필수) 개인정보 처리방침 동의'];

    List<Widget> list = [
      renderContainer(_isChecked[0], labels[0], 0, () => _updateCheckState(0)),
    ];

    list.addAll(
      List.generate(
        2,
        (index) => renderContainer(
          _isChecked[index + 1],
          labels[index + 1],
          index + 1,
          () => _updateCheckState(index + 1),
        ),
      ),
    );

    return list;
  }

  Widget renderContainer(bool checked, String text, index, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: index != 0
                ? Palette.colorWhite
                : checked
                ? Palette.colorPrimary100
                : Palette.colorGrey100,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          padding: const EdgeInsets.only(
            top: 14.0,
            bottom: 14.0,
            left: 16.0,
            right: 16.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  children: [
                    index == 0
                        ? DefaultIcon(
                            checked ? IconPath.checkFill : IconPath.check,
                            size: 24,
                          )
                        : DefaultIcon(
                            IconPath.check,
                            colorFilter: ColorFilter.mode(
                              checked
                                  ? Palette.colorPrimary500.withOpacity(0.6)
                                  : Palette.colorGrey300.withOpacity(0.6),
                              BlendMode.srcIn,
                            ),
                            size: 24,
                          ),
                    const SizedBox(width: 8),
                    Text(
                      text,
                      style: Fonts.body01Regular(
                        index == 0
                            ? Palette.colorGrey900
                            : Palette.colorGrey700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: index != 0
                    ? GestureDetector(
                        onTap: () {
                          // TODO: 이용약관, 개인정보 처리방침 화면 나오면 연결 필요함
                          navigate(
                            context,
                            route: index != 1
                                ? AppRoute.privacyPolicy
                                : AppRoute.termsOfUse,
                          );
                        },
                        child: Text(
                          '보기',
                          style: Fonts.body01Regular(Palette.colorGrey900),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
