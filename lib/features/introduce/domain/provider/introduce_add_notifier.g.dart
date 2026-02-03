// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'introduce_add_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(IntroduceAddNotifier)
const introduceAddProvider = IntroduceAddNotifierProvider._();

final class IntroduceAddNotifierProvider
    extends $NotifierProvider<IntroduceAddNotifier, IntroduceAddState> {
  const IntroduceAddNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'introduceAddProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$introduceAddNotifierHash();

  @$internal
  @override
  IntroduceAddNotifier create() => IntroduceAddNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IntroduceAddState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IntroduceAddState>(value),
    );
  }
}

String _$introduceAddNotifierHash() =>
    r'0e81861400928b991fed6ef65a650aae58adc0e1';

abstract class _$IntroduceAddNotifier extends $Notifier<IntroduceAddState> {
  IntroduceAddState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<IntroduceAddState, IntroduceAddState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<IntroduceAddState, IntroduceAddState>,
              IntroduceAddState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
