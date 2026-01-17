// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'introduce_edit_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(IntroduceEditNotifier)
const introduceEditProvider = IntroduceEditNotifierFamily._();

final class IntroduceEditNotifierProvider
    extends $NotifierProvider<IntroduceEditNotifier, IntroduceEditState> {
  const IntroduceEditNotifierProvider._({
    required IntroduceEditNotifierFamily super.from,
    required ({String title, String content}) super.argument,
  }) : super(
         retry: null,
         name: r'introduceEditProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$introduceEditNotifierHash();

  @override
  String toString() {
    return r'introduceEditProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  IntroduceEditNotifier create() => IntroduceEditNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IntroduceEditState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IntroduceEditState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IntroduceEditNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$introduceEditNotifierHash() =>
    r'1f3b4e8f0fcae971646a9e1b3a24e6073131efe7';

final class IntroduceEditNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          IntroduceEditNotifier,
          IntroduceEditState,
          IntroduceEditState,
          IntroduceEditState,
          ({String title, String content})
        > {
  const IntroduceEditNotifierFamily._()
    : super(
        retry: null,
        name: r'introduceEditProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IntroduceEditNotifierProvider call({
    required String title,
    required String content,
  }) => IntroduceEditNotifierProvider._(
    argument: (title: title, content: content),
    from: this,
  );

  @override
  String toString() => r'introduceEditProvider';
}

abstract class _$IntroduceEditNotifier extends $Notifier<IntroduceEditState> {
  late final _$args = ref.$arg as ({String title, String content});
  String get title => _$args.title;
  String get content => _$args.content;

  IntroduceEditState build({required String title, required String content});
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(title: _$args.title, content: _$args.content);
    final ref = this.ref as $Ref<IntroduceEditState, IntroduceEditState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<IntroduceEditState, IntroduceEditState>,
              IntroduceEditState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
