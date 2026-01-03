import 'dart:async';

import 'package:deepple_app/features/auth/presentation/page/auth_navigation_page.dart';
import 'package:deepple_app/features/auth/presentation/page/auth_sign_up_terms_page.dart';
import 'package:deepple_app/features/auth/presentation/page/sign_up_page.dart';
import 'package:deepple_app/features/auth/presentation/page/sign_up_profile_choice.dart';
import 'package:deepple_app/features/auth/presentation/page/sign_up_profile_picture_page.dart';
import 'package:deepple_app/features/auth/presentation/page/sign_up_profile_update_page.dart';
import 'package:deepple_app/features/auth/presentation/page/sign_up_profile_review_page.dart';
import 'package:deepple_app/features/auth/presentation/page/sign_up_profile_reject_page.dart';
import 'package:deepple_app/features/onboarding/presentation/page/dormant_release_page.dart';
import 'package:deepple_app/features/contact_setting/presentation/page/contact_setting_page.dart';
import 'package:deepple_app/features/exam/presentation/page/exam_cover_page.dart';
import 'package:deepple_app/features/exam/presentation/page/exam_question_page.dart';
import 'package:deepple_app/features/exam/presentation/page/exam_result_page.dart';
import 'package:deepple_app/features/home/presentation/page/main_tab_view.dart';
import 'package:deepple_app/features/home/presentation/page/page.dart';
import 'package:deepple_app/features/interview/presentation/page/interview_page.dart';
import 'package:deepple_app/features/interview/presentation/page/interview_register_page.dart';
import 'package:deepple_app/features/introduce/presentation/page/introduce_detail_page.dart';
import 'package:deepple_app/features/introduce/presentation/page/introduce_edit_page.dart';
import 'package:deepple_app/features/introduce/presentation/page/introduce_filter_page.dart';
import 'package:deepple_app/features/introduce/presentation/page/introduce_register_page.dart';
import 'package:deepple_app/features/introduce/presentation/page/navigation_page.dart';
import 'package:deepple_app/features/my/presentation/page/community_guide_page.dart';
import 'package:deepple_app/features/my/presentation/page/dormant_account_page.dart';
import 'package:deepple_app/features/my/presentation/page/my_profile_image_update_page.dart';
import 'package:deepple_app/features/my/presentation/page/page.dart';
import 'package:deepple_app/features/my/presentation/page/profile_preview_page.dart';
import 'package:deepple_app/features/notification/presentation/page/notification_page.dart';
import 'package:deepple_app/features/onboarding/presentation/page/onboarding_certificate_page.dart';
import 'package:deepple_app/features/onboarding/presentation/page/onboarding_page.dart';
import 'package:deepple_app/features/onboarding/presentation/page/onboarding_phone_number_page.dart';
import 'package:deepple_app/features/onboarding/presentation/page/temporal_forbidden_page.dart';
import 'package:deepple_app/features/profile/presentation/page/profile_page.dart';
import 'package:deepple_app/features/report/presentation/page/report_page.dart';
import 'package:deepple_app/features/heart_history/presentation/page/heart_history_page.dart';
import 'package:deepple_app/features/store/presentation/page/store_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';

import 'package:deepple_app/app/router/route_arguments.dart';
import 'package:deepple_app/app/router/named_go_route.dart';

// Global Navigator Keys
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

// State Provider Example
final authProvider = StateProvider<bool>((ref) => false);

// Navigation methods enum
enum NavigationMethod { push, replace, go, pushReplacement }

// Route names enum
enum AppRoute {
  mainTab('main-tab'),
  // Navigation
  homeNavigation('home-navigation'),
  ideal('ideal'),
  userByCategory('user-by-category'),
  myNavigation('my-navigation'),
  report('report'),

  // Introduce
  introduceRegister('introduce-register'),
  introduceEdit('introduce-edit'),
  introduceDetail('introduce-detail'),
  introduceFilter('introduce-filter'),
  introduceNavigation('introduce-navigation'),

  // Profile
  profile('profile'),
  contactSetting('contact-setting'),

  // Store
  store('store'),
  storeNavigation('store-navigation'),
  heartHistory('heart-history'),

  // DatingExam
  exam('exam'),
  examQuestion('exam-question'),
  examResult('exam-result'),

  // Notification
  notification('notification'),

  // Interview
  interview('interview'),
  interviewRegister('interview-register'),

