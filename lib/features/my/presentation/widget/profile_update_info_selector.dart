import 'package:deepple_app/app/constants/region_data.dart';
import 'package:deepple_app/core/util/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:deepple_app/features/profile/domain/common/enum.dart';
import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/constants/temp.dart';
import 'package:deepple_app/app/widget/list/single_select_list_chip.dart';
import 'package:deepple_app/core/extension/extension.dart';
import 'package:deepple_app/features/my/my.dart';

class ProfileUpdateInfoSelector extends ConsumerStatefulWidget {
  final String profileType;
  final MyProfile profile;
  final void Function(MyProfile, bool) onProfileUpdated;

  const ProfileUpdateInfoSelector({
    super.key,
    required this.profileType,
    required this.profile,
    required this.onProfileUpdated,
  });

  @override
  ConsumerState<ProfileUpdateInfoSelector> createState() =>
      _ProfileUpdateInfoSelectorState();
}

class _ProfileUpdateInfoSelectorState
    extends ConsumerState<ProfileUpdateInfoSelector> {
  late ValueNotifier<MyProfile> _tempProfile;

  @override
  void initState() {
    super.initState();
    _tempProfile = ValueNotifier<MyProfile>(widget.profile);
  }

  @override
  void dispose() {
    _tempProfile.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Widget> infoValues = {
      '직업': _SingleButtonTypeSelector(
        options: jobOptions,
        initialValue: widget.profile.job.label,
        onSelected: (value) {
          _tempProfile.value = _tempProfile.value.copyWith(
            job: Job.fromLabel(value),
          );
          Log.d(_tempProfile);
          widget.onProfileUpdated(
            _tempProfile.value,
            value != widget.profile.job.label,
          );
        },
      ),
      '지역': _LocationInputWidget(initialValue: widget.profile.region),
      '학력': _SingleButtonTypeSelector(
        options: Education.values.map((e) => e.label).toList(),
        initialValue: widget.profile.education.label,
        onSelected: (value) {
          final education = Education.values.firstWhere(
            (e) => e.label == value,
          );
          _tempProfile.value = _tempProfile.value.copyWith(
            education: education,
          );
          widget.onProfileUpdated(
            _tempProfile.value,
            education != widget.profile.education,
          );
        },
      ),
      '흡연여부': _SingleButtonTypeSelector(
        options: SmokingStatus.values.map((e) => e.label).toList(),
        initialValue: widget.profile.smokingStatus.label,
        onSelected: (value) {
          final newStatus = SmokingStatus.values.firstWhere(
            (e) => e.label == value,
            orElse: () => SmokingStatus.none,
          );
          final isChanged = newStatus != widget.profile.smokingStatus;
          _tempProfile.value = _tempProfile.value.copyWith(
            smokingStatus: newStatus,
          );
          widget.onProfileUpdated(_tempProfile.value, isChanged);
        },
      ),
      '음주빈도': _SingleButtonTypeSelector(
        options: DrinkingStatus.values.map((e) => e.label).toList(),
        initialValue: widget.profile.drinkingStatus.label,
        onSelected: (value) {
          final newStatus = DrinkingStatus.values.firstWhere(
            (e) => e.label == value,
            orElse: () => DrinkingStatus.none,
          );
          _tempProfile.value = _tempProfile.value.copyWith(
            drinkingStatus: newStatus,
          );
          widget.onProfileUpdated(
            _tempProfile.value,
            newStatus != widget.profile.drinkingStatus,
          );
        },
      ),
      '종교': _SingleButtonTypeSelector(
        options: Religion.values.map((e) => e.label).toList(),
        initialValue: widget.profile.religion.label,
        onSelected: (value) {
          final newReligion = Religion.values.firstWhere(
            (e) => e.label == value,
            orElse: () => Religion.none,
          );
          _tempProfile.value = _tempProfile.value.copyWith(
            religion: newReligion,
          );
          widget.onProfileUpdated(
            _tempProfile.value,
            newReligion != widget.profile.religion,
          );
        },
      ),
      'MBTI': _GroupTypeSelector(
        initialValues: widget.profile.mbti.split(''),
        onSelected: (value) {
          _tempProfile.value = _tempProfile.value.copyWith(mbti: value.join());
          widget.onProfileUpdated(
            _tempProfile.value,
            value.join() != widget.profile.mbti,
          );
        },
      ),
      '취미': _MultiBtnTypeSelector(
        options: hobbies,
        initialValues: widget.profile.hobbies.map((e) => e.label).toList(),
        onSelected: (value, isChanged) {
          _tempProfile.value = _tempProfile.value.copyWith(
            hobbies: value.map((e) => Hobby.fromLabel(e)).toList(),
          );
          widget.onProfileUpdated(
            _tempProfile.value,
            isChanged && value.isNotEmpty,
          );
        },
      ),
      '닉네임': _InputTypeSelector(
        initialValue: widget.profile.nickname,
        onSubmitted: (value) {
          _tempProfile.value = _tempProfile.value.copyWith(nickname: value);
          widget.onProfileUpdated(
            _tempProfile.value,
            value != widget.profile.nickname,
          );
        },
      ),
    };
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              _getTitleByType(widget.profileType),
              style: Fonts.header03().copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const Gap(24),
        infoValues[widget.profileType]!,
      ],
    );
  }
}

