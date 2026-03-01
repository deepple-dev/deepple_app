enum TokenUnauthorizedCode {
  missingAccessToken('401001'),
  invalidAccessToken('401002'),
  expiredAccessToken('401006'),
  missingRefreshToken('401003'),
  invalidRefreshToken('401004'),
  expiredRefreshToken('401005');

  final String code;
  const TokenUnauthorizedCode(this.code);

  static final Set<String> _codes = TokenUnauthorizedCode.values
      .map((e) => e.code)
      .toSet();

  static bool contains(String code) => _codes.contains(code);

  static bool isExpiredAccessToken(String code) =>
      code == TokenUnauthorizedCode.expiredAccessToken.code;

  static bool shouldLogout(String code) =>
      contains(code) && !isExpiredAccessToken(code);
}