  // Onboard
  onboard('onboard'),
  onboardPhone('onboard-phone'),
  onboardCertification('onboard-certification'),
  dormantRelease('dormant-release'),
  temporalForbidden('temporal-forbidden'),

  // Auth
  auth('auth'),
  authNavigation('auth-navigation'),
  signUp('sign-up'),
  signUpProfile('sign-up-profile'),
  signUpTerms('sign-up-terms'),
  signUpProfileChoice('sign-up-profile-choice'),
  signUpProfileUpdate('sign-up-profile-update'),
  signUpProfilePicture('sign-up-profile-picture'),
  signUpProfileReview('sign-up-profile-review'),
  signUpProfileReject('sign-up-profile-reject'),

  // My
  profileManage('profile-manage'),
  profileUpdate('profile-update'),
  idealSetting('ideal-setting'),
  blockFriend('block-friend'),
  customerCenter('customer-center'),
  setting('setting'),
  pushNotificationSetting('push-notification-setting'),
  accountSetting('account-setting'),
  serviceWithdraw('service-withdraw'),
  withdrawReason('withdraw-reason'),
  privacyPolicy('privacy-policy'),
  termsOfUse('terms-of-use'),
  communityGuide('community-guide'),
  myProfileImageUpdate('my-profile-image-update'),
  profilePreview('profile-preview'),
  dormantAccount('dormant-account');

  final String name;

  const AppRoute(this.name);
}

