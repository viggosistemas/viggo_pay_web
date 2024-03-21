import 'package:shared_preferences/shared_preferences.dart';
import 'package:viggo_core_frontend/domain/domain/usecases/get_domain_from_settings_use_case.dart';
import 'package:viggo_core_frontend/domain/domain/usecases/search_domain_by_name_use_case.dart';
import 'package:viggo_core_frontend/domain/domain/usecases/set_domain_use_case.dart';
import 'package:viggo_core_frontend/image/domain/usecases/parse_image_url_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/clear_remember_credential_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/get_remember_credential_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/set_remember_credential_use_case.dart';
import 'package:viggo_core_frontend/route/domain/usecases/get_routes_use_case.dart';
import 'package:viggo_core_frontend/route/domain/usecases/set_routes_use_case.dart';
import 'package:viggo_core_frontend/token/domain/usecases/login_use_case.dart';
import 'package:viggo_core_frontend/token/domain/usecases/set_token_use_case.dart';
import 'package:viggo_core_frontend/user/domain/usecases/get_routes_from_user_use_case.dart';
import 'package:viggo_core_frontend/user/domain/usecases/get_user_by_id_use_case.dart';
import 'package:viggo_core_frontend/user/domain/usecases/get_user_use_case.dart';
import 'package:viggo_core_frontend/user/domain/usecases/set_user_use_case.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/login/ui/login_view_model.dart';
import 'package:viggo_pay_admin/sync/domain/usecases/get_app_state_use_case.dart';

class LoginLocator {
  void setup() {
    // ViewModel
    locator.registerFactory(
      () => LoginViewModel(
        sharedPrefs: locator.get<SharedPreferences>(),
        clearRememberCredential: locator.get<ClearRememberCredentialUseCase>(),
        getRememberCredential: locator.get<GetRememberCredentialUseCase>(),
        setRememberCredential: locator.get<SetRememberCredentialUseCase>(),
        getDomainByName: locator.get<SearchDomainByNameUseCase>(),
        getAppState: locator.get<GetAppStateUseCase>(),
        getDomainFromSettings: locator.get<GetDomainFromSettingsUseCase>(),
        login: locator.get<LoginUseCase>(),
        setToken: locator.get<SetTokenUseCase>(),
        setDomain: locator.get<SetDomainUseCase>(),
        parseImage: locator.get<ParseImageUrlUseCase>(),
        getRoutesFromUser: locator.get<GetRoutesFromUserUseCase>(),
        getUserById: locator.get<GetUserByIdUseCase>(),
        setUser: locator.get<SetUserUseCase>(),
        setRoutes: locator.get<SetRoutesUseCase>(),
        getUserFromSettings: locator.get<GetUserUseCase>(),
        getRoutesFromSettings: locator.get<GetRoutesUseCase>(),
      ),
    );
  }
}
