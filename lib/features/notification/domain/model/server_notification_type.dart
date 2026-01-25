enum ServerNotificationType {
  unknown(''),
  matchRequest('MATCH_REQUEST'),
  matchAccept('MATCH_ACCEPT'),
  matchReject('MATCH_REJECT'),
  profileExchangeRequest('PROFILE_EXCHANGE_REQUEST'),
  profileExchangeAccept('PROFILE_EXCHANGE_ACCEPT'),
  profileExchangeReject('PROFILE_EXCHANGE_REJECT'),
  like('LIKE'),
  profileImageChangeRequest('PROFILE_IMAGE_CHANGE_REQUEST'),
  interviewWriteRequest('INTERVIEW_WRITE_REQUEST'),
  inappropriateInterview('INAPPROPRIATE_INTERVIEW'),
  inappropriateProfile('INAPPROPRIATE_PROFILE'),
  inappropriateProfileImage('INAPPROPRIATE_PROFILE_IMAGE'),
  inactivityReminder('INACTIVITY_REMINDER');

  const ServerNotificationType(this.key);
  final String key;

  static final Map<String, ServerNotificationType> _byValue = {
    for (final level in ServerNotificationType.validValues) level.key: level,
  };

  static List<ServerNotificationType> get validValues => values.where((type) => type != unknown).toList();

  static ServerNotificationType? tryParse(String? value) =>
      _byValue[value?.toUpperCase()];

  static ServerNotificationType parse(String? value) =>
      _byValue[value?.toUpperCase()] ?? unknown;

  bool get isConnectedProfile => [
    like,
    matchAccept,
    matchRequest,
    profileExchangeAccept,
    profileExchangeRequest,
  ].contains(this);
}
