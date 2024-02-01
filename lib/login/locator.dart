import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/login/ui/login_view_model.dart';
import 'package:viggo_pay_admin/sync/domain/usecases/get_app_state_use_case.dart';
import 'package:viggo_pay_core_frontend/domain/domain/usecases/get_domain_fom_settings_use_case.dart';
import 'package:viggo_pay_core_frontend/domain/domain/usecases/search_domain_by_name_use_case.dart';
import 'package:viggo_pay_core_frontend/image/domain/usecases/parse_image_url_use_case.dart';
import 'package:viggo_pay_core_frontend/token/domain/usecases/login_use_case.dart';
import 'package:viggo_pay_core_frontend/token/domain/usecases/set_token_use_case.dart';

class LoginLocator {
  void setup(){
    // ViewModel
    locator.registerFactory(
      () => LoginViewModel(
        getDomainByName: locator.get<SearchDomainByNameUseCase>(),
        getAppState: locator.get<GetAppStateUseCase>(),
        getDomainFromSettings: locator.get<GetDomainFromSettingsUseCase>(),
        login: locator.get<LoginUseCase>(),
        setToken: locator.get<SetTokenUseCase>(),
        parseImage: locator.get<ParseImageUrlUseCase>(),
      ),
    );
  }
}
