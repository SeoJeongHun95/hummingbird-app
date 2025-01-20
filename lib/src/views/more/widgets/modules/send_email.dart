import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

void sendEmail(BuildContext context) async {
  final Email email = Email(
    body:
        '• 이름:\n• 이메일:\n• 연락처:\n• 문의 제목:\n\n• 문의 내용:\n\n• 문의 목적:\n• 협력 제안:\n• 피드백 제공: ( Y / N)\n• 기능 개선 요청:\n• 기타 문의:\n\n첨부파일여부:\n\n개인정보 보호 동의: [✓] 개인정보 수집 및 이용에 동의합니다.',
    subject: '[Study Duck] 문의 및 제휴 메일', // 이메일 제목
    recipients: ['fluttersesac@gmail.com'], // 수신자 목록
    bcc: ['maccrey@naver.com',], // 숨은 참조
    isHTML: false, // HTML 형식 여부
  );
  try {
    await FlutterEmailSender.send(email);
  } catch (e) {
    _showErrorDialog(context);
  }
}

void _showErrorDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('안내'),
        content: const Text(
          '기본 메일 앱을 사용할 수 없기 때문에 \n앱에서 바로 문의를 전송하기 어려운 상태입니다.\n\n'
          '사용하시는 메일을 이용하여\nfluttersessac@gmail.com으로 문의 부탁드립니다.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // 다이얼로그 닫기
            child: const Text('확인'),
          ),
        ],
      );
    },
  );
}
