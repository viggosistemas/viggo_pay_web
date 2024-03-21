import 'package:shared_preferences/shared_preferences.dart';
import 'package:viggo_core_frontend/application/domain/usecases/get_roles_from_application_by_id_use_case.dart';
import 'package:viggo_core_frontend/domain/domain/usecases/get_domains_by_params_use_case.dart';
import 'package:viggo_core_frontend/grant/domain/usecases/add_grant_use_case.dart';
import 'package:viggo_core_frontend/grant/domain/usecases/delete_grant_use_case.dart';
import 'package:viggo_core_frontend/grant/domain/usecases/get_grants_from_user_by_id_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/clear_selected_items_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/get_selected_items_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/update_selected_item_use_case.dart';
import 'package:viggo_core_frontend/user/domain/usecases/create_user_use_case.dart';
import 'package:viggo_core_frontend/user/domain/usecases/get_user_by_id_use_case.dart';
import 'package:viggo_core_frontend/user/domain/usecases/get_users_by_params_use_case.dart';
import 'package:viggo_core_frontend/user/domain/usecases/update_user_use_case.dart';
import 'package:viggo_core_frontend/user/domain/user_repository.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/user/domain/usecases/change_active_user_use_case.dart';
import 'package:viggo_pay_admin/user/ui/edit_users/edit_users_view_model.dart';
import 'package:viggo_pay_admin/user/ui/list_users/list_users_web_view_model.dart';

class UsersLocator {
  void setup() {
    //usecases
    locator.registerFactory(
      () => ChangeActiveUserUseCase(
        repository: locator.get<UserRepository>(),
      ),
    );

    // ViewModels
    locator.registerFactory(
      () => EditUsersViewModel(
        sharedPrefs: locator.get<SharedPreferences>(),
        getDomains: locator.get<GetDomainsByParamsUseCase>(),
        createUser: locator.get<CreateUserUseCase>(),
        updateUser: locator.get<UpdateUserUseCase>(),
        getGrantsUser: locator.get<GetGrantsFromUserIdUseCase>(),
        deleteGranUser: locator.get<DeleteGrantUseCase>(),
        addGrantUser: locator.get<AddGrantUseCase>(),
        getRolesApplication: locator.get<GetRolesFromApplicationIdUseCase>(),
      ),
    );

    locator.registerFactory(
      () => ListUserWebViewModel(
        sharedPrefs: locator.get<SharedPreferences>(),
        getUser: locator.get<GetUserByIdUseCase>(),
        changeActive: locator.get<ChangeActiveUserUseCase>(),
        getUsers: locator.get<GetUsersByParamsUseCase>(),
        updateSelected: locator.get<UpdateSelectedItemUsecase>(),
        clearSelectedItems: locator.get<ClearSelectedItemsUseCase>(),
        getSelectedItems: locator.get<GetSelectedItemsUseCase>(),
      ),
    );
  }
}
