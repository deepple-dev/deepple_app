// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'introduce_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(IntroduceNotifier)
const introduceProvider = IntroduceNotifierProvider._();

final class IntroduceNotifierProvider
    extends $AsyncNotifierProvider<IntroduceNotifier, IntroduceState> {
  const IntroduceNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'introduceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$introduceNotifierHash();

  @$internal
  @override
  IntroduceNotifier create() => IntroduceNotifier();
}

String _$introduceNotifierHash() => r'4b831d695e833472c9345371af953291d8504671';

abstract class _$IntroduceNotifier extends $AsyncNotifier<IntroduceState> {
  FutureOr<IntroduceState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<IntroduceState>, IntroduceState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<IntroduceState>, IntroduceState>,
              AsyncValue<IntroduceState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
