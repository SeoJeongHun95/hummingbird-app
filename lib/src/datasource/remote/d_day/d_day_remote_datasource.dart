import 'create_dday_api.dart';
import 'delete_dday_api.dart';
import 'get_my_ddays_api.dart';
import 'update_dday_api.dart';

class DDayRemoteDatasource {
  DDayRemoteDatasource(
      {required this.createDdayApi,
      required this.getMyDdaysApi,
      required this.updateDdayApi,
      required this.deleteDdayApi});

  CreateDdayApi createDdayApi;
  GetMyDdaysApi getMyDdaysApi;
  UpdateDdayApi updateDdayApi;
  DeleteDdayApi deleteDdayApi;

  Future<String> addDDay(CreateDdayApiReqDto dto) async {
    try {
      final createDdayApiResDto = await createDdayApi.execute(dto);
      return createDdayApiResDto.ddayId;
    } catch (e) {
      throw Exception('데이터를 저장하는데 실패했습니다');
    }
  }

  Future<List<DdayInfo>> getMyDdays() async {
    try {
      final response = await getMyDdaysApi.execute();
      return response.ddays;
    } catch (e) {
      throw Exception('데이터를 로드하는 데 실패했습니다');
    }
  }

  Future<void> updateDday(UpdateDdayApiReqDto dto) async {
    try {
      await updateDdayApi.execute(dto);
    } catch (e) {
      throw Exception('데이터를 업데이트 하는데 실패했습니다');
    }
  }

  Future<void> deleteDday(String ddayId) async {
    try {
      await deleteDdayApi.execute(ddayId: ddayId);
    } catch (e) {
      throw Exception('데이터를 삭제하는데 실패했습니다');
    }
  }
}
