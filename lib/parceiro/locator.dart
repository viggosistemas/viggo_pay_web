import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/parceiro/data/parceiro_remote_data_source.dart';
import 'package:viggo_pay_admin/parceiro/data/parceiro_repository_impl.dart';
import 'package:viggo_pay_admin/parceiro/data/remote/parceiro_api.dart';
import 'package:viggo_pay_admin/parceiro/data/remote/parceiro_remote_data_source_impl.dart';
import 'package:viggo_pay_admin/parceiro/domain/parceiro_repository.dart';
import 'package:viggo_pay_admin/parceiro/domain/usecases/change_active_parceiro_use_case.dart';
import 'package:viggo_pay_admin/parceiro/domain/usecases/create_parceiro_use_case.dart';
import 'package:viggo_pay_admin/parceiro/domain/usecases/get_parceiro_by_id_use_case.dart';
import 'package:viggo_pay_admin/parceiro/domain/usecases/get_parceiro_by_params_use_case.dart';
import 'package:viggo_pay_admin/parceiro/domain/usecases/update_parceiro_use_case.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/preferences_settings.dart';
class ParceiroLocator {
  void setup() {
      // api
    locator.registerFactory(
      () => ParceiroApi(
        settings:
            locator.get<PreferencesSettings>(instanceName: 'preferences'),
      ),
    );

    // data source
    locator.registerFactory<ParceiroRemoteDataSource>(
      () => ParceiroRemoteDataSourceImpl(
        api: locator.get<ParceiroApi>(),
      ),
    );

    // repository
    locator.registerFactory<ParceiroRepository>(
      () => ParceiroRepositoryImpl(
        remoteDataSource: locator.get<ParceiroRemoteDataSource>(),
      ),
    );

    // use cases
    locator.registerFactory(
      () => GetParceiroByIdUseCase(
        repository: locator.get<ParceiroRepository>(),
      ),
    );
    locator.registerFactory(
      () => GetParceiroByParamsUseCase(
        repository: locator.get<ParceiroRepository>(),
      ),
    );
    locator.registerFactory(
      () => UpdateParceiroUseCase(
        repository: locator.get<ParceiroRepository>(),
      ),
    );
    locator.registerFactory(
      () => CreateParceiroUseCase(
        repository: locator.get<ParceiroRepository>(),
      ),
    );
    locator.registerFactory(
      () => ChangeActiveParceiroUseCase(
        repository: locator.get<ParceiroRepository>(),
      ),
    );

  }
}
