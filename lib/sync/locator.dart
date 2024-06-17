import 'package:viggo_core_frontend/preferences/domain/preferences_settings.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/sync/domain/usecases/get_app_state_use_case.dart';
import 'package:viggo_pay_admin/sync/domain/usecases/get_app_state_use_case_impl.dart';

class SyncLocator {
  void setup() {
    //UseCases
    locator.registerFactory<GetAppStateUseCase>(
      () => GetAppStateUseCaseImpl(
        userSettings:
            locator.get<PreferencesSettings>(instanceName: 'preferences'),
      ),
    );
  }
}
