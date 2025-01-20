// 주어진 시간을 초 단위로 받아 HH:mm:ss 형식의 문자열로 변환합니다.
//
// 이 함수는 총 초 수를 나타내는 정수를 받아 시간을 시간, 분, 초로 변환합니다.
// 각 구성 요소는 두 자리 숫자로 포맷되며, 필요한 경우 앞에 0이 추가됩니다.
//
// - 매개변수 seconds: 포맷할 총 시간(초)입니다.
// - 반환값: HH:mm:ss 형식의 포맷된 시간을 나타내는 문자열입니다.
String getFormatTime(int seconds) {
  final int hours = seconds ~/ 3600;
  final int minutes = (seconds % 3600) ~/ 60;
  final int secs = seconds % 60;

  return '${hours.toString().padLeft(2, '0')}:'
      '${minutes.toString().padLeft(2, '0')}:'
      '${secs.toString().padLeft(2, '0')}';
}
