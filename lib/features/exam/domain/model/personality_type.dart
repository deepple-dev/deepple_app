enum PersonalityType {
  decisiveIndependent('DECISIVE_INDEPENDENT'),
  growingRunningMate('GROWING_RUNNING_MATE'),
  devotedRomantic('DEVOTED_ROMANTIC'),
  realisticShelter('REALISTIC_SHELTER');

  final String label;
  const PersonalityType(this.label);
}

class PersonalityContent {
  final String title;
  final List<String> tags;
  final int tagColor;
  final String imageUrl;
  final int imageBgColor;
  final int cardBgColor;
  final String description;

  const PersonalityContent({
    required this.title,
    required this.tags,
    required this.tagColor,
    required this.description,
    required this.cardBgColor,
    required this.imageUrl,
    required this.imageBgColor,
  });
}

extension PersonalityTypeExtension on PersonalityType {
  PersonalityContent get content {
    switch (this) {
      case PersonalityType.decisiveIndependent:
        return const PersonalityContent(
          title: '단호한 독립주의자',
          tags: ['# 가치관 고수', '# 자아존중'],
          tagColor: 0xFF1DFF7E,
          description: '자신만의 기준이 명확하며, 서로의 영역을 \n존중받길 원하는 타입',
          imageUrl: 'assets/images/exam_card1.png',
          imageBgColor: 0xFF1E2624,
          cardBgColor: 0xFF1E2624,
        );
      case PersonalityType.growingRunningMate:
        return const PersonalityContent(
          title: '성장하는 러닝메이트',
          tags: ['# 자기계발', '# 성장가능성'],
          tagColor: 0xFF05C0FF,
          description: '연애와 커리어를 동시에 중시하며, \n서로 긍정적인 자극을 주는 관계를 선호하는 타입',
          imageUrl: 'assets/images/exam_card2.png',
          imageBgColor: 0xFF1A2F40,
          cardBgColor: 0xFF181D23,
        );
      case PersonalityType.devotedRomantic:
        return const PersonalityContent(
          title: '헌신적인 로맨티스트',
          tags: ['# 일편단심', '# 해바라기'],
          tagColor: 0xFFFB0000,
          description: '상대방에게 모든 걸 맞추어주며, \n정서적 교감과 깊은 이해를 최고의 가치로 치는 타입',
          imageUrl: 'assets/images/exam_card3.png',
          imageBgColor: 0xFFFF79A4,
          cardBgColor: 0xFF891B3A,
        );
      case PersonalityType.realisticShelter:
        return const PersonalityContent(
          title: '현실적인 안식처',
          tags: ['# 안정감', '# 물질적 행복'],
          tagColor: 0xFFFFFB00,
          description: '연애에서 감정적 소모보다 \n안정적인 환경과 현실적인 조건을 중시하는 타입',
          imageUrl: 'assets/images/exam_card4.png',
          imageBgColor: 0xFFE8D8B8,
          cardBgColor: 0xFF9B7424,
        );
    }
    ;
  }
}
