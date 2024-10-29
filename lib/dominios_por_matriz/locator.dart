import 'package:viggo_core_frontend/domain/domain/usecases/get_domains_by_params_use_case.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/dominios_por_matriz/ui/list_domains_matriz_view_model.dart';

class DomainsMatrizLocator {
  void setup() {
    locator.registerFactory(
      () => ListDomainsMatrizViewModel(
        getDomains: locator.get<GetDomainsByParamsUseCase>(),
      ),
    );
  }
}
