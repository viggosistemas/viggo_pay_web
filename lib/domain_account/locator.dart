import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/domain_account/data/domain_account_data_source.dart';
import 'package:viggo_pay_admin/domain_account/data/domain_account_repository_impl.dart';
import 'package:viggo_pay_admin/domain_account/data/remote/domain_account_api.dart';
import 'package:viggo_pay_admin/domain_account/data/remote/domain_account_remote_data_source_impl.dart';
import 'package:viggo_pay_admin/domain_account/domain/domain_repository.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/get_domain_account_by_id_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/get_domain_accounts_by_params_use_case.dart';
import 'package:viggo_pay_admin/domain_account/ui/domain_account_view_model.dart';
import 'package:viggo_pay_admin/domain_account/ui/list_domain_accounts/list_domain_accounts_view_model.dart';
import 'package:viggo_pay_core_frontend/domain/domain/usecases/search_domain_by_name_use_case.dart';
import 'package:viggo_pay_core_frontend/domain/domain/usecases/set_domain_use_case.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/preferences_settings.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/usecases/get_selected_items_use_case.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/usecases/update_selected_item_use_case.dart';

class DomainAccountLocator {
  void setup() {
    // api
    locator.registerFactory(
      () => DomainAccountApi(
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

    // repository
    locator.registerFactory<DomainAccountRepository>(
      () => DomainAccountRepositoryImpl(
        remoteDataSource: locator.get<DomainAccountRemoteDataSource>(),
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


    // ViewModels
    locator.registerFactory(
      () => DomainAccountViewModel(
        searchDomainByName: locator.get<SearchDomainByNameUseCase>(),
        setDomain: locator.get<SetDomainUseCase>(),
      ),
    );

    locator.registerFactory(
      () => ListDomainAccountViewModel(
        getDomainAccounts: locator.get<GetDomainAccountsByParamsUseCase>(),
        updateSelected: locator.get<UpdateSelectedItemUsecase>(),
        getSelectedItems: locator.get<GetSelectedItemsUseCase>(),
      ),
    );
  }
}
