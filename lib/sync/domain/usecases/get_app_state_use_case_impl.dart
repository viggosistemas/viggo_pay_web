import 'package:viggo_pay_admin/sync/domain/usecases/get_app_state_use_case.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/preferences_settings.dart';

class GetAppStateUseCaseImpl implements GetAppStateUseCase {
  final PreferencesSettings userSettings;

  GetAppStateUseCaseImpl({required this.userSettings});

  @override
  Stream<String> invoke() => userSettings.appState;
}
