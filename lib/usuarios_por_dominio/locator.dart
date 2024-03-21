import 'package:viggo_core_frontend/domain/domain/usecases/get_domains_by_params_use_case.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/usuarios_por_dominio/ui/list_users_domain_view_model.dart';

class UsersDomainLocator {
  void setup() {
    locator.registerFactory(
      () => ListUsersDomainViewModel(
        getDomains: locator.get<GetDomainsByParamsUseCase>(),
      ),
    );
  }
}
