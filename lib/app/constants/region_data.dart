/// 기본 주소 아이템 클래스
abstract class AddressItem {
  final String label;
  final String value;
  final List<AddressItem> subAddress;

  const AddressItem({
    required this.label,
    required this.value,
    this.subAddress = const [],
  });
}

/// 도시 주소 클래스
class CityAddressItem extends AddressItem {
  CityAddressItem({
    required super.label,
    required super.value,
    List<DistrictAddressItem> districts = const [],
  }) : super(subAddress: districts);

  List<DistrictAddressItem> get districts =>
      subAddress.cast<DistrictAddressItem>();
}

/// 지역구 주소 클래스
class DistrictAddressItem extends AddressItem {
  DistrictAddressItem({
    required super.label,
    required super.value,
    super.subAddress,
  });
}

/// 주소 데이터
final addressData = AddressData(
  cities: [
    CityAddressItem(
      label: '서울',
      value: 'SEOUL',
      districts: [
        DistrictAddressItem(label: '강남구', value: 'GANGNAM_GU'),
        DistrictAddressItem(label: '강동구', value: 'GANGDONG_GU'),
        DistrictAddressItem(label: '강북구', value: 'GANGBUK_GU'),
        DistrictAddressItem(label: '강서구', value: 'GANGSEO_GU'),
        DistrictAddressItem(label: '관악구', value: 'GWANAK_GU'),
        DistrictAddressItem(label: '광진구', value: 'GWANGJIN_GU'),
        DistrictAddressItem(label: '구로구', value: 'GURO_GU'),
        DistrictAddressItem(label: '금천구', value: 'GEUMCHEON_GU'),
        DistrictAddressItem(label: '노원구', value: 'NOWON_GU'),
        DistrictAddressItem(label: '도봉구', value: 'DOBONG_GU'),
        DistrictAddressItem(label: '동대문구', value: 'DONGDAEMUN_GU'),
        DistrictAddressItem(label: '동작구', value: 'DONGJAK_GU'),
        DistrictAddressItem(label: '마포구', value: 'MAPO_GU'),
        DistrictAddressItem(label: '서대문구', value: 'SEODAEMUN_GU'),
        DistrictAddressItem(label: '서초구', value: 'SEOCHO_GU'),
        DistrictAddressItem(label: '성동구', value: 'SEONGDONG_GU'),
        DistrictAddressItem(label: '성북구', value: 'SEONGBUK_GU'),
        DistrictAddressItem(label: '송파구', value: 'SONGPA_GU'),
        DistrictAddressItem(label: '양천구', value: 'YANGCHEON_GU'),
        DistrictAddressItem(label: '영등포구', value: 'YEONGDEUNGPO_GU'),
        DistrictAddressItem(label: '용산구', value: 'YONGSAN_GU'),
        DistrictAddressItem(label: '은평구', value: 'EUNPYEONG_GU'),
        DistrictAddressItem(label: '종로구', value: 'JONGNO_GU'),
        DistrictAddressItem(label: '중구', value: 'JUNG_GU'),
        DistrictAddressItem(label: '중랑구', value: 'JUNGRANG_GU'),
      ],
    ),
    CityAddressItem(
      label: '부산',
      value: 'BUSAN',
      districts: [
        DistrictAddressItem(label: '강서구', value: 'GANGSEO_GU_BUSAN'),
        DistrictAddressItem(label: '금정구', value: 'GEUMJEONG_GU'),
        DistrictAddressItem(label: '기장군', value: 'GIJANG_GUN'),
        DistrictAddressItem(label: '남구', value: 'NAM_GU_BUSAN'),
        DistrictAddressItem(label: '동구', value: 'DONG_GU_BUSAN'),
        DistrictAddressItem(label: '동래구', value: 'DONGNAE_GU'),
        DistrictAddressItem(label: '부산진구', value: 'BUSANJIN_GU'),
        DistrictAddressItem(label: '북구', value: 'BUK_GU_BUSAN'),
        DistrictAddressItem(label: '사상구', value: 'SASANG_GU'),
        DistrictAddressItem(label: '사하구', value: 'SAHA_GU'),
        DistrictAddressItem(label: '서구', value: 'SEO_GU_BUSAN'),
        DistrictAddressItem(label: '수영구', value: 'SUYEONG_GU'),
        DistrictAddressItem(label: '연제구', value: 'YEONJE_GU'),
        DistrictAddressItem(label: '영도구', value: 'YEONGDO_GU'),
        DistrictAddressItem(label: '중구', value: 'JUNG_GU_BUSAN'),
        DistrictAddressItem(label: '해운대구', value: 'HAEUNDAE_GU'),
      ],
    ),
    CityAddressItem(
      label: '인천',
      value: 'INCHEON',
      districts: [
        DistrictAddressItem(label: '강화군', value: 'GANGHWA_GUN'),
        DistrictAddressItem(label: '계양구', value: 'GYEYANG_GU'),
        DistrictAddressItem(label: '남동구', value: 'NAMDONG_GU'),
        DistrictAddressItem(label: '동구', value: 'DONG_GU_INCHEON'),
        DistrictAddressItem(label: '미추홀구', value: 'MICHUHOL_GU'),
        DistrictAddressItem(label: '부평구', value: 'BUPYEONG_GU'),
        DistrictAddressItem(label: '서구', value: 'SEO_GU_INCHEON'),
        DistrictAddressItem(label: '연수구', value: 'YEONSU_GU'),
        DistrictAddressItem(label: '옹진군', value: 'ONGJIN_GUN'),
        DistrictAddressItem(label: '중구', value: 'JUNG_GU_INCHEON'),
      ],
    ),
    CityAddressItem(
      label: '대전',
      value: 'DAEJEON',
      districts: [
        DistrictAddressItem(label: '대덕구', value: 'DAEDEOK_GU'),
        DistrictAddressItem(label: '동구', value: 'DONG_GU_DAEJEON'),
        DistrictAddressItem(label: '서구', value: 'SEO_GU_DAEJEON'),
        DistrictAddressItem(label: '유성구', value: 'YUSEONG_GU'),
        DistrictAddressItem(label: '중구', value: 'JUNG_GU_DAEJEON'),
      ],
    ),
    CityAddressItem(
      label: '대구',
      value: 'DAEGU',
      districts: [
        DistrictAddressItem(label: '남구', value: 'NAM_GU_DAEGU'),
        DistrictAddressItem(label: '달서구', value: 'DALSEO_GU'),
        DistrictAddressItem(label: '달성군', value: 'DALSEONG_GUN'),
        DistrictAddressItem(label: '동구', value: 'DONG_GU_DAEGU'),
        DistrictAddressItem(label: '북구', value: 'BUK_GU_DAEGU'),
        DistrictAddressItem(label: '서구', value: 'SEO_GU_DAEGU'),
        DistrictAddressItem(label: '수성구', value: 'SUSEONG_GU'),
        DistrictAddressItem(label: '중구', value: 'JUNG_GU_DAEGU'),
      ],
    ),
    CityAddressItem(
      label: '광주',
      value: 'GWANGJU',
      districts: [
        DistrictAddressItem(label: '광산구', value: 'GWANGSAN_GU'),
        DistrictAddressItem(label: '남구', value: 'NAM_GU_GWANGJU'),
        DistrictAddressItem(label: '동구', value: 'DONG_GU_GWANGJU'),
        DistrictAddressItem(label: '북구', value: 'BUK_GU_GWANGJU'),
        DistrictAddressItem(label: '서구', value: 'SEO_GU_GWANGJU'),
      ],
    ),
    CityAddressItem(
      label: '울산',
      value: 'ULSAN',
      districts: [
        DistrictAddressItem(label: '남구', value: 'NAM_GU_ULSAN'),
        DistrictAddressItem(label: '동구', value: 'DONG_GU_ULSAN'),
        DistrictAddressItem(label: '북구', value: 'BUK_GU_ULSAN'),
        DistrictAddressItem(label: '울주군', value: 'ULJU_GUN'),
        DistrictAddressItem(label: '중구', value: 'JUNG_GU_ULSAN'),
      ],
    ),
    CityAddressItem(label: '세종', value: 'SEJONG'),
    CityAddressItem(
      label: '강원도',
      value: 'GANGWON',
      districts: [
        DistrictAddressItem(label: '강릉시', value: 'GANGNEUNG_SI'),
        DistrictAddressItem(label: '고성군', value: 'GOSEONG_GUN_GANGWON'),
        DistrictAddressItem(label: '동해시', value: 'DONGHAE_SI'),
        DistrictAddressItem(label: '삼척시', value: 'SAMCHEOK_SI'),
        DistrictAddressItem(label: '속초시', value: 'SOKCHO_SI'),
        DistrictAddressItem(label: '양구군', value: 'YANGGU_GUN'),
        DistrictAddressItem(label: '양양군', value: 'YANGYANG_GUN'),
        DistrictAddressItem(label: '영월군', value: 'YEONGWOL_GUN'),
        DistrictAddressItem(label: '원주시', value: 'WONJU_SI'),
        DistrictAddressItem(label: '인제군', value: 'INJE_GUN'),
        DistrictAddressItem(label: '정선군', value: 'JEONGSEON_GUN'),
        DistrictAddressItem(label: '철원군', value: 'CHEORWON_GUN'),
        DistrictAddressItem(label: '춘천시', value: 'CHUNCHEON_SI'),
        DistrictAddressItem(label: '평창군', value: 'PYEONGCHANG_GUN'),
        DistrictAddressItem(label: '홍천군', value: 'HONGCHEON_GUN'),
        DistrictAddressItem(label: '화천군', value: 'HWACHEON_GUN'),
        DistrictAddressItem(label: '횡성군', value: 'HWANGSEONG_GUN'),
      ],
    ),
    CityAddressItem(
      label: '경기도',
      value: 'KYEONGGI',
      districts: [
        DistrictAddressItem(label: '가평군', value: 'GAPYEONG_GUN'),
        DistrictAddressItem(label: '고양시', value: 'GOYANG_SI'),
        DistrictAddressItem(label: '과천시', value: 'GWACHEON_SI'),
        DistrictAddressItem(label: '광명시', value: 'GWANGMYEONG_SI'),
        DistrictAddressItem(label: '광주시', value: 'GWANGJU_SI'),
        DistrictAddressItem(label: '구리시', value: 'GURI_SI'),
        DistrictAddressItem(label: '군포시', value: 'GUNPO_SI'),
        DistrictAddressItem(label: '김포시', value: 'GIMPO_SI'),
        DistrictAddressItem(label: '남양주시', value: 'NAMYANGJU_SI'),
        DistrictAddressItem(label: '동두천시', value: 'DONGDUCHEON_SI'),
        DistrictAddressItem(label: '부천시', value: 'BUCHEON_SI'),
        DistrictAddressItem(label: '성남시', value: 'SEONGNAM_SI'),
        DistrictAddressItem(label: '수원시', value: 'SUWON_SI'),
        DistrictAddressItem(label: '시흥시', value: 'SIHEUNG_SI'),
        DistrictAddressItem(label: '안산시', value: 'ANSAN_SI'),
        DistrictAddressItem(label: '안성시', value: 'ANSEONG_SI'),
        DistrictAddressItem(label: '안양시', value: 'ANYANG_SI'),
        DistrictAddressItem(label: '양주시', value: 'YANGJU_SI'),
        DistrictAddressItem(label: '양평군', value: 'YANGPYEONG_GUN'),
        DistrictAddressItem(label: '여주시', value: 'YEOJU_SI'),
        DistrictAddressItem(label: '연천군', value: 'YEONCHEON_GUN'),
        DistrictAddressItem(label: '오산시', value: 'OSAN_SI'),
        DistrictAddressItem(label: '용인시', value: 'YONGIN_SI'),
        DistrictAddressItem(label: '의왕시', value: 'UIWANG_SI'),
        DistrictAddressItem(label: '의정부시', value: 'UIJUNGBU_SI'),
        DistrictAddressItem(label: '이천시', value: 'ICHEON_SI'),
        DistrictAddressItem(label: '파주시', value: 'PAJU_SI'),
        DistrictAddressItem(label: '평택시', value: 'PYEONGTAEK_SI'),
        DistrictAddressItem(label: '포천시', value: 'POCHON_SI'),
        DistrictAddressItem(label: '하남시', value: 'HANAM_SI'),
        DistrictAddressItem(label: '화성시', value: 'HWASEONG_SI'),
      ],
    ),
    CityAddressItem(
      label: '경상남도',
      value: 'GYEONGSANGNAM',
      districts: [
        DistrictAddressItem(label: '거제시', value: 'GEOJE_SI'),
        DistrictAddressItem(label: '거창군', value: 'GEOCHANG_GUN'),
        DistrictAddressItem(label: '고성군', value: 'GOSEONG_GUN_GYEONGSANGNAM'),
        DistrictAddressItem(label: '김해시', value: 'GIMHAE_SI'),
        DistrictAddressItem(label: '남해군', value: 'NAMHAE_GUN'),
        DistrictAddressItem(label: '밀양시', value: 'MIRYANG_SI'),
        DistrictAddressItem(label: '사천시', value: 'SACHEON_SI'),
        DistrictAddressItem(label: '산청군', value: 'SANCHEONG_GUN'),
        DistrictAddressItem(label: '양산시', value: 'YANGSAN_SI'),
        DistrictAddressItem(label: '의령군', value: 'UIRYEONG_GUN'),
        DistrictAddressItem(label: '진주시', value: 'JINJU_SI'),
        DistrictAddressItem(label: '창녕군', value: 'CHANGNYEONG_GUN'),
        DistrictAddressItem(label: '창원시', value: 'CHANGWON_SI'),
        DistrictAddressItem(label: '통영시', value: 'TONGYEONG_SI'),
        DistrictAddressItem(label: '하동군', value: 'HADONG_GUN'),
        DistrictAddressItem(label: '함안군', value: 'HAMAN_GUN'),
        DistrictAddressItem(label: '함양군', value: 'HAMYANG_GUN'),
        DistrictAddressItem(label: '합천군', value: 'HAPCHEON_GUN'),
      ],
    ),
    CityAddressItem(
      label: '경상북도',
      value: 'GYEONGSANGBUK',
      districts: [
        DistrictAddressItem(label: '경산시', value: 'GYEONGSAN_SI'),
        DistrictAddressItem(label: '경주시', value: 'GYEONGJU_SI'),
        DistrictAddressItem(label: '고령군', value: 'GORYEONG_GUN'),
        DistrictAddressItem(label: '구미시', value: 'GUMI_SI'),
        DistrictAddressItem(label: '김천시', value: 'GIMCHEON_SI'),
        DistrictAddressItem(label: '문경시', value: 'MUNGYEONG_SI'),
        DistrictAddressItem(label: '봉화군', value: 'BONGHWA_GUN'),
        DistrictAddressItem(label: '상주시', value: 'SANGJU_SI'),
        DistrictAddressItem(label: '성주군', value: 'SEONGJU_GUN'),
        DistrictAddressItem(label: '안동시', value: 'ANDONG_SI'),
        DistrictAddressItem(label: '영덕군', value: 'YEONGDEOK_GUN'),
        DistrictAddressItem(label: '영양군', value: 'YEONGYANG_GUN'),
        DistrictAddressItem(label: '영주시', value: 'YEONGJU_SI'),
        DistrictAddressItem(label: '영천시', value: 'YEONGCHEON_SI'),
        DistrictAddressItem(label: '예천군', value: 'YECHEON_GUN'),
        DistrictAddressItem(label: '울진군', value: 'ULJIN_GUN'),
        DistrictAddressItem(label: '의성군', value: 'UISEONG_GUN'),
        DistrictAddressItem(label: '청도군', value: 'CHEONGDO_GUN'),
        DistrictAddressItem(label: '청송군', value: 'CHEONGSONG_GUN'),
        DistrictAddressItem(label: '칠곡군', value: 'CHILGOK_GUN'),
      ],
    ),
    CityAddressItem(
      label: '전라남도',
      value: 'JEOLLANAM',
      districts: [
        DistrictAddressItem(label: '강진군', value: 'GANGJIN_GUN'),
        DistrictAddressItem(label: '고흥군', value: 'GOHEUNG_GUN'),
        DistrictAddressItem(label: '곡성군', value: 'GOKSEONG_GUN'),
        DistrictAddressItem(label: '광양시', value: 'GWANGYANG_SI'),
        DistrictAddressItem(label: '구례군', value: 'GURYE_GUN'),
        DistrictAddressItem(label: '나주시', value: 'NAJU_SI'),
        DistrictAddressItem(label: '담양군', value: 'DAMYANG_GUN'),
        DistrictAddressItem(label: '목포시', value: 'MOKPO_SI'),
        DistrictAddressItem(label: '무안군', value: 'MUAN_GUN'),
        DistrictAddressItem(label: '보성군', value: 'BOSEONG_GUN'),
        DistrictAddressItem(label: '순천시', value: 'SUNCHEON_SI'),
        DistrictAddressItem(label: '신안군', value: 'SINAN_GUN'),
        DistrictAddressItem(label: '여수시', value: 'YEOSU_SI'),
        DistrictAddressItem(label: '영광군', value: 'YEONGGWANG_GUN'),
        DistrictAddressItem(label: '영암군', value: 'YEONGAM_GUN'),
        DistrictAddressItem(label: '완도군', value: 'WANDO_GUN'),
        DistrictAddressItem(label: '장성군', value: 'JANGSEONG_GUN'),
        DistrictAddressItem(label: '장흥군', value: 'JANGHEUNG_GUN'),
        DistrictAddressItem(label: '진도군', value: 'JINDO_GUN'),
        DistrictAddressItem(label: '함평군', value: 'HAMPYEONG_GUN'),
      ],
    ),
    CityAddressItem(
      label: '전라북도',
      value: 'JEOLLABUK',
      districts: [
        DistrictAddressItem(label: '고창군', value: 'GOCHANG_GUN'),
        DistrictAddressItem(label: '군산시', value: 'GUNSAN_SI'),
        DistrictAddressItem(label: '김제시', value: 'GIMJE_SI'),
        DistrictAddressItem(label: '남원시', value: 'NAMWON_SI'),
        DistrictAddressItem(label: '무주군', value: 'MUJU_GUN'),
        DistrictAddressItem(label: '부안군', value: 'BUAN_GUN'),
        DistrictAddressItem(label: '순창군', value: 'SUNCHANG_GUN'),
        DistrictAddressItem(label: '완주군', value: 'WANJU_GUN'),
        DistrictAddressItem(label: '익산시', value: 'IKSAN_SI'),
        DistrictAddressItem(label: '전주시', value: 'JEONJU_SI'),
        DistrictAddressItem(label: '정읍시', value: 'JEONGEUP_SI'),
      ],
    ),
    CityAddressItem(
      label: '충청남도',
      value: 'CHUNGCHEONGNAM',
      districts: [
        DistrictAddressItem(label: '공주시', value: 'GONGJU_SI'),
        DistrictAddressItem(label: '논산시', value: 'NONSAN_SI'),
        DistrictAddressItem(label: '당진시', value: 'DANGJIN_SI'),
        DistrictAddressItem(label: '보령시', value: 'BOREUNG_SI'),
        DistrictAddressItem(label: '서산시', value: 'SEOSAN_SI'),
        DistrictAddressItem(label: '아산시', value: 'ASAN_SI'),
        DistrictAddressItem(label: '예산군', value: 'YESAN_GUN'),
        DistrictAddressItem(label: '천안시', value: 'CHEONAN_SI'),
        DistrictAddressItem(label: '청양군', value: 'CHEONGYANG_GUN'),
        DistrictAddressItem(label: '태안군', value: 'TAEAN_GUN'),
        DistrictAddressItem(label: '홍성군', value: 'HONGSEONG_GUN'),
      ],
    ),
    CityAddressItem(
      label: '충청북도',
      value: 'CHUNGCHEONGBUK',
      districts: [
        DistrictAddressItem(label: '괴산군', value: 'GOESAN_GUN'),
        DistrictAddressItem(label: '단양군', value: 'DANYANG_GUN'),
        DistrictAddressItem(label: '보은군', value: 'BOEUN_GUN'),
        DistrictAddressItem(label: '영동군', value: 'YEONGDONG_GUN'),
        DistrictAddressItem(label: '옥천군', value: 'OKCHEON_GUN'),
        DistrictAddressItem(label: '음성군', value: 'EUMSEONG_GUN'),
        DistrictAddressItem(label: '제천시', value: 'JECHON_SI'),
        DistrictAddressItem(label: '증평군', value: 'JEUNGPYEONG_GUN'),
        DistrictAddressItem(label: '진천군', value: 'JINCHEON_GUN'),
        DistrictAddressItem(label: '청주시', value: 'CHEONGJU_SI'),
      ],
    ),
    CityAddressItem(
      label: '제주',
      value: 'JEJU',
      districts: [
        DistrictAddressItem(label: '서귀포시', value: 'SEOGWIPO_SI'),
        DistrictAddressItem(label: '제주시', value: 'JEJU_SI'),
      ],
    ),
  ],
);

