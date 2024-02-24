import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/pix_to_send/data/pix_to_send_data_source.dart';
import 'package:viggo_pay_admin/pix_to_send/data/pix_to_send_repository_impl.dart';
import 'package:viggo_pay_admin/pix_to_send/data/remote/pix_to_send_api.dart';
import 'package:viggo_pay_admin/pix_to_send/data/remote/pix_to_send_remote_data_source_impl.dart';
import 'package:viggo_pay_admin/pix_to_send/domain/pix_to_send_repository.dart';
import 'package:viggo_pay_admin/pix_to_send/domain/usecases/create_pix_to_send_use_case.dart';
import 'package:viggo_pay_admin/pix_to_send/domain/usecases/get_pix_to_send_by_id_use_case.dart';
import 'package:viggo_pay_admin/pix_to_send/domain/usecases/get_pix_to_send_by_params_use_case.dart';
import 'package:viggo_pay_admin/pix_to_send/domain/usecases/update_pix_to_send_use_case.dart';
import 'package:viggo_pay_admin/pix_to_send/ui/edit_pix_to_send/edit_pix_to_sends_view_model.dart';
import 'package:viggo_pay_admin/pix_to_send/ui/list_pix_to_send/list_pix_to_send_view_model.dart';
import 'package:viggo_pay_core_frontend/domain/domain/usecases/get_domain_from_settings_use_case.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/preferences_settings.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/usecases/clear_selected_items_use_case.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/usecases/get_selected_items_use_case.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/usecases/update_selected_item_use_case.dart';
class PixToSendLocator {
  void setup() {
      // api
    locator.registerFactory(
      () => PixToSendApi(
        settings:
            locator.get<PreferencesSettings>(instanceName: 'preferences'),
      ),
    );

    // data source
    locator.registerFactory<PixToSendRemoteDataSource>(
      () => PixToSendRemoteDataSourceImpl(
        api: locator.get<PixToSendApi>(),
      ),
    );

    // repository
    locator.registerFactory<PixToSendRepository>(
      () => PixToSendRepositoryImpl(
        remoteDataSource: locator.get<PixToSendRemoteDataSource>(),
      ),
    );

    // use cases
    locator.registerFactory(
      () => GetPixToSendsByParamsUseCase(
        repository: locator.get<PixToSendRepository>(),
      ),
    );
    locator.registerFactory(
      () => GetPixToSendByIdUseCase(
        repository: locator.get<PixToSendRepository>(),
      ),
    );
    locator.registerFactory(
      () => UpdatePixToSendUseCase(
        repository: locator.get<PixToSendRepository>(),
      ),
    );
    locator.registerFactory(
      () => CreatePixToSendUseCase(
        repository: locator.get<PixToSendRepository>(),
      ),
    );


    // ViewModels
    locator.registerFactory(
      () => ListPixToSendViewModel(
        getPixToSends: locator.get<GetPixToSendsByParamsUseCase>(),
        updateSelected: locator.get<UpdateSelectedItemUsecase>(),
        getSelectedItems: locator.get<GetSelectedItemsUseCase>(),
        clearSelectedItems: locator.get<ClearSelectedItemsUseCase>(),
      ),
    );

    locator.registerFactory(
      () => EditPixToSendViewModel(
        getDomainFromSettings: locator.get<GetDomainFromSettingsUseCase>(),
        updatePixToSend: locator.get<UpdatePixToSendUseCase>(),
        createPixToSend: locator.get<CreatePixToSendUseCase>(),
      ),
    );
  }
}
