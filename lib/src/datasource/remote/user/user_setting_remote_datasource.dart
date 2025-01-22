import 'get_profile_api.dart';
import 'update_profile_api.dart';

class UserSettingRemoteDatasource {
  UserSettingRemoteDatasource({
    required this.getProfileApi,
    required this.updateProfileApi,
  });
  final UpdateProfileApi updateProfileApi;
  final GetProfileApi getProfileApi;

  Future<GetProfileApiResDto> getUserSetting() async {
    return await getProfileApi.execute();
  }

  Future<void> updateUserSetting(UpdateProfileApiReqDto dto) async {
    await updateProfileApi.execute(dto);
  }
}
