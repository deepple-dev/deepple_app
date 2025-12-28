enum WithdrawReason {
  other('다른 인연이 생겼어요'),
  noInterest('마음에 드는 이상형이 없어요'),
  tooExpensive('과금 유도가 너무 심한거 같아요'),
  tooBusy('서비스 이용이 너무 불편해요'),
  noMessage('상대에게 호감이나 메시지가 안와요'),
  noReason('이유없음');

  const WithdrawReason(this.value);

  final String value;
}