String _getTitleByType(String type) {
  switch (type) {
    case '직업':
      return '직업이 어떻게 되세요?';
    case '지역':
      return '지역이 어떻게 되세요?';
    case '학력':
      return '학력이 어떻게 되세요?';
    case '흡연여부':
      return '흡연 여부가 어떻게 되세요?';
    case '음주빈도':
      return '음주 빈도가 어떻게 되세요?';
    case '종교':
      return '종교가 어떻게 되세요?';
    case 'MBTI':
      return 'MBTI가 어떻게 되세요?';
    case '취미':
      return '취미가 어떻게 되세요?';
    case '닉네임':
      return '닉네임이 어떻게 되세요?';
    default:
      return '';
  }
}

class _SingleButtonTypeSelector extends StatefulWidget {
  const _SingleButtonTypeSelector({
    required this.options,
    required this.initialValue,
    required this.onSelected,
  });

  final List<String> options;
  final String initialValue;
  final void Function(String) onSelected;

  @override
  State<_SingleButtonTypeSelector> createState() =>
      _SingleButtonTypeSelectorState();
}

class _SingleButtonTypeSelectorState extends State<_SingleButtonTypeSelector> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    final idx = widget.options.indexOf(widget.initialValue);
    _selectedIndex = idx >= 0 ? idx : 0;
  }

  @override
  Widget build(BuildContext context) {
    return SingleSelectListChip(
      options: widget.options,
      selectedOption: widget.options[_selectedIndex],
      onSelectionChanged: (value) {
        Log.d('Selected value: $value');
        if (value != null) {
          setState(() {
            _selectedIndex = widget.options.indexOf(value); // 선택된 인덱스 업데이트
          });
          widget.onSelected(value);
        }
      },
    );
  }
}

class _MultiBtnTypeSelector extends StatefulWidget {
  const _MultiBtnTypeSelector({
    required this.options,
    required this.initialValues,
    required this.onSelected,
  });

  final List<String> options;
  final List<String> initialValues;
  final void Function(List<String>, bool) onSelected;

  @override
  State<_MultiBtnTypeSelector> createState() => _MultiBtnTypeSelectorState();
}

class _MultiBtnTypeSelectorState extends State<_MultiBtnTypeSelector> {
  late List<String> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = List.from(widget.initialValues);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.0, // 가로 간격
          runSpacing: 8.0, // 세로 간격
          children: widget.options.map((tag) {
            bool isSelected = _selectedItems.contains(tag);

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _toggleItem(tag);
                // Set으로 변환하여 내용 비교
                final currentSet = Set.from(_selectedItems); // 현재 선택된 아이템들 Set
                final initialSet = Set.from(
                  widget.initialValues,
                ); // 초기 선택한 아이템들 Set
                final isChanged =
                    !currentSet.containsAll(initialSet) ||
                    !initialSet.containsAll(currentSet); // 변경 여부 체크
                widget.onSelected(_selectedItems.toList(), isChanged);
              },
              child: Container(
                //margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Palette.colorPrimary100 : Colors.white,
                  border: Border.all(color: const Color(0xffEDEEF0)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: isSelected
                        ? Palette.colorPrimary600
                        : Palette.colorGrey800,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _toggleItem(String item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        // 이미 선택된 아이템이면 제거
        _selectedItems.remove(item);
      } else {
        // 선택되지 않은 아이템이고 최대 선택 개수를 초과하지 않으면 추가
        if (_selectedItems.length < 3) {
          _selectedItems.add(item);
        }
      }
    });
  }
}