/// AddressData 클래스 정의
class AddressData {
  final List<CityAddressItem> cities;

  // 서버 데이터를 이용하여 도시를 조회하는 맵
  final Map<String, CityAddressItem> _cityByValue;

  // 지역명을 이용하여 도시를 조회하는 맵
  final Map<String, CityAddressItem> _cityByLabel;

  // 서버 데이터를 이용하여 district를 조회하는 맵
  final Map<String, Map<String, DistrictAddressItem>> _districtByValue;

  // 지역명을 이용하여 district를 조회하는 맵
  final Map<String, Map<String, DistrictAddressItem>> _districtByLabel;

  AddressData({required this.cities})
    : _cityByValue = {for (final city in cities) city.value: city},
      _cityByLabel = {for (final city in cities) city.label: city},
      _districtByValue = {
        for (final city in cities)
          city.label: {
            for (final district in city.districts) district.value: district,
          },
      },
      _districtByLabel = {
        for (final city in cities)
          city.label: {
            for (final district in city.districts) district.label: district,
          },
      };

  /// 서버 데이터를 화면 표시용 문자열로 변환
  String getLocationString(String cityValue, String? districtValue) {
    final city = _cityByValue[cityValue];

    // 세종특별자치시와 같이 district가 없는 경우
    if (districtValue == null || city!.districts.isEmpty) {
      return city!.label;
    }

    final district = _districtByValue[city.label]![districtValue];

    return '${city.label} ${district?.label}';
  }

