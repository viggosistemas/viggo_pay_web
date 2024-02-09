import 'package:viggo_pay_admin/app_builder/ui/app_builder_view_model.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/sync/domain/usecases/get_app_state_use_case.dart';
import 'package:viggo_pay_core_frontend/domain/domain/usecases/get_domain_from_settings_use_case.dart';
import 'package:viggo_pay_core_frontend/route/domain/usecases/get_routes_use_case.dart';
import 'package:viggo_pay_core_frontend/token/domain/usecases/get_token_use_case.dart';
import 'package:viggo_pay_core_frontend/token/domain/usecases/logout_use_case.dart';
import 'package:viggo_pay_core_frontend/user/domain/usecases/get_user_use_case.dart';

class AppBuilderLocator {
  void setup() {
    // ViewModels
    locator.registerFactory(
      () => AppBuilderViewModel(
        getAppState: locator.get<GetAppStateUseCase>(),
        logout: locator.get<LogoutUseCase>(),
        getToken: locator.get<GetTokenUseCase>(),
        getUserFromSettings: locator.get<GetUserUseCase>(),
        getDomainFromSettings: locator.get<GetDomainFromSettingsUseCase>(),
        getRoutesFromSettings: locator.get<GetRoutesUseCase>(),
      ),
    );
  }
}
