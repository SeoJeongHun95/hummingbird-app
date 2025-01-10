import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/const/box_keys.dart';
import '../../models/study_record/study_record.dart';
import '../../models/subject/subject.dart';
import '../../models/token_model.dart';

Future<void> appInitialize() async {
  final directory = await getApplicationDocumentsDirectory();
  const secureStorage = FlutterSecureStorage();
  var containsEncryptionKey =
      await secureStorage.containsKey(key: BoxKeys.encryptionBoxKey);

  if (!containsEncryptionKey) {
    var key = Hive.generateSecureKey();
    await secureStorage.write(
        key: BoxKeys.encryptionBoxKey, value: base64UrlEncode(key));
  }

  var key = base64Url.decode(
      await secureStorage.read(key: BoxKeys.encryptionBoxKey) as String);

  await Hive.initFlutter(directory.path);
  Hive.registerAdapter(TokenModelAdapter());
  await Hive.openBox<TokenModel>(BoxKeys.tokenBoxKey,
      encryptionCipher: HiveAesCipher(key));

  await Hive.openBox<List<int>>(BoxKeys.suduckBoxKey);

  //과목
  Hive.registerAdapter(SubjectAdapter());
  await Hive.openBox<Subject>(BoxKeys.subjectBoxKey);

  //학습 내역
  Hive.registerAdapter(StudyRecordAdapter());
  // await Hive.deleteBoxFromDisk(BoxKeys.studyRecordBoxkey);
  await Hive.openBox<List<StudyRecord>>(BoxKeys.studyRecordBoxkey);
}
