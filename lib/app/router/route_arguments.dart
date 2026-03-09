import 'package:deepple_app/app/constants/enum.dart';
import 'package:deepple_app/features/introduce/domain/model/introduce_info.dart';
import 'package:deepple_app/features/photo/domain/model/profile_photo.dart';
import 'package:deepple_app/features/my/my.dart';

sealed class RouteArguments {
  const RouteArguments();
}

class ProfileDetailArguments extends RouteArguments {
  const ProfileDetailArguments({
    required this.userId,
    this.fromMatchedProfile = false,
  });

  final int userId;
  final bool fromMatchedProfile;
}

class OnboardCertificationArguments extends RouteArguments {
  const OnboardCertificationArguments({required this.phoneNumber});

  final String phoneNumber;
}

class UserByCategoryArguments extends RouteArguments {
  const UserByCategoryArguments({required this.category});

  final IntroducedCategory category;
}

class MyProfileManageArguments extends RouteArguments {
  const MyProfileManageArguments({this.isRejectedProfile = false});

  final bool isRejectedProfile;
}

class MyProfileUpdateArguments extends RouteArguments {
  const MyProfileUpdateArguments({required this.profileType});

  final String profileType;
}

class MyProfileImageUpdateArguments extends RouteArguments {
  const MyProfileImageUpdateArguments({required this.profileImages});

  final List<ProfilePhoto> profileImages;
}

class ProfilePreviewArguments extends RouteArguments {
  const ProfilePreviewArguments({required this.profile});

  final MyProfile profile;
}

class InterviewRegisterArguments extends RouteArguments {
  const InterviewRegisterArguments({
    required this.question,
    required this.answer,
    required this.currentTabIndex,
    required this.answerId,
    required this.questionId,
    required this.isAnswered,
  });

  final String question;
  final String answer;
  final int currentTabIndex;
  final int? answerId;
  final int? questionId;
  final bool isAnswered;
}

class ReportArguments extends RouteArguments {
  const ReportArguments({required this.name, required this.userId});

  final String name;
  final int userId;
}

class DormantReleaseArguments extends RouteArguments {
  const DormantReleaseArguments({required this.phoneNumber});

  final String phoneNumber;
}

class IntroduceEditArguments extends RouteArguments {
  const IntroduceEditArguments({required this.introduce});

  final IntroduceInfo introduce;
}

class IntroduceDetailArguments extends RouteArguments {
  const IntroduceDetailArguments({required this.introduceId});

  final int introduceId;
}

class TemporalForbiddenArguments extends RouteArguments {
  const TemporalForbiddenArguments({this.time});

  final DateTime? time;
}
