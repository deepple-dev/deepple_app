// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'introduce_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(IntroduceDetailNotifier)
const introduceDetailProvider = IntroduceDetailNotifierFamily._();

final class IntroduceDetailNotifierProvider
    extends
        $AsyncNotifierProvider<IntroduceDetailNotifier, IntroduceDetailState> {
  const IntroduceDetailNotifierProvider._({
    required IntroduceDetailNotifierFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'introduceDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$introduceDetailNotifierHash();

  @override
  String toString() {
    return r'introduceDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  IntroduceDetailNotifier create() => IntroduceDetailNotifier();

  @override
  bool operator ==(Object other) {
    return other is IntroduceDetailNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$introduceDetailNotifierHash() =>
    r'10ab00f3484df7bb37d434df8d0cb86346dd002d';

final class IntroduceDetailNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          IntroduceDetailNotifier,
          AsyncValue<IntroduceDetailState>,
          IntroduceDetailState,
          FutureOr<IntroduceDetailState>,
          int
        > {
  const IntroduceDetailNotifierFamily._()
    : super(
        retry: null,
        name: r'introduceDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IntroduceDetailNotifierProvider call({required int introduceId}) =>
      IntroduceDetailNotifierProvider._(argument: introduceId, from: this);

  @override
  String toString() => r'introduceDetailProvider';
}

abstract class _$IntroduceDetailNotifier
    extends $AsyncNotifier<IntroduceDetailState> {
  late final _$args = ref.$arg as int;
  int get introduceId => _$args;

  FutureOr<IntroduceDetailState> build({required int introduceId});
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(introduceId: _$args);
    final ref =
        this.ref
            as $Ref<AsyncValue<IntroduceDetailState>, IntroduceDetailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<IntroduceDetailState>,
                IntroduceDetailState
              >,
              AsyncValue<IntroduceDetailState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
