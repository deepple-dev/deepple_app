// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProfileNotifier)
const profileProvider = ProfileNotifierFamily._();

final class ProfileNotifierProvider
    extends $NotifierProvider<ProfileNotifier, ProfileState> {
  const ProfileNotifierProvider._({
    required ProfileNotifierFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'profileProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$profileNotifierHash();

  @override
  String toString() {
    return r'profileProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ProfileNotifier create() => ProfileNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProfileNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$profileNotifierHash() => r'974d0986d5ba6afd0ce8627e6e577c888278109d';

final class ProfileNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          ProfileNotifier,
          ProfileState,
          ProfileState,
          ProfileState,
          int
        > {
  const ProfileNotifierFamily._()
    : super(
        retry: null,
        name: r'profileProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProfileNotifierProvider call(int userId) =>
      ProfileNotifierProvider._(argument: userId, from: this);

  @override
  String toString() => r'profileProvider';
}

abstract class _$ProfileNotifier extends $Notifier<ProfileState> {
  late final _$args = ref.$arg as int;
  int get userId => _$args;

  ProfileState build(int userId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<ProfileState, ProfileState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ProfileState, ProfileState>,
              ProfileState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
