import 'package:deepple_app/app/widget/view/default_app_bar_action_group.dart';
import 'package:deepple_app/core/state/base_page_state.dart';
import 'package:deepple_app/app/widget/widget.dart';
import 'package:deepple_app/app/widget/view/default_tap_bar.dart';
import 'package:deepple_app/features/interview/presentation/widget/question_card.dart';
import 'package:deepple_app/features/interview/presentation/widget/interview_banner_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deepple_app/app/constants/constants.dart';
import 'package:gap/gap.dart';

class InterviewPage extends ConsumerStatefulWidget {
  const InterviewPage({super.key});

  @override
  InterviewPageState createState() => InterviewPageState();
}

class InterviewPageState extends BaseConsumerStatefulPageState<InterviewPage> {
  InterviewPageState() : super(isAppBar: false, isHorizontalMargin: false);
  bool _isBannerVisible = true;
  int _currentTabIndex = 0;

  void _onTabTapped(int index) => safeSetState(() => _currentTabIndex = index);

  void _closeBanner() => safeSetState(() => _isBannerVisible = false);

  @override
  Widget buildPage(BuildContext context) {
    final double horizontalPadding = screenWidth * 0.05;
    final EdgeInsets contentPadding = EdgeInsets.symmetric(
      horizontal: horizontalPadding,
    );
    const double tagSpacing = 16;

    return Scaffold(
      appBar: DefaultAppBar(
        title: '인터뷰',
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTabBar(
              tabs: ['나', '관계', '연인'],
              currentIndex: _currentTabIndex,
              onTap: _onTabTapped,
              horizontalPadding: horizontalPadding,
            ),
            if (_isBannerVisible)
              Padding(
                padding: contentPadding,
                child: InterviewBannerWidget(onClose: _closeBanner),
              ),
            if (!_isBannerVisible) const Gap(12),
            Expanded(
              child: QuestionCard(
                tagSpacing: tagSpacing,
                contentPadding: contentPadding,
                currentTabIndex: _currentTabIndex,
                horizontalPadding: horizontalPadding,
              ),
            ),
          ],
      ),
    );
  }
}
