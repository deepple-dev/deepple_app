import 'package:deepple_app/features/introduce/domain/model/introduce_detail.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'introduce_detail_state.freezed.dart';

@freezed
abstract class IntroduceDetailState with _$IntroduceDetailState {
  const factory IntroduceDetailState({
    @Default(-1) int introduceId,
    @Default(null) IntroduceDetail? introduceDetail,
    @Default(false) bool isLoaded,
    @Default(0) int heartPoint,
  }) = _IntroduceDetailState;

  const IntroduceDetailState._();

  factory IntroduceDetailState.initial() => const IntroduceDetailState();
}
