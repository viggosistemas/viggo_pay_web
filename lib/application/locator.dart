import 'package:viggo_core_frontend/application/domain/application_repository.dart';
import 'package:viggo_core_frontend/application/domain/usecases/create_application_use_case.dart';
import 'package:viggo_core_frontend/application/domain/usecases/get_application_by_id_use_case.dart';
import 'package:viggo_core_frontend/application/domain/usecases/get_applications_by_params_use_case.dart';
import 'package:viggo_core_frontend/application/domain/usecases/update_application_use_case.dart';
import 'package:viggo_core_frontend/capability/domain/usecases/add_capability_use_case.dart';
import 'package:viggo_core_frontend/capability/domain/usecases/get_capabilities_by_params_use_case.dart';
import 'package:viggo_core_frontend/capability/domain/usecases/remove_capability_use_case.dart';
import 'package:viggo_core_frontend/policies/domain/usecases/add_policy_use_case.dart';
import 'package:viggo_core_frontend/policies/domain/usecases/remove_policy_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/clear_selected_items_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/get_selected_items_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/update_selected_item_use_case.dart';
import 'package:viggo_core_frontend/role/domain/usecases/get_roles_by_params_use_case.dart';
import 'package:viggo_core_frontend/route/domain/usecases/get_routes_by_params_use_case.dart';
import 'package:viggo_pay_admin/application/domain/usecases/change_active_application_use_case.dart';
import 'package:viggo_pay_admin/application/ui/edit_applications/edit_applications_view_model.dart';
import 'package:viggo_pay_admin/application/ui/edit_capability/edit_capability_view_model.dart';
import 'package:viggo_pay_admin/application/ui/edit_policy/edit_policy_view_model.dart';
import 'package:viggo_pay_admin/application/ui/list_applications/list_application_web_view_model.dart';
import 'package:viggo_pay_admin/di/locator.dart';

class ApplicationLocator {
  void setup() {
    //usecases
    locator.registerFactory(
      () => ChangeActiveApplicationUseCase(
        repository: locator.get<ApplicationRepository>(),
      ),
    );

    // ViewModels
    locator.registerFactory(
      () => EditApplicationsViewModel(
        getApplications: locator.get<GetApplicationsByParamsUseCase>(),
        createApplication: locator.get<CreateApplicationUseCase>(),
        updateApplication: locator.get<UpdateApplicationUseCase>(),
      ),
    );

    locator.registerFactory(
      () => ListApplicationWebViewModel(
        getApplication: locator.get<GetApplicationByIdUseCase>(),
        changeActive: locator.get<ChangeActiveApplicationUseCase>(),
        getApplications: locator.get<GetApplicationsByParamsUseCase>(),
        updateSelected: locator.get<UpdateSelectedItemUsecase>(),
        clearSelectedItems: locator.get<ClearSelectedItemsUseCase>(),
        getSelectedItems: locator.get<GetSelectedItemsUseCase>(),
      ),
    );
    locator.registerFactory(
      () => EditCapabilityViewModel(
        addCapabilities: locator.get<AddCapabilityUseCase>(),
        removeCapabilities: locator.get<RemoveCapabilityUseCase>(),
        getCapabilities: locator.get<GetCapabilitiesByParamsUseCase>(),
        updateSelected: locator.get<UpdateSelectedItemUsecase>(),
        clearSelectedItems: locator.get<ClearSelectedItemsUseCase>(),
        getSelectedItems: locator.get<GetSelectedItemsUseCase>(),
        getRoutes: locator.get<GetRoutesByParamsUseCase>(),
      ),
    );
    locator.registerFactory(
      () => EditPolicyViewModel(
        addPolicies: locator.get<AddPolicyUseCase>(),
        removePolicies: locator.get<RemovePolicyUseCase>(),
        getCapabilities: locator.get<GetCapabilitiesByParamsUseCase>(),
        updateSelected: locator.get<UpdateSelectedItemUsecase>(),
        clearSelectedItems: locator.get<ClearSelectedItemsUseCase>(),
        getSelectedItems: locator.get<GetSelectedItemsUseCase>(),
        getRoles: locator.get<GetRolesByParamsUseCase>(),
      ),
    );
  }
}
