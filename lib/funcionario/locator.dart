import 'package:shared_preferences/shared_preferences.dart';
import 'package:viggo_core_frontend/localidades/domain/usecases/get_municipio_by_params_use_case.dart';
import 'package:viggo_core_frontend/localidades/domain/usecases/search_cep_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/preferences_settings.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/clear_selected_items_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/get_selected_items_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/update_selected_item_use_case.dart';
import 'package:viggo_core_frontend/user/domain/usecases/get_users_disponiveis_use_case.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/funcionario/data/funcionario_remote_data_source.dart';
import 'package:viggo_pay_admin/funcionario/data/funcionario_repository_impl.dart';
import 'package:viggo_pay_admin/funcionario/data/remote/funcionario_api.dart';
import 'package:viggo_pay_admin/funcionario/data/remote/funcionario_remote_data_source_impl.dart';
import 'package:viggo_pay_admin/funcionario/domain/funcionario_repository.dart';
import 'package:viggo_pay_admin/funcionario/domain/usecases/change_active_funcionario_use_case.dart';
import 'package:viggo_pay_admin/funcionario/domain/usecases/create_funcionario_use_case.dart';
import 'package:viggo_pay_admin/funcionario/domain/usecases/get_funcionario_by_id_use_case.dart';
import 'package:viggo_pay_admin/funcionario/domain/usecases/get_funcionario_by_params_use_case.dart';
import 'package:viggo_pay_admin/funcionario/domain/usecases/update_funcionario_use_case.dart';
import 'package:viggo_pay_admin/funcionario/ui/edit_funcionario/funcionario_view_model.dart';
import 'package:viggo_pay_admin/funcionario/ui/list_funcionario/list_funcionario_view_model.dart';
import 'package:viggo_pay_admin/parceiro/domain/usecases/create_parceiro_use_case.dart';
import 'package:viggo_pay_admin/parceiro/domain/usecases/update_parceiro_use_case.dart';
class FuncionarioLocator {
  void setup() {
      // api
    locator.registerFactory(
      () => FuncionarioApi(
        settings:
            locator.get<PreferencesSettings>(instanceName: 'preferences'),
      ),
    );

    // data source
    locator.registerFactory<FuncionarioRemoteDataSource>(
      () => FuncionarioRemoteDataSourceImpl(
        api: locator.get<FuncionarioApi>(),
      ),
    );

    // repository
    locator.registerFactory<FuncionarioRepository>(
      () => FuncionarioRepositoryImpl(
        remoteDataSource: locator.get<FuncionarioRemoteDataSource>(),
      ),
    );

    // use cases
    locator.registerFactory(
      () => GetFuncionarioByIdUseCase(
        repository: locator.get<FuncionarioRepository>(),
      ),
    );
    locator.registerFactory(
      () => GetFuncionarioByParamsUseCase(
        repository: locator.get<FuncionarioRepository>(),
      ),
    );
    locator.registerFactory(
      () => UpdateFuncionarioUseCase(
        repository: locator.get<FuncionarioRepository>(),
      ),
    );
    locator.registerFactory(
      () => CreateFuncionarioUseCase(
        repository: locator.get<FuncionarioRepository>(),
      ),
    );
    locator.registerFactory(
      () => ChangeActiveFuncionarioUseCase(
        repository: locator.get<FuncionarioRepository>(),
      ),
    );


    // ViewModels
    locator.registerFactory(
      () => ListFuncionarioViewModel(
        sharedPrefs: locator.get<SharedPreferences>(),
        getFuncionario: locator.get<GetFuncionarioByIdUseCase>(),
        changeActive: locator.get<ChangeActiveFuncionarioUseCase>(),
        getFuncionarios: locator.get<GetFuncionarioByParamsUseCase>(),
        updateSelected: locator.get<UpdateSelectedItemUsecase>(),
        getSelectedItems: locator.get<GetSelectedItemsUseCase>(),
        clearSelectedItems: locator.get<ClearSelectedItemsUseCase>(),
      ),
    );

    locator.registerFactory(
      () => EditFuncionarioViewModel(
        getMunicipio: locator.get<GetMunicipioByParamsUseCase>(),
        searchCep: locator.get<SearchCepUseCase>(),
        getUsers: locator.get<GetUsersDisponiveisUseCase>(),
        sharedPrefs: locator.get<SharedPreferences>(),
        updateFuncionario: locator.get<UpdateFuncionarioUseCase>(),
        createFuncionario: locator.get<CreateFuncionarioUseCase>(),
        updateParceiro: locator.get<UpdateParceiroUseCase>(),
        createParceiro: locator.get<CreateParceiroUseCase>(),
      ),
    );
  }
}
