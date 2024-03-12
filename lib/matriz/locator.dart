import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/add_config_domain_account_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/add_domain_account_documents_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/get_config_domain_account_by_id_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/get_domain_account_by_id_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/update_config_domain_account_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/update_domain_account_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/update_password_pix_matera_use_case.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia_view_model.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_view_model.dart';
import 'package:viggo_pay_admin/pay_facs/domain/usecases/cashout_via_pix_domain_account_use_case.dart';
import 'package:viggo_pay_admin/pay_facs/domain/usecases/consultar_alias_destinatario_use_case.dart';
import 'package:viggo_pay_admin/pay_facs/domain/usecases/get_saldo_domain_account_use_case.dart';
import 'package:viggo_pay_admin/pay_facs/domain/usecases/get_transacoes_domain_account_use_case.dart';
import 'package:viggo_pay_admin/pay_facs/domain/usecases/get_ultima_transacao_domain_account_use_case.dart';
import 'package:viggo_pay_admin/pay_facs/domain/usecases/list_chave_pix_domain_account_use_case.dart';
import 'package:viggo_pay_admin/pix_to_send/domain/usecases/get_pix_to_send_by_params_use_case.dart';
import 'package:viggo_pay_core_frontend/domain/domain/usecases/get_domain_from_settings_use_case.dart';
import 'package:viggo_pay_core_frontend/localidades/domain/usecases/get_municipio_by_params_use_case.dart';
import 'package:viggo_pay_core_frontend/localidades/domain/usecases/search_cep_use_case.dart';

class MatrizAccountLocator {
  void setup() {
    locator.registerFactory(
      () => MatrizViewModel(
        getMunicipio: locator.get<GetMunicipioByParamsUseCase>(),
        searchCep: locator.get<SearchCepUseCase>(),
        getDomainAccountTaxa: locator.get<GetDomainAccountConfigByIdUseCase>(),
        updateDomainAccount: locator.get<UpdateDomainAccountUseCase>(),
        updateConfigAccount: locator.get<UpdateConfigDomainAccountUseCase>(),
        createConfigAccount: locator.get<AddConfigDomainAccountUseCase>(),
        getDomainAccount: locator.get<GetDomainAccountByIdUseCase>(),
        getDomainFromSettings: locator.get<GetDomainFromSettingsUseCase>(),
        addDomainAccountDocuments:
            locator.get<AddDomainAccountDocumentsUseCase>(),
      ),
    );

    locator.registerLazySingleton(
      () => MatrizTransferenciaViewModel(
        getTransacoes: locator.get<GetTransacoesDomainAccountUseCase>(),
        getConfigDomainAccount:
            locator.get<GetDomainAccountConfigByIdUseCase>(),
        cashout: locator.get<CashoutViaPixDomainAccountUseCase>(),
        updateSenhaPix: locator.get<UpdatePasswordPixUseCase>(),
        getDomainAccount: locator.get<GetDomainAccountByIdUseCase>(),
        getDomainFromSettings: locator.get<GetDomainFromSettingsUseCase>(),
        getSaldo: locator.get<GetSaldoDomainAccountUseCase>(),
        getUltimaTransacao: locator.get<GetUltimaTransacaoDomainAccountUseCase>(),
        listChavePix: locator.get<ListChavePixDomainAccountUseCase>(),
        listChavePixToSends: locator.get<GetPixToSendsByParamsUseCase>(),
        consultarDestinatario: locator.get<ConsultarAliasDestinatarioUseCase>(),
      ),
    );
  }
}
