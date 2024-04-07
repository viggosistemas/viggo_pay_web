import 'package:viggo_core_frontend/domain/domain/usecases/get_domain_from_settings_use_case.dart';
import 'package:viggo_core_frontend/domain/domain/usecases/set_domain_use_case.dart';
import 'package:viggo_core_frontend/domain/domain/usecases/upload_logo_use_case.dart';
import 'package:viggo_core_frontend/image/domain/usecases/parse_image_url_use_case.dart';
import 'package:viggo_pay_admin/dashboard/ui/dashboard_view_model.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/get_config_domain_account_by_id_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/get_domain_account_by_id_use_case.dart';
import 'package:viggo_pay_admin/pay_facs/domain/usecases/get_extrato_domain_account_use_case.dart';
import 'package:viggo_pay_admin/pay_facs/domain/usecases/get_saldo_domain_account_use_case.dart';
import 'package:viggo_pay_admin/pix_to_send/domain/usecases/get_pix_to_send_by_params_use_case.dart';

class DashboardLocator {
  void setup() {
    locator.registerLazySingleton(
      () => DashboardViewModel(
        getConfigDomainAccount: locator.get<GetDomainAccountConfigByIdUseCase>(),
        parseImage: locator.get<ParseImageUrlUseCase>(),
        setDomain: locator.get<SetDomainUseCase>(),
        uploadLogo: locator.get<UploadLogoDomainUseCase>(),
        getExtrato: locator.get<GetExtratoDomainAccountUseCase>(),
        getDomainAccount: locator.get<GetDomainAccountByIdUseCase>(),
        getDomainFromSettings: locator.get<GetDomainFromSettingsUseCase>(),
        getSaldo: locator.get<GetSaldoDomainAccountUseCase>(),
        listChavePixToSends: locator.get<GetPixToSendsByParamsUseCase>(),
      ),
    );
  }
}
