import 'package:deepple_app/app/widget/view/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deepple_app/features/my/my.dart';
import 'package:deepple_app/app/constants/palette.dart';

class ProfileManagePage extends ConsumerWidget {
  final bool isRejectedProfile;

  const ProfileManagePage({super.key, required this.isRejectedProfile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myProfileAsync = ref.watch(profileManageProvider);

    // 프로필 관리 화면 영역 개수
    const profileMangeAreaCount = 2;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Palette.colorGrey50,
        appBar: const DefaultAppBar(title: '프로필 관리'),
        body: myProfileAsync.when(
          data: (data) => ListView.builder(
            itemCount: profileMangeAreaCount,
            itemBuilder: (context, index) {
              if (index == 0) {
                return ProfileManagePhotoArea(
                  profileImages: data.profile.profileImages,
                );
              } else {
                return ProfileManageInfoArea(
                  profile: data.profile,
                  isRejectedProfile: isRejectedProfile,
                );
              }
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              const Center(child: Text('프로필 관리 페이지 로딩 중 오류 발생')),
        ),
      ),
    );
  }
}
