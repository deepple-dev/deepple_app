enum TokenUnauthorizedCode {
  missingAccessToken('401001'),
  invalidAccessToken('401002'),
  missingRefreshToken('401003'),
  invalidRefreshToken('401004'),
  expiredRefreshToken('401005');

  final String code;
  const TokenUnauthorizedCode(this.code);

  static final Set<String> _codes = TokenUnauthorizedCode.values
      .map((e) => e.code)
      .toSet();

  static bool contains(String code) => _codes.contains(code);
}
