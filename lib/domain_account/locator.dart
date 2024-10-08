import 'package:viggo_core_frontend/domain/domain/usecases/get_domain_from_settings_use_case.dart';
import 'package:viggo_core_frontend/localidades/domain/usecases/get_municipio_by_params_use_case.dart';
import 'package:viggo_core_frontend/localidades/domain/usecases/search_cep_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/preferences_settings.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/clear_selected_items_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/get_selected_items_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/update_selected_item_use_case.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/domain_account/data/domain_account_config_data_source.dart';
import 'package:viggo_pay_admin/domain_account/data/domain_account_config_repository_impl.dart';
import 'package:viggo_pay_admin/domain_account/data/domain_account_data_source.dart';
import 'package:viggo_pay_admin/domain_account/data/domain_account_repository_impl.dart';
import 'package:viggo_pay_admin/domain_account/data/remote/domain_account_api.dart';
import 'package:viggo_pay_admin/domain_account/data/remote/domain_account_config_api.dart';
import 'package:viggo_pay_admin/domain_account/data/remote/domain_account_config_remote_data_source_impl.dart';
import 'package:viggo_pay_admin/domain_account/data/remote/domain_account_remote_data_source_impl.dart';
import 'package:viggo_pay_admin/domain_account/domain/domain_account_config_repository.dart';
import 'package:viggo_pay_admin/domain_account/domain/domain_account_repository.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/add_config_domain_account_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/add_domain_account_documents_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/change_active_domain_account_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/get_config_domain_account_by_id_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/get_domain_account_by_id_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/get_domain_accounts_by_params_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/get_extrato_pdf_domain_account_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/resetar_tentativas_matera_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/update_config_domain_account_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/update_domain_account_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/update_password_pix_matera_use_case.dart';
import 'package:viggo_pay_admin/domain_account/ui/edit_domain_accounts/edit_domain_accounts_view_model.dart';
import 'package:viggo_pay_admin/domain_account/ui/list_domain_accounts/list_domain_accounts_view_model.dart';

class DomainAccountLocator {
  void setup() {
    // api
    locator.registerFactory(
      () => DomainAccountApi(
        settings:
            locator.get<PreferencesSettings>(instanceName: 'preferences'),
      ),
    );
    locator.registerFactory(
      () => DomainAccountConfigApi(
        settings:
            locator.get<PreferencesSettings>(instanceName: 'preferences'),
      ),
    );

    // data source
    locator.registerFactory<DomainAccountRemoteDataSource>(
      () => DomainAccountRemoteDataSourceImpl(
        api: locator.get<DomainAccountApi>(),
      ),
    );
    locator.registerFactory<DomainAccountConfigRemoteDataSource>(
      () => DomainAccountConfigRemoteDataSourceImpl(
        api: locator.get<DomainAccountConfigApi>(),
      ),
    );

    // repository
    locator.registerFactory<DomainAccountRepository>(
      () => DomainAccountRepositoryImpl(
        remoteDataSource: locator.get<DomainAccountRemoteDataSource>(),
      ),
    );
    locator.registerFactory<DomainAccountConfigRepository>(
      () => DomainAccountConfigRepositoryImpl(
        remoteDataSource: locator.get<DomainAccountConfigRemoteDataSource>(),
      ),
    );

    // use cases
    locator.registerFactory(
      () => GetDomainAccountsByParamsUseCase(
        repository: locator.get<DomainAccountRepository>(),
      ),
    );
    locator.registerFactory(
      () => GetDomainAccountByIdUseCase(
        repository: locator.get<DomainAccountRepository>(),
      ),
    );
    locator.registerFactory(
      () => UpdateDomainAccountUseCase(
        repository: locator.get<DomainAccountRepository>(),
      ),
    );
    locator.registerFactory(
      () => ChangeActiveDomainAccountUseCase(
        repository: locator.get<DomainAccountRepository>(),
      ),
    );
    locator.registerFactory(
      () => UpdatePasswordPixUseCase(
        repository: locator.get<DomainAccountRepository>(),
      ),
    );
    locator.registerFactory(
      () => AddDomainAccountDocumentsUseCase(
        repository: locator.get(),
      ),
    );
    locator.registerFactory(
      () => GetExtratoPdfDomainAccountUseCase(
        repository: locator.get(),
      ),
    );
    locator.registerFactory(
      () => ResetarTentativasMateraUseCase(
        repository: locator.get<DomainAccountRepository>(),
      ),
    );

    //domain_account_taxa

    locator.registerFactory(
      () => UpdateConfigDomainAccountUseCase(
        repository: locator.get<DomainAccountConfigRepository>(),
      ),
    );
    locator.registerFactory(
      () => AddConfigDomainAccountUseCase(
        repository: locator.get<DomainAccountConfigRepository>(),
      ),
    );
    locator.registerFactory(
      () => GetDomainAccountConfigByIdUseCase(
        repository: locator.get<DomainAccountConfigRepository>(),
      ),
    );


    // ViewModels
    locator.registerFactory(
      () => ListDomainAccountViewModel(
        getDomainAccount: locator.get<GetDomainAccountByIdUseCase>(),
        changeActive: locator.get<ChangeActiveDomainAccountUseCase>(),
        getConfigDomainAccount: locator.get<GetDomainAccountConfigByIdUseCase>(),
        getDomainAccounts: locator.get<GetDomainAccountsByParamsUseCase>(),
        updateSelected: locator.get<UpdateSelectedItemUsecase>(),
        clearSelectedItems: locator.get<ClearSelectedItemsUseCase>(),
        getSelectedItems: locator.get<GetSelectedItemsUseCase>(),
        resetarTentativas: locator.get<ResetarTentativasMateraUseCase>(),
        getDomainFromSettingsUseCase: locator.get<GetDomainFromSettingsUseCase>()
      ),
    );
    locator.registerFactory(
      () => EditDomainAccountViewModel(
        getMunicipio: locator.get<GetMunicipioByParamsUseCase>(),
        searchCep: locator.get<SearchCepUseCase>(),
        addDomainAccountDocuments: locator.get<AddDomainAccountDocumentsUseCase>(),
        updateDomainAccount: locator.get<UpdateDomainAccountUseCase>(),
        updateConfigAccount: locator.get<UpdateConfigDomainAccountUseCase>(),
        createConfigAccount: locator.get<AddConfigDomainAccountUseCase>(),
      ),
    );
  }
}
