import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/empresas/ui/domain_account_view_model.dart';
import 'package:viggo_pay_core_frontend/domain/domain/usecases/search_domain_by_name_use_case.dart';
import 'package:viggo_pay_core_frontend/domain/domain/usecases/set_domain_use_case.dart';
class ChavePixLocator {
  void setup() {
    // ViewModels
    locator.registerFactory(
      () => DomainAccountViewModel(
        searchDomainByName: locator.get<SearchDomainByNameUseCase>(),
        setDomain: locator.get<SetDomainUseCase>(),
      ),
    );
  }
}
