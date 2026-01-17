// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GlobalNotifier)
const globalProvider = GlobalNotifierProvider._();

final class GlobalNotifierProvider
    extends $NotifierProvider<GlobalNotifier, AppGlobalState> {
  const GlobalNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'globalProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$globalNotifierHash();

  @$internal
  @override
  GlobalNotifier create() => GlobalNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppGlobalState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppGlobalState>(value),
    );
  }
}

String _$globalNotifierHash() => r'1416bc98509e1ee9878722251b29fcf904cdcd4d';

abstract class _$GlobalNotifier extends $Notifier<AppGlobalState> {
  AppGlobalState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AppGlobalState, AppGlobalState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppGlobalState, AppGlobalState>,
              AppGlobalState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
