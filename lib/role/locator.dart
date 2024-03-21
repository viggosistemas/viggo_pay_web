import 'package:viggo_core_frontend/preferences/domain/usecases/clear_selected_items_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/get_selected_items_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/update_selected_item_use_case.dart';
import 'package:viggo_core_frontend/role/domain/role_repository.dart';
import 'package:viggo_core_frontend/role/domain/usecases/create_role_use_case.dart';
import 'package:viggo_core_frontend/role/domain/usecases/get_role_by_id_use_case.dart';
import 'package:viggo_core_frontend/role/domain/usecases/get_roles_by_params_use_case.dart';
import 'package:viggo_core_frontend/role/domain/usecases/update_role_use_case.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/role/domain/usecases/change_active_role_use_case.dart';
import 'package:viggo_pay_admin/role/ui/edit_roles/edit_roles_view_model.dart';
import 'package:viggo_pay_admin/role/ui/list_roles/list_role_web_view_model.dart';

class RoleLocator {
  void setup() {
    //usecases
    locator.registerFactory(
      () => ChangeActiveRoleUseCase(
        repository: locator.get<RoleRepository>(),
      ),
    );

    // ViewModels
    locator.registerFactory(
      () => EditRolesViewModel(
        getRoles: locator.get<GetRolesByParamsUseCase>(),
        createRole: locator.get<CreateRoleUseCase>(),
        updateRole: locator.get<UpdateRoleUseCase>(),
      ),
    );

    locator.registerFactory(
      () => ListRoleWebViewModel(
        getRole: locator.get<GetRoleByIdUseCase>(),
        changeActive: locator.get<ChangeActiveRoleUseCase>(),
        getRoles: locator.get<GetRolesByParamsUseCase>(),
        updateSelected: locator.get<UpdateSelectedItemUsecase>(),
        clearSelectedItems: locator.get<ClearSelectedItemsUseCase>(),
        getSelectedItems: locator.get<GetSelectedItemsUseCase>(),
      ),
    );
  }
}