final allRoutes = [
  NamedGoRoute(
    root: true,
    name: AppRoute.mainTab.name,
    builder: (context, state) => const MainTabView(),
  ),
  // Home routes
  NamedGoRoute(
    root: true,
    name: AppRoute.homeNavigation.name,
    builder: (context, state) => const HomeNavigationPage(),
    routes: [
      NamedGoRoute(
        name: AppRoute.ideal.name,
        builder: (context, state) => const IdealTypeSettingPage(),
      ),
      NamedGoRoute(
        name: AppRoute.userByCategory.name,
        builder: (context, state) {
          final args = state.extra;
          if (args is! UserByCategoryArguments) {
            return const SizedBox.shrink();
          }
          return UserByCategoryPage(category: args.category);
        },
      ),
    ],
  ),
  NamedGoRoute(
    root: true,
    name: AppRoute.myNavigation.name,
    builder: (context, state) => const MyNavigationPage(),
  ),
  NamedGoRoute(
    root: true,
    name: AppRoute.report.name,
    builder: (context, state) {
      final args = state.extra;
      if (args is! ReportArguments) {
        return const SizedBox.shrink();
      }
      return ReportPage(name: args.name, userId: args.userId);
    },
  ),
  NamedGoRoute(
    root: true,
    name: AppRoute.introduceRegister.name,
    builder: (context, state) => const IntroduceRegisterPage(),
  ),
  NamedGoRoute(
    root: true,
    name: AppRoute.introduceEdit.name,
    builder: (context, state) {
      final args = state.extra;
      if (args is! IntroduceEditArguments) {
        return const SizedBox.shrink();
      }
      return IntroduceEditPage(
        introduce: args.introduce,
      );
    },
  ),
  NamedGoRoute(
    root: true,
    name: AppRoute.introduceDetail.name,
    builder: (context, state) {
      final args = state.extra;
      if (args is! IntroduceDetailArguments) {
        return const SizedBox.shrink();
      }
      return IntroduceDetailPage(introduceId: args.introduceId);
    },
  ),
  NamedGoRoute(
    root: true,
    name: AppRoute.introduceFilter.name,
    builder: (context, state) => const IntroduceFilterPage(),
  ),
  NamedGoRoute(
    root: true,
    name: AppRoute.introduceNavigation.name,
    builder: (context, state) => const IntroduceNavigationPage(),
  ),
  NamedGoRoute(
    root: true,
    name: AppRoute.interview.name,
    builder: (context, state) => const InterviewPage(),
  ),
  NamedGoRoute(
    root: true,
    name: AppRoute.interviewRegister.name,
    builder: (context, state) {
      final args = state.extra;
      if (args is! InterviewRegisterArguments) {
        return const SizedBox.shrink();
      }
      return InterviewRegisterPage(
        question: args.question,
        answer: args.answer,
        currentTabIndex: args.currentTabIndex,
        answerId: args.answerId,
        questionId: args.questionId,
        isAnswered: args.isAnswered,
      );
    },
  ),
  NamedGoRoute(
    root: true,
    name: AppRoute.profile.name,
    builder: (context, state) {
      final args = state.extra;
      if (args is! ProfileDetailArguments) return const SizedBox.shrink();
      return ProfilePage(
        userId: args.userId,
        fromMatchedProfile: args.fromMatchedProfile,
      );
    },
    routes: [
      NamedGoRoute(
        name: AppRoute.contactSetting.name,
        builder: (context, state) => const ContactSettingPage(),
      ),
    ],
  ),
  NamedGoRoute(
    root: true,
    name: AppRoute.exam.name,
    builder: (context, state) => const ExamCoverPage(),
    routes: [
      NamedGoRoute(
        name: AppRoute.examQuestion.name,
        builder: (context, state) => const ExamQuestionPage(),
      ),
      NamedGoRoute(
        name: AppRoute.examResult.name,
        builder: (context, state) {
          final args = state.extra;
          if (args is! ExamResultArguments) {
            return const SizedBox.shrink();
          }
          return ExamResultPage(isFromDirectAccess: args.isFromDirectAccess);
        },
      ),
    ],
  ),
  NamedGoRoute(
    root: true,
    name: AppRoute.notification.name,
    builder: (context, state) => const NotificationPage(),
  ),
  NamedGoRoute(
    root: true,
    name: AppRoute.store.name,
    builder: (context, state) => const StorePage(),
    routes: [
      NamedGoRoute(
        name: AppRoute.heartHistory.name,
        builder: (context, state) => const HeartHistoryPage(),
      ),
    ],
  ),
  // Onboard routes
  NamedGoRoute(
    root: true,
    name: AppRoute.onboard.name,
    builder: (context, state) => const OnBoardPage(),
    routes: [
      NamedGoRoute(
        name: AppRoute.onboardPhone.name,
        builder: (context, state) => const OnboardingPhoneInputPage(),
      ),
      NamedGoRoute(
        name: AppRoute.onboardCertification.name,
        builder: (context, state) {
          final args = state.extra;
          if (args is! OnboardCertificationArguments) {
            return const SizedBox.shrink();
          }
          return OnboardingCertificationPage(phoneNumber: args.phoneNumber);
        },
      ),
      NamedGoRoute(
        name: AppRoute.dormantRelease.name,
        builder: (context, state) {
          final args = state.extra;
          if (args is! DormantReleaseArguments) {
            return const SizedBox.shrink();
          }

          return DormantReleasePage(phoneNumber: args.phoneNumber);
        },
      ),
      NamedGoRoute(
        name: AppRoute.temporalForbidden.name,
        builder: (context, state) {
          final args = state.extra;
          if (args is! TemporalForbiddenArguments) {
            return const SizedBox.shrink();
          }
          return TemporalForbiddenPage(suspensionExpireAt: args.time);
        },
      ),
      NamedGoRoute(
        name: AppRoute.signUpProfileReview.name,
        builder: (context, state) => const SignUpProfileReviewPage(),
      ),
      NamedGoRoute(
        name: AppRoute.signUpProfileReject.name,
        builder: (context, state) => const SignUpProfileRejectPage(),
      ),
    ],
  ),
  // Auth routes
  NamedGoRoute(
    root: true,
    name: AppRoute.authNavigation.name,
    builder: (context, state) => const AuthNavigationPage(),
    routes: [
      NamedGoRoute(
        name: AppRoute.signUp.name,
        builder: (context, state) => const SignUpPage(),
        routes: [
          NamedGoRoute(
            name: AppRoute.signUpProfileChoice.name,
            builder: (context, state) => const SignUpProfileChoicePage(),
          ),
          NamedGoRoute(
            name: AppRoute.signUpProfilePicture.name,
            builder: (context, state) => const SignUpProfilePicturePage(),
          ),
          NamedGoRoute(
            name: AppRoute.signUpTerms.name,
            builder: (context, state) => const AuthSignUpTermsPage(),
          ),
          NamedGoRoute(
            name: AppRoute.signUpProfileUpdate.name,
            builder: (context, state) => const SignUpProfileUpdatePage(),
          ),
        ],
      ),
    ],
  ),

  NamedGoRoute(
    root: true,
    name: AppRoute.profileManage.name,
    builder: (context, state) {
      final args = state.extra;

      if (args is MyProfileManageArguments) {
        return ProfileManagePage(isRejectedProfile: args.isRejectedProfile);
      }

      return const ProfileManagePage(isRejectedProfile: false);
    },
    routes: [
      NamedGoRoute(
        name: AppRoute.profileUpdate.name,
        builder: (context, state) {
          final args = state.extra;
          if (args is! MyProfileUpdateArguments) {
            return const SizedBox.shrink();
          }
          return ProfileUpdatePage(profileType: args.profileType);
        },
      ),
      NamedGoRoute(
        name: AppRoute.myProfileImageUpdate.name,
        builder: (context, state) {
          final args = state.extra;
          if (args is! MyProfileImageUpdateArguments) {
            return const SizedBox.shrink();
          }
          return MyProfileImageUpdatePage(profileImages: args.profileImages);
        },
      ),
      NamedGoRoute(
        name: AppRoute.profilePreview.name,
        builder: (context, state) {
          final args = state.extra;
          if (args is! ProfilePreviewArguments) {
            return const SizedBox.shrink();
          }
          return ProfilePreviewPage(profile: args.profile);
        },
      ),
      NamedGoRoute(
        name: AppRoute.dormantAccount.name,
        builder: (_, __) => const DormantAccountPage(),
      ),
    ],
  ),
  NamedGoRoute(
    root: true,
    name: AppRoute.idealSetting.name,
    builder: (context, state) => const IdealTypeSettingPage(),
  ),
  NamedGoRoute(
    root: true,
    name: AppRoute.blockFriend.name,
    builder: (context, state) => const MyBlockFriendPage(),
  ),
  NamedGoRoute(
    root: true,
    name: AppRoute.customerCenter.name,
    builder: (context, state) => const CustomerCenterPage(), // 수정 완료
  ),
  NamedGoRoute(
    root: true,
    name: AppRoute.setting.name,
    builder: (context, state) => const MySettingPage(),
    routes: [
      NamedGoRoute(
        name: AppRoute.pushNotificationSetting.name,
        builder: (context, state) => const PushNotificationSettingPage(),
      ),
      NamedGoRoute(
        name: AppRoute.accountSetting.name,
        builder: (context, state) => const MyAccountSettingPage(),
        routes: [
          NamedGoRoute(
            name: AppRoute.serviceWithdraw.name,
            builder: (context, state) => const ServiceWithdrawPage(),
          ),
          NamedGoRoute(
            name: AppRoute.withdrawReason.name,
            builder: (context, state) => const ServiceWithdrawReasonPage(),
          ),
        ],
      ),
      NamedGoRoute(
        name: AppRoute.privacyPolicy.name,
        builder: (context, state) => const PrivacyPolicyPage(),
      ),
      NamedGoRoute(
        name: AppRoute.termsOfUse.name,
        builder: (context, state) => const TermsOfUsePage(),
      ),
      NamedGoRoute(
        name: AppRoute.communityGuide.name,
        builder: (context, state) => const CommunityGuidePage(),
      ),
    ],
  ),
];

