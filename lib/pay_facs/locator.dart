import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/pay_facs/data/pay_facs_data_source.dart';
import 'package:viggo_pay_admin/pay_facs/data/pay_facs_repository_impl.dart';
import 'package:viggo_pay_admin/pay_facs/data/remote/pay_facs_api.dart';
import 'package:viggo_pay_admin/pay_facs/data/remote/pay_facs_remote_data_source_impl.dart';
import 'package:viggo_pay_admin/pay_facs/domain/pay_facs_repository.dart';
import 'package:viggo_pay_admin/pay_facs/domain/usecases/cashout_via_pix_domain_account_use_case.dart';
import 'package:viggo_pay_admin/pay_facs/domain/usecases/consultar_alias_destinatario_use_case.dart';
import 'package:viggo_pay_admin/pay_facs/domain/usecases/get_extrato_domain_account_use_case.dart';
import 'package:viggo_pay_admin/pay_facs/domain/usecases/get_saldo_domain_account_use_case.dart';
import 'package:viggo_pay_admin/pay_facs/domain/usecases/get_transacoes_domain_account_use_case.dart';
import 'package:viggo_pay_admin/pay_facs/domain/usecases/get_ultima_transacao_domain_account_use_case.dart';
import 'package:viggo_pay_admin/pay_facs/domain/usecases/list_chave_pix_domain_account_use_case.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/preferences_settings.dart';
class PayFacsLocator {
  void setup() {
      // api
    locator.registerFactory(
      () => PayFacsApi(
        settings:
            locator.get<PreferencesSettings>(instanceName: 'preferences'),
      ),
    );

    // data source
    locator.registerFactory<PayFacsRemoteDataSource>(
      () => PayFacsRemoteDataSourceImpl(
        api: locator.get<PayFacsApi>(),
      ),
    );

    // repository
    locator.registerFactory<PayFacsRepository>(
      () => PayFacsRepositoryImpl(
        remoteDataSource: locator.get<PayFacsRemoteDataSource>(),
      ),
    );

    // use cases
    locator.registerFactory(
      () => GetExtratoDomainAccountUseCase(
        repository: locator.get<PayFacsRepository>(),
      ),
    );
    locator.registerFactory(
      () => GetSaldoDomainAccountUseCase(
        repository: locator.get<PayFacsRepository>(),
      ),
    );
    locator.registerFactory(
      () => GetTransacoesDomainAccountUseCase(
        repository: locator.get<PayFacsRepository>(),
      ),
    );
    locator.registerFactory(
      () => CashoutViaPixDomainAccountUseCase(
        repository: locator.get<PayFacsRepository>(),
      ),
    );
    locator.registerFactory(
      () => ListChavePixDomainAccountUseCase(
        repository: locator.get<PayFacsRepository>(),
      ),
    );
    locator.registerFactory(
      () => ConsultarAliasDestinatarioUseCase(
        repository: locator.get<PayFacsRepository>(),
      ),
    );
    locator.registerFactory(
      () => GetUltimaTransacaoDomainAccountUseCase(
        repository: locator.get<PayFacsRepository>(),
      ),
    );
  }
}
