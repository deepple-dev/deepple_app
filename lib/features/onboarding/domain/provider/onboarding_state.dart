
import 'package:deepple_app/features/onboarding/domain/enum/auth_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_state.freezed.dart';

@freezed
abstract class OnboardingState with _$OnboardingState {
  const OnboardingState._();

  const factory OnboardingState({
    AuthStatus? status,
    required int leftSeconds,
    required bool isButtonEnabled,
    required bool isLoading,
    String? validationError,
  }) = _OnboardingState;

  factory OnboardingState.initial() => const OnboardingState(
    isButtonEnabled: false,
    leftSeconds: 0,
    isLoading: false,
  );
}