// Navigation helper methods
void pop(BuildContext context, [Object? extra]) =>
    Navigator.of(context).pop(extra);

Future<T?> navigate<T>(
  BuildContext context, {
  required AppRoute route,
  NavigationMethod method = NavigationMethod.push,
  RouteArguments? extra,
}) async {
  final goRouter = GoRouter.of(context);

  return switch (method) {
    NavigationMethod.push => await goRouter.pushNamed<T>(
      route.name,
      extra: extra,
    ),
    NavigationMethod.replace => await goRouter.replaceNamed<T>(
      route.name,
      extra: extra,
    ),

    NavigationMethod.go => (() {
      goRouter.goNamed(route.name, extra: extra);
      return null;
    })(),

    NavigationMethod.pushReplacement => await goRouter.pushReplacementNamed<T>(
      route.name,
      extra: extra,
    ),
  };
}

extension ContextExtension on BuildContext {
  void popUntil(AppRoute route) {
    final delegate = GoRouter.of(this).routerDelegate;
    var config = delegate.currentConfiguration;
    var routes = config.routes.whereType<GoRoute>();
    while (routes.length > 1 && config.last.route.name != route.name) {
      config = config.remove(config.last);
      routes = config.routes.whereType<GoRoute>();
    }
    delegate.setNewRoutePath(config);
  }
}
