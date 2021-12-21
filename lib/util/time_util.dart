/// ミリ秒を分に変換する
/// 
/// 分以下は四捨五入する
int toMinutes(int millSecond) {
  return (millSecond / 60000).round();
}
