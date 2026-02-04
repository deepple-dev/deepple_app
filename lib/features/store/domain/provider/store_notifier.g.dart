// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StoreNotifier)
const storeProvider = StoreNotifierProvider._();

final class StoreNotifierProvider
    extends $NotifierProvider<StoreNotifier, StoreState> {
  const StoreNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storeNotifierHash();

  @$internal
  @override
  StoreNotifier create() => StoreNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StoreState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StoreState>(value),
    );
  }
}

String _$storeNotifierHash() => r'728f4812f3308f5811089e0fec509d46b7c3a981';

abstract class _$StoreNotifier extends $Notifier<StoreState> {
  StoreState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<StoreState, StoreState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StoreState, StoreState>,
              StoreState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
