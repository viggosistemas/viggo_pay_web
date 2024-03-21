import 'package:viggo_core_frontend/application/domain/usecases/get_applications_by_params_use_case.dart';
import 'package:viggo_core_frontend/domain/domain/domain_repository.dart';
import 'package:viggo_core_frontend/domain/domain/usecases/get_domain_by_id_use_case.dart';
import 'package:viggo_core_frontend/domain/domain/usecases/get_domains_by_params_use_case.dart';
import 'package:viggo_core_frontend/domain/domain/usecases/register_use_case.dart';
import 'package:viggo_core_frontend/domain/domain/usecases/update_domain_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/clear_selected_items_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/get_selected_items_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/update_selected_item_use_case.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/domain/domain/usecases/change_active_domain_use_case.dart';
import 'package:viggo_pay_admin/domain/ui/edit_domains/edit_domains_view_model.dart';
import 'package:viggo_pay_admin/domain/ui/list_domains/list_domain_web_view_model.dart';

class DomainLocator {
  void setup() {
    //usecases
    locator.registerFactory(
      () => ChangeActiveDomainUseCase(
        repository: locator.get<DomainRepository>(),
      ),
    );

    // ViewModels
    locator.registerFactory(
      () => EditDomainsViewModel(
        getDomains: locator.get<GetDomainsByParamsUseCase>(),
        getApplications: locator.get<GetApplicationsByParamsUseCase>(),
        registerDomain: locator.get<RegisterUseCase>(),
        updateDomain: locator.get<UpdateDomainUseCase>(),
      ),
    );
    
    locator.registerFactory(
      () => ListDomainWebViewModel(
        getDomain: locator.get<GetDomainByIdUseCase>(),
        changeActive: locator.get<ChangeActiveDomainUseCase>(),
        getDomains: locator.get<GetDomainsByParamsUseCase>(),
        updateSelected: locator.get<UpdateSelectedItemUsecase>(),
        clearSelectedItems: locator.get<ClearSelectedItemsUseCase>(),
        getSelectedItems: locator.get<GetSelectedItemsUseCase>(),
      ),
    );
  }
}
