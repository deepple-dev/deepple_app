import 'dart:async';

import 'package:deepple_app/app/constants/enum.dart';
import 'package:deepple_app/core/config/config.dart';
import 'package:deepple_app/core/notification/firebase_manager.dart';
import 'package:deepple_app/core/provider/default_provider_observer.dart';
import 'package:deepple_app/core/util/log.dart';
import 'package:deepple_app/core/util/shared_preference/shared_preference.dart';
import 'package:deepple_app/features/auth/data/dto/user_response.dart';
import 'package:deepple_app/features/home/data/dto/introduced_profile_dto.dart';
import 'package:deepple_app/features/home/domain/model/cached_user_profile.dart';
import 'package:deepple_app/features/my/domain/model/my_profile_image.dart';
import 'package:deepple_app/features/profile/domain/common/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'package:deepple_app/app/app.dart';

void main() {
  runZonedGuarded(() async {
    App.preserveSplash(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
    );

    /// 환경 변수 초기화
    await Config.initialize(); // 여기에서 호출
    await SharedPreferenceManager.initialize();
    await FirebaseManager().initialize();

    /// 기기 방향 세로로 고정
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    /// Hive - 로컬 데이터베이스 초기화
    await Hive.initFlutter();
    Hive.registerAdapter<UserData>(UserDataAdapter());
    Hive.registerAdapter<CachedUserProfile>(CachedUserProfileAdapter());
    Hive.registerAdapter<InterviewInfo>(InterviewInfoAdapter());
    Hive.registerAdapter<MyProfileImage>(MyProfileImageAdapter());
    Hive.registerAdapter<IntroducedProfileDto>(IntroducedProfileDtoAdapter());
    Hive.registerAdapter<Gender>(GenderAdapter());
    Hive.registerAdapter<Education>(EducationAdapter());
    Hive.registerAdapter<Hobby>(HobbyAdapter());
    Hive.registerAdapter<Job>(JobAdapter());
    Hive.registerAdapter<SmokingStatus>(SmokingStatusAdapter());
    Hive.registerAdapter<DrinkingStatus>(DrinkingStatusAdapter());
    Hive.registerAdapter<Religion>(ReligionAdapter());

    /// 앱 실행
    runApp(
      ProviderScope(observers: [DefaultProviderObserver()], child: const App()),
    );
  }, (error, stack) => Log.e('MAIN', errorObject: error, stackTrace: stack));
}
