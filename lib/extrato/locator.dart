import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/get_domain_account_by_id_use_case.dart';
import 'package:viggo_pay_admin/extrato/ui/timeline_extrato_view_model.dart';
import 'package:viggo_pay_admin/pay_facs/domain/usecases/get_extrato_domain_account_use_case.dart';
import 'package:viggo_pay_core_frontend/domain/domain/usecases/get_domain_from_settings_use_case.dart';

class ExtratoLocator {
  void setup() {
    // viewModel
    locator.registerFactory(
      () => TimelineExtratoViewModel(
        getDomainAccount: locator.get<GetDomainAccountByIdUseCase>(),
        getDomainFromSettings: locator.get<GetDomainFromSettingsUseCase>(),
        getExtrato: locator.get<GetExtratoDomainAccountUseCase>(),
      ),
    );
  }
}
