import 'dart:convert';

import 'package:deepple_app/app/enum/contact_method.dart';
import 'package:deepple_app/core/util/shared_preference/shared_preference_manager.dart';
import 'package:deepple_app/features/notification/domain/model/server_notification_type.dart';

part 'parser.dart';

class SharedPreferenceKeys {
  static const enabledNotifications =
      SharedPreferenceKey<List<ServerNotificationType>>(
        'enabledNotifications',
        defaultValue: [],
        fromJson: _enabledNotificationsFromJson,
        toJson: _enabledNotificationsToJson,
      );

  static const notificationAllowed = SharedPreferencePrimitiveKey<bool>(
    'notificationAllowed',
    defaultValue: false,
  );

  /// 셀프소개 필터 - 나이
  static const preferredAgeStart = SharedPreferencePrimitiveKey<int>(
    'preferredAgeStart',
    defaultValue: null,
  );

  static const preferredAgeEnd = SharedPreferencePrimitiveKey<int>(
    'preferredAgeEnd',
    defaultValue: null,
  );

  /// 셀프소개 필터 - 선호 지역(한글)
  static const preferredCities = SharedPreferencePrimitiveKey<List<String>>(
    'preferredCities',
    defaultValue: [],
  );

  static const defaultContactMethod = SharedPreferenceKey<ContactMethod?>(
    'defaultContactMethod',
    fromJson: _contactMethodFromJson,
    toJson: _contactMethodToJson,
  );

  /// 셀프소개 필터 - 성별
  ///
  /// 0 - null
  ///
  /// 1 - male
  ///
  /// 2 - female
  static const showAllGender = SharedPreferencePrimitiveKey<int>(
    'showAllGender',
    defaultValue: 0,
  );
}
