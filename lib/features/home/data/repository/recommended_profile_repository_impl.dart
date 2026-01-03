import 'package:deepple_app/core/network/base_repository.dart';
import 'package:deepple_app/core/util/util.dart';
import 'package:deepple_app/features/home/data/dto/introduced_profile_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recommendedProfileRepositoryProvider =
    Provider<RecommendedProfileRepository>(
      (ref) => RecommendedProfileRepository(ref),
    );

// TODO(jh): 추후 extends BaseRepository 변경
class RecommendedProfileRepositoryImpl {
  final List<Map<String, dynamic>> _mockData = [
    // 샘플 데이터 제작
    // TODO(jh): 추후 api 연동 시 제거
    {
      'memberId': 1,
      'profileImageUrl': 'assets/images/home_pic.png',
      'hobbies': ['TRAVEL', 'PERFORMANCE_AND_EXHIBITION', 'WEBTOON_AND_COMICS'],
      'mbti': 'ESTJ',
      'religion': 'NONE',
      'interviewAnswerContent':
          '안녕하세요 활발한 성격의 유쾌하고 대화 코드가 맞는 자존감 높으신 분이 좋아요...',
      'likeLevel': null,
      'isIntroduced': false,
    },
    {
      'memberId': 2,
      'profileImageUrl': 'assets/images/bad_pic1.png',
      'hobbies': [
        'DRAMA_AND_ENTERTAINMENT',
        'PC_AND_MOBILE_GAMES',
        'ANIMATION',
      ],
      'mbti': 'INFP',
      'religion': 'CHRISTIAN',
      'interviewAnswerContent':
          '안녕하세요 활발한 성격의 유쾌하고 대화 코드가 맞는 자존감 높으신 분이 좋아요...',
      'likeLevel': 'INTERESTED',
      'isIntroduced': false,
    },
    {
      'memberId': 3,
      'profileImageUrl': 'assets/images/good_pic1.png',
      'hobbies': ['SINGING', 'DRIVING', 'WALKING'],
      'mbti': 'ENTP',
      'religion': 'BUDDHIST',
      'interviewAnswerContent':
          '안녕하세요 활발한 성격의 유쾌하고 대화 코드가 맞는 자존감 높으신 분이 좋아요...',
      'likeLevel': 'HIGHLY_INTERESTED',
      'isIntroduced': false,
    },
  ];

  Future<List<IntroducedProfileDto>> getProfiles() async {
    return _mockData.map((e) => IntroducedProfileDto.fromJson(e)).toList();
  }
}

class RecommendedProfileRepository extends BaseRepository {
  RecommendedProfileRepository(Ref ref) : super(ref, '/member/introduction');

  Future<List<IntroducedProfileDto>> getProfiles() async {
    final res = await apiService.postJson('$path/today-card', data: {});

    if (res is! Map<String, dynamic> || res['data'] is! List) {
      Log.e('data type is not Map<String, dynamic> $res');
      throw Exception();
    }

    return (res['data'] as List)
        .map((e) => IntroducedProfileDto.fromJson(e))
        .toList();
  }
}
