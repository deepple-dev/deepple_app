// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_temp_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FilterTempNotifier)
const filterTempProvider = FilterTempNotifierProvider._();

final class FilterTempNotifierProvider
    extends $NotifierProvider<FilterTempNotifier, FilterTempState> {
  const FilterTempNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filterTempProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filterTempNotifierHash();

  @$internal
  @override
  FilterTempNotifier create() => FilterTempNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FilterTempState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FilterTempState>(value),
    );
  }
}

String _$filterTempNotifierHash() =>
    r'adcf95d89483c6eb9cd0417e97bbfecd16faf175';

abstract class _$FilterTempNotifier extends $Notifier<FilterTempState> {
  FilterTempState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<FilterTempState, FilterTempState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FilterTempState, FilterTempState>,
              FilterTempState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
