import 'package:deepple_app/app/widget/button/default_text_button.dart';
import 'package:deepple_app/app/widget/input/default_text_form_field.dart';
import 'package:deepple_app/app/widget/dialogue/dialogue.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/widget/view/default_app_bar.dart';
import 'package:deepple_app/app/widget/view/default_divider.dart';
import 'package:deepple_app/core/util/toast.dart';
import 'package:deepple_app/features/introduce/domain/model/introduce_info.dart';
import 'package:deepple_app/features/introduce/domain/provider/introduce_edit_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deepple_app/app/constants/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class IntroduceEditPage extends ConsumerStatefulWidget {
  final IntroduceInfo introduce;
  const IntroduceEditPage({super.key, required this.introduce});

  @override
  IntroduceEditPageState createState() => IntroduceEditPageState();
}

class IntroduceEditPageState extends ConsumerState<IntroduceEditPage> {
  late TextEditingController _inputTitleController;
  late TextEditingController _inputContentController;

  @override
  void initState() {
    super.initState();
    _inputTitleController = TextEditingController(text: widget.introduce.title);
    _inputContentController = TextEditingController(
      text: widget.introduce.content,
    );
  }

  @override
  void dispose() {
    _inputTitleController.dispose();
    _inputContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(
      introduceEditProvider(
        title: widget.introduce.title,
        content: widget.introduce.content,
      ).notifier,
    );

    final editState = ref.watch(
      introduceEditProvider(
        title: widget.introduce.title,
        content: widget.introduce.content,
      ),
    );

    bool canSubmit = ref
        .watch(
          introduceEditProvider(
            title: widget.introduce.title,
            content: widget.introduce.content,
          ),
        )
        .canSubmit;

    return Scaffold(
      appBar: DefaultAppBar(
        title: '내 소개 수정하기',
        actions: [
          DefaultTextButton(
            primary: canSubmit ? Palette.colorBlack : Palette.colorGrey500,
            onPressed: canSubmit
                ? () {
                    if (_inputContentController.text.trim().length < 30) {
                      showToastMessage('30자 이상 작성해주세요.');
                      return;
                    }

                    CustomDialogue.showTwoChoiceDialogue(
                      context: context,
                      content: '수정 버튼을 누르면\n작성된 내용을 저장합니다.',
                      elevatedButtonText: '수정',
                      onElevatedButtonPressed: () async {
                        try {
                          await notifier.editIntroduce(
                            id: widget.introduce.id,
                            title: _inputTitleController.text,
                            content: _inputContentController.text,
                          );
                          if (context.mounted) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          }
                        } catch (e) {
                          showToastMessage('내용을 수정하는데 실패했습니다.');
                        }
                      },
                    );
                  }
                : null,
            child: const Text('수정'),
          ),
        ],
        leadingAction: (context) => CustomDialogue.showTwoChoiceDialogue(
          context: context,
          content: '이 페이지를 벗어나면\n작성된 내용은 저장되지 않습니다.',
          onElevatedButtonPressed: () {
            navigate(
              context,
              route: AppRoute.mainTab,
              method: NavigationMethod.go,
            );
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(24),
          DefaultTextFormField(
            autofocus: false,
            initialValue: widget.introduce.title,
            controller: _inputTitleController,
            onChanged: (text) {
              notifier.setTitle(text);
            },
            keyboardType: TextInputType.text,
            hintText: '제목을 입력해주세요',
            style: Fonts.medium(fontSize: 16.sp, lineHeight: 1.75.h),
            hintStyle: Fonts.medium(
              fontSize: 16.sp,
              lineHeight: 1.75.h,
              color: Palette.colorGrey400,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: DefaultDivider(),
          ),
          Expanded(
            child: DefaultTextFormField(
              autofocus: false,
              initialValue: widget.introduce.content,
              controller: _inputContentController,
              onChanged: (text) {
                notifier.setContent(text);
              },
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              textAlignVertical: TextAlignVertical.top,
              maxLines: null,
              expands: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
              maxLength: 1000,
              showCharacterCount: true,
              hintText:
                  '나이 : 28세\n\n선호 관계 : 서로에게 좋은 자극을 주는 관계\n\n하는 일 : 패션 디자이너로 일하고 있어요\n\n성격 : 밝고 자존감 있는편!\n\n어필:\n대화 나누는걸 좋아해서 대화가 잘 통하는분이 좋아요\n연락 빈도수를 크게 신경쓰진 않지만\n대화가 끊길 정도가 아니면 괜찮다 생각해요!\n리액션 좋다면 최곱니다ㅎㅎ',
              style: Fonts.regular(fontSize: 14.sp, lineHeight: 1.4),
              hintStyle: Fonts.regular(
                fontSize: 14.sp,
                lineHeight: 1.4.h,
                color: Palette.colorGrey500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
