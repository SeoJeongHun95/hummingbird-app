class GrassDataModel {
  final DateTime studyDay;
  final int studyCount;

  // 생성자
  GrassDataModel({
    required this.studyDay,
    required this.studyCount,
  });

  // JSON을 객체로 변환하는 생성자
  factory GrassDataModel.fromJson(Map<String, dynamic> json) {
    return GrassDataModel(
      studyDay: DateTime.fromMillisecondsSinceEpoch(json['studyDay'] * 1000),
      studyCount: json['studyCount'] as int,
    );
  }

  // 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'studyDay': studyDay.millisecondsSinceEpoch ~/ 1000,
      'studyCount': studyCount,
    };
  }

  // 날짜를 DateTime으로 반환하는 메서드 (에포크 시간을 DateTime 객체로 변환)
  DateTime get studyDateTime => studyDay;
}