class _InputTypeSelector extends StatelessWidget {
  const _InputTypeSelector({
    required this.initialValue,
    required this.onSubmitted,
  });

  final String initialValue;
  final void Function(String) onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: (value) {
        onSubmitted(value);
      },
      decoration: InputDecoration(
        hintText: initialValue,
        hintStyle: Fonts.body02Medium().copyWith(
          fontWeight: FontWeight.w400,
          color: const Color(0xff8D92A0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xffEDEEF0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Palette.colorBlack),
        ),
      ),
    );
  }
}

class _GroupTypeSelector extends StatefulWidget {
  const _GroupTypeSelector({
    required this.initialValues,
    required this.onSelected,
  });

  final List<String> initialValues;
  final void Function(List<String>) onSelected;

  @override
  State<_GroupTypeSelector> createState() => _GroupTypeSelectorState();
}

class _GroupTypeSelectorState extends State<_GroupTypeSelector> {
  final List<String> _mbtiLetters = ['E', 'N', 'F', 'P', 'I', 'S', 'T', 'J'];
  List<String> _selectedMbti = [];

  @override
  void initState() {
    _selectedMbti = widget.initialValues;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: _mbtiLetters.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => setState(() {
            int letterPlace = index < 4 ? index : index - 4;
            _selectedMbti[letterPlace] = _mbtiLetters[index];
            widget.onSelected(_selectedMbti);
          }),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: _selectedMbti.contains(_mbtiLetters[index])
                    ? Palette.colorPrimary100
                    : Palette.colorGrey200,
              ),
              color: _selectedMbti.contains(_mbtiLetters[index])
                  ? Palette.colorPrimary100
                  : context.palette.surface,
              borderRadius: BorderRadius.circular(8.0),
            ),
            width: double.infinity, // 카드의 가로 길이를 GridView에 맞춤
            child: Text(
              _mbtiLetters[index],
              style: Fonts.title(
                _selectedMbti.contains(_mbtiLetters[index])
                    ? context.palette.primary
                    : Palette.colorGrey200,
              ).copyWith(fontWeight: FontWeight.bold, fontSize: 30.sp),
            ),
          ),
        );
      },
    );
  }
}

class _LocationInputWidget extends ConsumerStatefulWidget {
  final String initialValue;

  const _LocationInputWidget({required this.initialValue});

  @override
  ConsumerState<_LocationInputWidget> createState() =>
      _LocationInputWidgetState();
}

class _LocationInputWidgetState extends ConsumerState<_LocationInputWidget> {
  late final TextEditingController _controller;
  late final ScrollController _scrollController;

  List<String> _filteredLocations = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);

    _scrollController = ScrollController();

    // 스크롤 시 키보드 내리기
    _scrollController.addListener(() {
      if (_scrollController.position.isScrollingNotifier.value) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.read(profileManageProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          onChanged: (value) {
            setState(() {
              _filteredLocations = addressData.searchLocations(value);
            });
            provider.updateLocation(value);
          },
          decoration: InputDecoration(
            hintText: '지역을 입력하세요',
            hintStyle: Fonts.body02Medium().copyWith(
              fontWeight: FontWeight.w400,
              color: const Color(0xff8D92A0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xffEDEEF0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Palette.colorBlack),
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (_controller.text.isEmpty)
          GestureDetector(
            onTap: () async =>
                _controller.text = await provider.setCurrentLocation(),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffDCDEE3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '현재 위치로 설정하기',
                  style: Fonts.body02Medium(Palette.colorBlack),
                ),
              ),
            ),
          ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: context.screenHeight * 0.4, // 스크롤 가능한 최대 높이 설정
          ),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _filteredLocations.map((location) {
                return GestureDetector(
                  onTap: () {
                    _controller.text = location;
                    provider.updateLocation(location); // 선택한 지역으로 설정
                    _filteredLocations.clear(); // 검색 후 결과 초기화
                    FocusScope.of(context).unfocus(); // 키보드 내리기
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Palette.colorGrey50,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Text(
                      location,
                      style: Fonts.body02Medium(Palette.colorGrey800),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