  /// 서버 데이터를 CityAddressItem으로 반환
  CityAddressItem getCityByValue(String value) {
    return _cityByValue[value] ?? CityAddressItem(label: '', value: value);
  }

  CityAddressItem getCityByLabel(String label) {
    return _cityByLabel[label]!;
  }

  /// 화면 표시용 문자열을 서버 데이터로 변환 (district value만 반환)
  String? getDistrictValue(String locationString) {
    if (locationString.isEmpty) return null;

    final parts = locationString.split(' ');
    if (parts.isEmpty) return null;

    // 도시 찾기
    final city = _cityByLabel[parts.first];
    if (city == null) return null;

    // district가 없는 도시(예: 세종특별자치시)의 경우 null 반환
    if (city.districts.isEmpty) {
      return city.value;
    }

    if (_districtByLabel[city.label] == null) return null;

    // parts가 2개 미만인 경우 null 반환 (구/군 정보 없음)
    if (parts.length < 2) return null;

    // 구/군 찾기
    final district = _districtByLabel[city.label]![parts[1]];
    if (district == null) return null;

    return district.value;
  }

  /// 검색어로 지역 검색하기
  List<String> searchLocations(String keyword) {
    if (keyword.isEmpty) return [];

    List<String> results = [];
    final parts = keyword.split(' ');

    // 도시 이름으로 검색
    _cityByLabel.forEach((cityLabel, city) {
      if (cityLabel.contains(parts.first)) {
        // district가 없는 도시는 도시 이름만 추가
        if (city.districts.isEmpty) {
          results.add(cityLabel);
          return;
        }

        // 해당 도시의 모든 district 추가
        final districts = _districtByLabel[cityLabel]!;
        if (parts.length == 1) {
          results.addAll(
            districts.values.map((district) => '$cityLabel ${district.label}'),
          );
        } else {
          // district 이름으로 검색
          final filteredDistricts = districts.entries.where(
            (entry) => entry.value.label.contains(parts.sublist(1).join(' ')),
          );
          results.addAll(
            filteredDistricts.map((entry) => '$cityLabel ${entry.value.label}'),
          );
        }
        return;
      }
    });

    // district 이름으로 직접 검색
    if (results.isEmpty) {
      _districtByLabel.forEach((cityLabel, districts) {
        districts.forEach((districtLabel, district) {
          if (districtLabel.contains(keyword)) {
            results.add('$cityLabel $districtLabel');
          }
        });
      });
    }

    return results;
  }
}
